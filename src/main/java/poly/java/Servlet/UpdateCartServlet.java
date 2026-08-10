package poly.java.Servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import poly.java.Entity.User;
import poly.java.Service.CartService;

import java.io.IOException;

// @WebServlet("/cart/update")
public class UpdateCartServlet extends HttpServlet {

    private final CartService cartService =
            new CartService();

    @Override
    protected void doPost(
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

            int cartItemId =
                    Integer.parseInt(
                            request.getParameter(
                                    "cartItemId"
                            )
                    );

            int quantity =
                    Integer.parseInt(
                            request.getParameter(
                                    "quantity"
                            )
                    );

            if (quantity <= 0) {

                response.sendRedirect(
                        request.getContextPath()
                                + "/cart"
                                + "?error=invalid_quantity"
                );

                return;
            }

            boolean success =
                    cartService.updateQuantity(
                            user,
                            cartItemId,
                            quantity
                    );

            if (success) {

                response.sendRedirect(
                        request.getContextPath()
                                + "/cart"
                                + "?success=update_success"
                );

            } else {

                response.sendRedirect(
                        request.getContextPath()
                                + "/cart"
                                + "?error=out_of_stock"
                );
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/cart"
                            + "?error=invalid_quantity"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                            + "/cart"
                            + "?error=update_failed"
            );
        }
    }
}