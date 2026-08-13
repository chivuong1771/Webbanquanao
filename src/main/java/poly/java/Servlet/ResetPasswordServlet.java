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
import java.security.SecureRandom;
import java.util.UUID;

@WebServlet({"/admin/users/reset-password", "/forgot-password"})
public class ResetPasswordServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAOImpl();
    private static final String CHAR_LOWER = "abcdefghijklmnopqrstuvwxyz";
    private static final String CHAR_UPPER = CHAR_LOWER.toUpperCase();
    private static final String NUMBER = "0123456789";
    private static final String PASSWORD_ALLOW_BASE = CHAR_LOWER + CHAR_UPPER + NUMBER;
    private static final SecureRandom random = new SecureRandom();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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

        // 3. Giả lập / Gửi email mật khẩu ngẫu nhiên tới nhân viên
        boolean emailSent = sendResetEmail(user.getEmail(), newRandomPassword);

        req.setAttribute("successMessage", "Đã cấp lại mật khẩu ngẫu nhiên mới: [" + newRandomPassword + "] cho nhân viên " + user.getEmail() + " và gửi qua Email!");
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

    private boolean sendResetEmail(String recipientEmail, String newPassword) {
        System.out.println("=================================================");
        System.out.println(" [GỬI EMAIL CẤP LẠI MẬT KHẨU NHÂN VIÊN]");
        System.out.println(" Người nhận: " + recipientEmail);
        System.out.println(" Mật khẩu ngẫu nhiên mới: " + newPassword);
        System.out.println(" Nội dung: Mật khẩu mới của bạn là " + newPassword + ". Vui lòng đổi lại sau khi đăng nhập.");
        System.out.println("=================================================");
        return true;
    }
}
