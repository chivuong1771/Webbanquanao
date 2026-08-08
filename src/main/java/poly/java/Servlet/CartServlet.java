package poly.java.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import poly.java.DAO.CartDAO;
import poly.java.DAO.CartDetailDAO;
import poly.java.DAO.ProductVariantDAO;
import poly.java.DAO.Impl.CartDAOImpl;
import poly.java.DAO.Impl.CartDetailDAOImpl;
import poly.java.DAO.Impl.ProductVariantDAOImpl;
import poly.java.Entity.Cart;
import poly.java.Entity.CartDetail;
import poly.java.Entity.ProductVariant;
import poly.java.Entity.User;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet({"/cart", "/cart/add", "/cart/update", "/cart/remove"})
public class CartServlet extends HttpServlet {

    private final CartDAO cartDAO = new CartDAOImpl();
    private final CartDetailDAO cartDetailDAO = new CartDetailDAOImpl();
    private final ProductVariantDAO variantDAO = new ProductVariantDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("currentUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String path = req.getServletPath();

        if ("/cart/remove".equals(path)) {
            String idStr = req.getParameter("id");
            if (idStr != null) {
                try {
                    int detailId = Integer.parseInt(idStr);
                    cartDetailDAO.delete(detailId);
                    resp.sendRedirect(req.getContextPath() + "/cart?success=remove_success");
                    return;
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        Cart cart = getOrCreateCart(user);
        List<CartDetail> cartItems = cartDetailDAO.findByCart(cart.getId());

        BigDecimal subTotal = BigDecimal.ZERO;
        for (CartDetail item : cartItems) {
            subTotal = subTotal.add(item.getTotalAmount());
        }

        req.setAttribute("cartItems", cartItems);
        req.setAttribute("subTotal", subTotal);
        req.getRequestDispatcher("/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("currentUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String path = req.getServletPath();

        if ("/cart/add".equals(path)) {
            String variantIdStr = req.getParameter("variantId");
            String productIdStr = req.getParameter("productId");
            String color = req.getParameter("color");
            String size = req.getParameter("size");
            String qtyStr = req.getParameter("quantity");

            int quantity = 1;
            if (qtyStr != null && !qtyStr.isBlank()) {
                try {
                    quantity = Math.max(1, Integer.parseInt(qtyStr));
                } catch (NumberFormatException ignored) {}
            }

            ProductVariant variant = null;

            if (variantIdStr != null && !variantIdStr.isBlank()) {
                try {
                    int variantId = Integer.parseInt(variantIdStr);
                    variant = variantDAO.findById(variantId);
                } catch (Exception ignored) {}
            }

            if (variant == null && productIdStr != null && !productIdStr.isBlank()) {
                try {
                    int productId = Integer.parseInt(productIdStr);
                    variant = variantDAO.findByProductColorSize(productId, color, size);
                } catch (Exception ignored) {}
            }

            if (variant != null) {
                try {
                    Cart cart = getOrCreateCart(user);
                    CartDetail existing = cartDetailDAO.findByCartAndVariant(cart.getId(), variant.getId());
                    if (existing != null) {
                        existing.setQuantity(existing.getQuantity() + quantity);
                        cartDetailDAO.update(existing);
                    } else {
                        CartDetail cd = new CartDetail();
                        cd.setCartID(cart);
                        cd.setVariantID(variant);
                        cd.setQuantity(quantity);
                        cartDetailDAO.create(cd);
                    }
                    resp.sendRedirect(req.getContextPath() + "/cart");
                    return;
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            resp.sendRedirect(req.getContextPath() + "/products");
            return;
        }

        if ("/cart/update".equals(path)) {
            String itemIdStr = req.getParameter("cartItemId");
            String qtyStr = req.getParameter("quantity");
            if (itemIdStr != null && qtyStr != null) {
                try {
                    int detailId = Integer.parseInt(itemIdStr);
                    int quantity = Integer.parseInt(qtyStr);
                    CartDetail detail = cartDetailDAO.findById(detailId);
                    if (detail != null) {
                        if (quantity > 0) {
                            detail.setQuantity(quantity);
                            cartDetailDAO.update(detail);
                        } else {
                            cartDetailDAO.delete(detailId);
                        }
                    }
                    resp.sendRedirect(req.getContextPath() + "/cart?success=update_success");
                    return;
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            resp.sendRedirect(req.getContextPath() + "/cart");
        }
    }

    private Cart getOrCreateCart(User user) {
        Cart cart = cartDAO.findByUser(user.getId());
        if (cart == null) {
            cart = new Cart();
            cart.setUserID(user);
            cart = cartDAO.create(cart);
        }
        return cart;
    }
}
