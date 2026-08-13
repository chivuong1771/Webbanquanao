package poly.java.Filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import poly.java.Entity.User;

import java.io.IOException;

@WebFilter("/admin/*") // Áp dụng bảo mật cho toàn bộ đường dẫn bắt đầu bằng /admin/
public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession();

        User currentUser = (User) session.getAttribute("currentUser");

        // Kiểm tra xem đã đăng nhập chưa VÀ có phải ADMIN không
        if (currentUser != null && currentUser.getRoleID() != null
                && "ADMIN".equalsIgnoreCase(currentUser.getRoleID().getRoleName())) {
            // Hợp lệ -> Cho phép đi tiếp vào trang Admin
            chain.doFilter(request, response);
        } else {
            // Không hợp lệ -> Đẩy về trang đăng nhập
            resp.sendRedirect(req.getContextPath() + "/login");
        }
    }
}