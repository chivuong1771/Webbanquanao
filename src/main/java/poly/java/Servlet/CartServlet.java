package poly.java.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import poly.java.DAO.CartDAO;
import poly.java.DAO.CartDetailDAO;
import poly.java.DAO.Impl.CartDAOImpl;
import poly.java.DAO.Impl.CartDetailDAOImpl;
import poly.java.Entity.Cart;
import poly.java.Entity.CartDetail;
import poly.java.Entity.User;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private final CartDAO cartDAO = new CartDAOImpl();
    private final CartDetailDAO cartDetailDAO = new CartDetailDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("currentUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
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

    public static Cart getOrCreateCart(User user, CartDAO cartDAO) {
        Cart cart = cartDAO.findByUser(user.getId());
        if (cart == null) {
            cart = new Cart();
            cart.setUserID(user);
            cart = cartDAO.create(cart);
        }
        return cart;
    }

    private Cart getOrCreateCart(User user) {
        return getOrCreateCart(user, cartDAO);
    }
}
