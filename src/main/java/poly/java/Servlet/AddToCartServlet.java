package poly.java.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import poly.java.Entity.ProductVariant;
import poly.java.Entity.User;
import poly.java.Service.CartService;

import java.io.IOException;

@WebServlet("/cart/add")
public class AddToCartServlet extends HttpServlet {

    private final CartService cartService =
            new CartService();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession();

        User user =
                (User) session.getAttribute(
                        "currentUser"
                );

        if (user == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/login"
            );

            return;
        }

        try {

            int variantId =
                    Integer.parseInt(
                            request.getParameter(
                                    "variantId"
                            )
                    );

            int quantity =
                    Integer.parseInt(
                            request.getParameter(
                                    "quantity"
                            )
                    );

            /*
             * Lấy ProductVariant bằng DAO
             * của Dev 3.
             */

            // ProductVariant variant =
            //         productVariantDAO
            //         .findById(variantId);

            /*
             * Sau khi có ProductVariant:
             *
             * cartService.addToCart(
             *     user,
             *     variant,
             *     quantity
             * );
             */

            response.sendRedirect(
                    request.getContextPath()
                            + "/cart"
            );

        } catch (Exception e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Không thể thêm sản phẩm vào giỏ"
            );
        }
    }
}