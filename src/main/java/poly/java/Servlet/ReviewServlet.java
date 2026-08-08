package poly.java.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import poly.java.Entity.Product;
import poly.java.Entity.Review;
import poly.java.Entity.User;
import poly.java.Service.ReviewService;

import java.io.IOException;
import java.util.List;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {

    private final ReviewService reviewService =
            new ReviewService();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int productId =
                    Integer.parseInt(
                            request.getParameter(
                                    "productId"
                            )
                    );

            /*
             * Bạn dùng ProductDAO hiện tại
             * của project để lấy Product.
             */

            // Product product =
            //         productDAO.findById(productId);

            /*
             * Tạm thời phần này phải nối
             * với ProductDAO của bạn.
             */

            request.setAttribute(
                    "productId",
                    productId
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/product-review.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(
                    400,
                    "Không thể tải đánh giá"
            );
        }
    }


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

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

            int productId =
                    Integer.parseInt(
                            request.getParameter(
                                    "productId"
                            )
                    );

            int rating =
                    Integer.parseInt(
                            request.getParameter(
                                    "rating"
                            )
                    );

            String comment =
                    request.getParameter(
                            "comment"
                    );

            /*
             * Lấy Product bằng ProductDAO.
             */

            // Product product =
            //         productDAO.findById(productId);

            /*
             * Sau đó:
             *
             * reviewService.addReview(
             *     user,
             *     product,
             *     rating,
             *     comment
             * );
             */

            response.sendRedirect(
                    request.getContextPath()
                            + "/product-detail?id="
                            + productId
                            + "&success=review_success"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                            + "/product-detail"
                            + "?error=review_failed"
            );
        }
    }
}