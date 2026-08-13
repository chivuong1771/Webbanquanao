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
import java.util.List;

@WebServlet({"/admin/users"})
public class UserManagementServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        String email = req.getParameter("email");
        String statusStr = req.getParameter("status");
        String pageStr = req.getParameter("page");

        Boolean status = null;
        if (statusStr != null && !statusStr.isBlank()) {
            status = Boolean.parseBoolean(statusStr);
        }

        int page = 1;
        int pageSize = 10; // Mỗi trang 10 sản phẩm/nhân viên theo yêu cầu đề bài Lab 5

        if (pageStr != null && !pageStr.isBlank()) {
            try {
                page = Math.max(1, Integer.parseInt(pageStr));
            } catch (NumberFormatException ignored) {}
        }

        List<User> userList = userDAO.searchUsers(keyword, email, status, page, pageSize);
        long totalUsers = userDAO.countSearchUsers(keyword, email, status);
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);
        if (totalPages < 1) totalPages = 1;

        req.setAttribute("users", userList);
        req.setAttribute("keyword", keyword);
        req.setAttribute("email", email);
        req.setAttribute("status", statusStr);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalUsers", totalUsers);

        req.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(req, resp);
    }
}
