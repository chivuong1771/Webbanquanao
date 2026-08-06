package poly.java.Servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import poly.java.Entity.User;
import poly.java.Service.WishlistService;

import java.io.IOException;

@WebServlet("/wishlist/remove")
public class WishlistRemoveServlet extends HttpServlet {

    private final WishlistService wishlistService =
            new WishlistService();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        HttpSession session =
                request.getSession();

        User user =
                (User) session.getAttribute("currentUser");

        // Chưa đăng nhập
        if (user == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/login"
            );

            return;
        }

        try {

            int wishlistId =
                    Integer.parseInt(
                            request.getParameter("id")
                    );

            boolean success =
                    wishlistService.remove(
                            user,
                            wishlistId
                    );

            if (success) {

                response.sendRedirect(
                        request.getContextPath()
                                + "/wishlist"
                                + "?success=remove_success"
                );

            } else {

                response.sendRedirect(
                        request.getContextPath()
                                + "/wishlist"
                                + "?error=remove_failed"
                );
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/wishlist"
                            + "?error=invalid_id"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                            + "/wishlist"
                            + "?error=remove_failed"
            );
        }
    }
}