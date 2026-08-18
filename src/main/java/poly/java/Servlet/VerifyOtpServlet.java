package poly.java.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import poly.java.DAO.UserDAO;
import poly.java.DAO.Impl.UserDAOImpl;
import poly.java.Entity.User;

import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/verify-otp")
public class VerifyOtpServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email = req.getParameter("email");
        req.setAttribute("email", email);
        req.getRequestDispatcher("/WEB-INF/views/verify-otp.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email");
        String inputOtp = req.getParameter("otp");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        req.setAttribute("email", email);

        // 1. Validation cơ bản
        if (inputOtp == null || inputOtp.trim().isEmpty() ||
                newPassword == null || newPassword.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập đầy đủ Mã OTP và Mật khẩu mới!");
            req.getRequestDispatcher("/WEB-INF/views/verify-otp.jsp").forward(req, resp);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            req.getRequestDispatcher("/WEB-INF/views/verify-otp.jsp").forward(req, resp);
            return;
        }

        // 2. Tìm User theo Email
        User user = (email != null && !email.trim().isEmpty()) ? userDAO.findByEmail(email.trim()) : null;

        // Đã sửa: Sử dụng getResetToken() và getTokenExpiry() theo đúng User.java
        if (user == null || user.getResetToken() == null || user.getTokenExpiry() == null) {
            req.setAttribute("error", "Yêu cầu không hợp lệ hoặc đã hết hạn!");
            req.getRequestDispatcher("/WEB-INF/views/verify-otp.jsp").forward(req, resp);
            return;
        }

        // 3. Kiểm tra OTP hết hạn (Dùng LocalDateTime)
        if (user.getTokenExpiry().isBefore(LocalDateTime.now())) {
            req.setAttribute("error", "Mã OTP đã hết hạn! Vui lòng yêu cầu mã mới.");
            req.getRequestDispatcher("/WEB-INF/views/verify-otp.jsp").forward(req, resp);
            return;
        }

        // 4. Kiểm tra khớp OTP
        if (!user.getResetToken().equals(inputOtp.trim())) {
            req.setAttribute("error", "Mã OTP không chính xác!");
            req.getRequestDispatcher("/WEB-INF/views/verify-otp.jsp").forward(req, resp);
            return;
        }

        // 5. Đổi mật khẩu thành công -> Xóa mã OTP và hết hạn trong DB
        user.setPassword(newPassword.trim());
        user.setResetToken(null);
        user.setTokenExpiry(null);
        userDAO.update(user);

        req.setAttribute("message", "Đổi mật khẩu thành công! Vui lòng đăng nhập.");
        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }
}