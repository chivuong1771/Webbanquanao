package poly.java.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import poly.java.DAO.CouponDAO;
import poly.java.DAO.Impl.CouponDAOImpl;
import poly.java.Entity.Coupon;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet({"/admin/coupons", "/admin/coupon/create", "/admin/coupon/edit", "/admin/coupon/delete"})
public class AdminCouponServlet extends HttpServlet {

    private final CouponDAO couponDAO = new CouponDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/admin/coupon/edit".equals(path)) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                Coupon coupon = couponDAO.findById(id);
                req.setAttribute("coupon", coupon);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if ("/admin/coupon/delete".equals(path)) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                couponDAO.delete(id);
            } catch (Exception e) {
                e.printStackTrace();
            }
            resp.sendRedirect(req.getContextPath() + "/admin/coupons");
            return;
        }

        List<Coupon> coupons = couponDAO.findAll();
        req.setAttribute("coupons", coupons);
        req.getRequestDispatcher("/WEB-INF/views/admin/coupons.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String idStr = req.getParameter("id");
        String code = req.getParameter("code");
        String couponName = req.getParameter("couponName");
        String discountType = req.getParameter("discountType");
        String discountValueStr = req.getParameter("discountValue");
        String minimumOrderStr = req.getParameter("minimumOrder");
        String quantityStr = req.getParameter("quantity");
        boolean status = req.getParameter("status") != null;

        Coupon coupon = new Coupon();
        if (idStr != null && !idStr.isBlank()) {
            coupon.setId(Integer.parseInt(idStr));
        }
        coupon.setCode(code);
        coupon.setCouponName(couponName);
        coupon.setDiscountType(discountType);
        coupon.setStatus(status);

        if (discountValueStr != null && !discountValueStr.isBlank()) {
            coupon.setDiscountValue(new BigDecimal(discountValueStr));
        }
        if (minimumOrderStr != null && !minimumOrderStr.isBlank()) {
            coupon.setMinimumOrder(new BigDecimal(minimumOrderStr));
        }
        if (quantityStr != null && !quantityStr.isBlank()) {
            coupon.setQuantity(Integer.parseInt(quantityStr));
        }

        if (coupon.getId() != null) {
            couponDAO.update(coupon);
        } else {
            couponDAO.create(coupon);
        }

        resp.sendRedirect(req.getContextPath() + "/admin/coupons");
    }
}
