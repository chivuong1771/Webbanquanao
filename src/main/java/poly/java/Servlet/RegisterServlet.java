package poly.java.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import poly.java.DAO.UserDAO;
import poly.java.DAO.Impl.UserDAOImpl;
import poly.java.Entity.Role;
import poly.java.Entity.User;

import java.io.IOException;
import java.time.Instant;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Chuyển hướng tới giao diện Đăng ký
        req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        // 1. Kiểm tra Mật khẩu nhập lại
        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            req.setAttribute("fullName", fullName);
            req.setAttribute("email", email);
            req.setAttribute("phone", phone);
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
            return;
        }

        // 2. Kiểm tra Email đã tồn tại chưa
        if (userDAO.existsByEmail(email)) {
            req.setAttribute("error", "Email này đã được sử dụng!");
            req.setAttribute("fullName", fullName);
            req.setAttribute("phone", phone);
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
            return;
        }

        try {
            // 3. Tạo đối tượng User mới
            User newUser = new User();
            newUser.setFullName(fullName);
            newUser.setEmail(email);
            newUser.setPhone(phone);
            newUser.setPassword(password); // Nên mã hóa nếu dự án yêu cầu (VD: BCrypt)
            newUser.setStatus(true);
            newUser.setCreatedAt(Instant.now());

            // Gán Role mặc định (Ví dụ: ID 2 là USER / Khách hàng)
            Role userRole = new Role();
            userRole.setId(2); // Thay ID đúng với mã quyền Khách hàng trong bảng Roles của bạn
            newUser.setRoleID(userRole);

            // 4. Lưu vào Database
            userDAO.create(newUser);

            // Đăng ký thành công -> Đẩy về trang Đăng nhập kèm thông báo
            req.setAttribute("message", "Đăng ký tài khoản thành công! Vui lòng đăng nhập.");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Đã xảy ra lỗi trong quá trình đăng ký. Vui lòng thử lại!");
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
        }
    }
}