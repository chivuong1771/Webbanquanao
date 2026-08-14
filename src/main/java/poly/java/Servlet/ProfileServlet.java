package poly.java.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import poly.java.DAO.AddressDAO;
import poly.java.DAO.UserDAO;
import poly.java.DAO.Impl.AddressDAOImpl;
import poly.java.DAO.Impl.UserDAOImpl;
import poly.java.Entity.Address;
import poly.java.Entity.User;

import java.io.IOException;

@WebServlet({"/profile", "/profile/update", "/profile/change-password"})
public class ProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAOImpl();
    private final AddressDAO addressDAO = new AddressDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("currentUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        req.getRequestDispatcher("/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("currentUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String path = req.getServletPath();

        // -------------------------------------------------------------
        // 1. XỬ LÝ ĐỔI MẬT KHẨU
        // -------------------------------------------------------------
        if ("/profile/change-password".equals(path)) {
            String currentPassword = req.getParameter("currentPassword");
            String newPassword = req.getParameter("newPassword");
            String confirmPassword = req.getParameter("confirmPassword");

            // Kiểm tra rỗng
            if (currentPassword == null || currentPassword.isBlank() ||
                    newPassword == null || newPassword.isBlank() ||
                    confirmPassword == null || confirmPassword.isBlank()) {
                resp.sendRedirect(req.getContextPath() + "/profile?error=missing_pw_fields");
                return;
            }

            // Kiểm tra mật khẩu hiện tại
            if (!user.getPassword().equals(currentPassword)) {
                resp.sendRedirect(req.getContextPath() + "/profile?error=wrong_current_pw");
                return;
            }

            // Kiểm tra mật khẩu mới và xác nhận mật khẩu
            if (!newPassword.equals(confirmPassword)) {
                resp.sendRedirect(req.getContextPath() + "/profile?error=pw_mismatch");
                return;
            }

            try {
                user.setPassword(newPassword);
                User updatedUser = userDAO.update(user);
                req.getSession().setAttribute("currentUser", updatedUser);

                resp.sendRedirect(req.getContextPath() + "/profile?success=pw_change_ok");
                return;
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/profile?error=pw_change_failed");
                return;
            }
        }

        // -------------------------------------------------------------
        // 2. XỬ LÝ CẬP NHẬT THÔNG TIN CÁ NHÂN
        // -------------------------------------------------------------
        if ("/profile/update".equals(path) || "/profile".equals(path)) {
            String fullname = req.getParameter("fullname");
            String phone = req.getParameter("phone");
            String addressStr = req.getParameter("address");
            String avatar = req.getParameter("avatar");

            if (fullname == null || fullname.isBlank()) {
                resp.sendRedirect(req.getContextPath() + "/profile?error=missing_fullname");
                return;
            }

            try {
                user.setFullName(fullname);
                user.setPhone(phone);
                user.setAvatar(avatar);

                User updatedUser = userDAO.update(user);
                req.getSession().setAttribute("currentUser", updatedUser);

                if (addressStr != null) {
                    Address defaultAddr = addressDAO.findDefaultAddress(updatedUser.getId());
                    if (defaultAddr != null) {
                        defaultAddr.setAddressDetail(addressStr);
                        defaultAddr.setPhone(phone);
                        defaultAddr.setReceiverName(fullname);
                        addressDAO.update(defaultAddr);
                    } else if (!addressStr.isBlank()) {
                        Address newAddr = new Address();
                        newAddr.setUserID(updatedUser);
                        newAddr.setAddressDetail(addressStr);
                        newAddr.setReceiverName(fullname);
                        newAddr.setPhone(phone);
                        newAddr.setIsDefault(true);
                        addressDAO.create(newAddr);
                    }
                }

                resp.sendRedirect(req.getContextPath() + "/profile?success=update_ok");
                return;

            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/profile?error=update_failed");
                return;
            }
        }

        resp.sendRedirect(req.getContextPath() + "/profile");
    }
}