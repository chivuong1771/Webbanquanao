package poly.java.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import poly.java.DAO.CartDetailDAO;
import poly.java.DAO.Impl.CartDetailDAOImpl;
import poly.java.Entity.User;

import java.io.IOException;

@WebServlet("/cart/remove")
public class RemoveCartServlet extends HttpServlet {

    private final CartDetailDAO cartDetailDAO = new CartDetailDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("currentUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

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
    }
}