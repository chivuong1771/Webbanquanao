package poly.java.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import poly.java.DAO.Impl.UserDAOImpl;
import poly.java.DAO.UserDAO;
import poly.java.Utils.EmailUtils;

import java.io.IOException;
import java.security.SecureRandom;
import java.time.LocalDateTime;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final UserDAO userDAO = new UserDAOImpl();
    private static final SecureRandom random = new SecureRandom();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");

        // 1. Kiểm tra đầu vào
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập địa chỉ email!");
            request.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(request, response);
            return;
        }

        email = email.trim();

        // 2. Kiểm tra email trong Database
        boolean checkEmail = userDAO.checkEmailExist(email);

        if (checkEmail) {
            try {
                // 3. Sinh mã OTP ngẫu nhiên 6 chữ số (từ 100000 đến 999999)
                int otpNum = 100000 + random.nextInt(900000);
                String otp = String.valueOf(otpNum);

                // 4. Đặt thời gian hết hạn là 5 phút
                LocalDateTime expiry = LocalDateTime.now().plusMinutes(5);

                // 5. Lưu mã OTP vào cột resetToken và thời gian hết hạn vào tokenExpiry trong DB
                userDAO.updateResetToken(email, otp, expiry);

                // 6. Nội dung Email gửi mã OTP
                String emailBody = "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #e0e0e0; border-radius: 8px; max-width: 500px;'>"
                        + "<h2 style='color: #007bff; text-align: center;'>KHÔI PHỤC MẬT KHẨU</h2>"
                        + "<p>Xin chào,</p>"
                        + "<p>Mã xác thực OTP để đặt lại mật khẩu tài khoản của bạn là:</p>"
                        + "<div style='text-align: center; margin: 20px 0;'>"
                        + "<span style='font-size: 28px; font-weight: bold; letter-spacing: 5px; color: #d9534f; background: #f8f9fa; padding: 10px 20px; border-radius: 5px; border: 1px dashed #d9534f;'>"
                        + otp + "</span>"
                        + "</div>"
                        + "<p>Mã này có hiệu lực trong vòng <b>5 phút</b>. Vui lòng tuyệt đối không chia sẻ mã này cho bất kỳ ai.</p>"
                        + "</div>";

                // 7. Gửi email
                EmailUtils.sendEmail(getServletContext(), email, "[Fashion Shop] Mã Xác Thực OTP Đặt Lại Mật Khẩu", emailBody);

                // 8. Chuyển hướng người dùng sang Servlet xác thực OTP kèm parameter email
                response.sendRedirect(request.getContextPath() + "/verify-otp?email=" + email);
                return;

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Có lỗi xảy ra khi gửi email: " + e.getMessage());
            }
        } else {
            request.setAttribute("error", "Email không tồn tại trong hệ thống!");
            request.setAttribute("email", email);
        }

        request.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(request, response);
    }
}