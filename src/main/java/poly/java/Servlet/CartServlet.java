package poly.java.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import poly.java.DTO.CartItemDTO;
import poly.java.Entity.User;
import poly.java.Service.CartService;

import java.io.IOException;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private final CartService cartService = new CartService();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("currentUser");

        // Chưa đăng nhập
        if (user == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
            return;
        }

        try {

            // Lấy danh sách sản phẩm trong giỏ
            List<CartItemDTO> cartItems =
                    cartService.getCartItems(user);

            // Tính tổng tiền
            var subTotal =
                    cartService.calculateSubTotal(cartItems);

            request.setAttribute(
                    "cartItems",
                    cartItems
            );

            request.setAttribute(
                    "subTotal",
                    subTotal
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/cart.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Không thể tải giỏ hàng"
            );
        }
    }
}