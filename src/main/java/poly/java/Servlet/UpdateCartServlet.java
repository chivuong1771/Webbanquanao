package poly.java.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import poly.java.DAO.CartDetailDAO;
import poly.java.DAO.Impl.CartDetailDAOImpl;
import poly.java.Entity.CartDetail;
import poly.java.Entity.User;

import java.io.IOException;

@WebServlet("/cart/update")
public class UpdateCartServlet extends HttpServlet {

    private final CartDetailDAO cartDetailDAO = new CartDetailDAOImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("currentUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

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