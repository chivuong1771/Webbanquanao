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

@WebServlet("/cart/add")
public class AddToCartServlet extends HttpServlet {

    private final CartDAO cartDAO = new CartDAOImpl();
    private final CartDetailDAO cartDetailDAO = new CartDetailDAOImpl();
    private final ProductVariantDAO variantDAO = new ProductVariantDAOImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("currentUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

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
                Cart cart = CartServlet.getOrCreateCart(user, cartDAO);
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
    }
}