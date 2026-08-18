package poly.java.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import poly.java.DAO.UserDAO;
import poly.java.DAO.Impl.UserDAOImpl;
import poly.java.Entity.User;
import poly.java.Utils.EmailUtils;

import java.io.IOException;
import java.security.SecureRandom;

// Chỉ giữ lại endpoint dành cho Reset Password
@WebServlet({"/admin/users/reset-password", "/reset-password"})
public class ResetPasswordServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAOImpl();
    private static final String CHAR_LOWER = "abcdefghijklmnopqrstuvwxyz";
    private static final String CHAR_UPPER = CHAR_LOWER.toUpperCase();
    private static final String NUMBER = "0123456789";
    private static final String PASSWORD_ALLOW_BASE = CHAR_LOWER + CHAR_UPPER + NUMBER;
    private static final SecureRandom random = new SecureRandom();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email");
        String userIdStr = req.getParameter("userId");

        User user = null;
        if (userIdStr != null && !userIdStr.isBlank()) {
            try {
                int id = Integer.parseInt(userIdStr);
                user = userDAO.findById(id);
            } catch (Exception ignored) {}
        }

        if (user == null && email != null && !email.isBlank()) {
            user = userDAO.findByEmail(email.trim());
        }

        if (user == null) {
            req.setAttribute("errorMessage", "Không tìm thấy tài khoản nhân viên / người dùng!");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        // 1. Tạo mật khẩu ngẫu nhiên mới (8 ký tự)
        String newRandomPassword = generateRandomPassword(8);

        // 2. Lưu mật khẩu mới vào database
        user.setPassword(newRandomPassword);
        userDAO.update(user);

        // 3. Gửi email mật khẩu ngẫu nhiên tới người dùng
        boolean emailSent = sendResetEmail(req.getServletContext(), user.getEmail(), newRandomPassword);

        if (emailSent) {
            req.setAttribute("successMessage", "Đã cấp lại mật khẩu mới cho " + user.getEmail() + " và gửi thành công qua Email!");
        } else {
            req.setAttribute("errorMessage", "Đã cập nhật mật khẩu mới [" + newRandomPassword + "] nhưng gửi Email thất bại!");
        }

        req.setAttribute("newPassword", newRandomPassword);
        req.setAttribute("resetUser", user);

        String referer = req.getHeader("Referer");
        if (referer != null && referer.contains("admin")) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?success=reset_password&email=" + user.getEmail() + "&newPass=" + newRandomPassword);
        } else {
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }

    private String generateRandomPassword(int length) {
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            int rndCharAt = random.nextInt(PASSWORD_ALLOW_BASE.length());
            char rndChar = PASSWORD_ALLOW_BASE.charAt(rndCharAt);
            sb.append(rndChar);
        }
        return sb.toString();
    }

    private boolean sendResetEmail(jakarta.servlet.ServletContext context, String recipientEmail, String newPassword) {
        try {
            String subject = "Cấp lại mật khẩu tài khoản";
            String body = "<div style='font-family: Arial, sans-serif; padding: 20px;'>"
                    + "<h3>Kính gửi người dùng,</h3>"
                    + "<p>Mật khẩu truy cập hệ thống của bạn đã được khởi tạo lại.</p>"
                    + "<p>Mật khẩu mới của bạn là: <strong style='color: #d9534f; font-size: 18px;'>" + newPassword + "</strong></p>"
                    + "<p>Vui lòng đăng nhập và đổi lại mật khẩu ngay để đảm bảo an toàn.</p>"
                    + "</div>";

            EmailUtils.sendEmail(context, recipientEmail, subject, body);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}