package poly.java.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import poly.java.DAO.UserDAO;
import poly.java.DAO.Impl.UserDAOImpl;
import poly.java.Entity.User;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Nếu người dùng đã đăng nhập rồi thì chuyển hướng thẳng về trang chủ
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        // 1. Validation dữ liệu đầu vào
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập đầy đủ email và mật khẩu!");
            req.setAttribute("email", email != null ? email.trim() : "");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
            return;
        }

        email = email.trim();
        password = password.trim();

        // 2. Thực hiện đăng nhập qua DAO
        User user = userDAO.login(email, password);

        if (user != null) {
            // 3. Kiểm tra trạng thái tài khoản (nếu status = false/0 nghĩa là đã bị khóa)
            if (Boolean.FALSE.equals(user.getStatus())) {
                req.setAttribute("error", "Tài khoản của bạn đã bị khóa! Vui lòng liên hệ quản trị viên.");
                req.setAttribute("email", email);
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
                return;
            }

            // 4. Tạo session mới và lưu thông tin đăng nhập
            HttpSession session = req.getSession();
            session.setAttribute("currentUser", user);

            // Chuyển hướng tới trang chủ (hoặc URL mà người dùng cố gắng truy cập trước đó)
            resp.sendRedirect(req.getContextPath() + "/");
        } else {
            // 5. Đăng nhập thất bại
            req.setAttribute("error", "Email hoặc mật khẩu không chính xác!");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
        }
    }
}