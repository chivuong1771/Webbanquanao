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
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                .forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email").trim();
        String password = req.getParameter("password").trim();

        System.out.println("--- DEBUG LOGIN ---");
        System.out.println("Email nhập: " + email);
        System.out.println("Password nhập: " + password);

        User user = userDAO.login(email, password);

        if (user != null) {
            System.out.println("Đăng nhập thành công! User ID: " + user.getId());
            req.getSession().setAttribute("currentUser", user);
            resp.sendRedirect(req.getContextPath() + "/");
        } else {
            System.out.println("Đăng nhập thất bại: Không tìm thấy User phù hợp trong DB!");
            req.setAttribute("error", "Email hoặc mật khẩu không chính xác!");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
        }

    }
}