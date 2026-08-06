package poly.java.Servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import poly.java.Entity.User;
import poly.java.Service.CartService;

import java.io.IOException;

@WebServlet("/cart/remove")
public class RemoveCartServlet extends HttpServlet {

    private final CartService cartService =
            new CartService();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        HttpSession session =
                request.getSession();

        User user =
                (User) session.getAttribute("currentUser");

        if (user == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/login"
            );

            return;
        }

        try {

            int cartDetailId =
                    Integer.parseInt(
                            request.getParameter("id")
                    );

            cartService.removeItem(
                    user,
                    cartDetailId
            );

            response.sendRedirect(
                    request.getContextPath()
                            + "/cart"
                            + "?success=remove_success"
            );

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/cart"
                            + "?error=invalid_id"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                            + "/cart"
                            + "?error=remove_failed"
            );
        }
    }
}