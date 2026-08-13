package poly.java.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Lấy session hiện tại
        HttpSession session = req.getSession(false);

        if (session != null) {
            // Hủy toàn bộ session (xóa đăng nhập)
            session.invalidate();
        }

        // Điều hướng về trang đăng nhập
        resp.sendRedirect(req.getContextPath() + "/login");
    }
}