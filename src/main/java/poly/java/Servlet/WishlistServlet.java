package poly.java.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import poly.java.Entity.User;
import poly.java.Entity.Wishlist;
import poly.java.Service.WishlistService;

import java.io.IOException;
import java.util.List;

@WebServlet("/wishlist")
public class WishlistServlet extends HttpServlet {

    private final WishlistService wishlistService =
            new WishlistService();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

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

            List<Wishlist> wishlistItems =
                    wishlistService.getByUser(user);

            request.setAttribute(
                    "wishlistItems",
                    wishlistItems
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/wishlist.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Không thể tải danh sách yêu thích"
            );
        }
    }
}