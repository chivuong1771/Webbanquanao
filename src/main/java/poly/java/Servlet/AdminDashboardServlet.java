package poly.java.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import poly.java.DAO.CategoryDAO;
import poly.java.DAO.CouponDAO;
import poly.java.DAO.OrderDAO;
import poly.java.DAO.ProductDAO;
import poly.java.DAO.UserDAO;
import poly.java.DAO.Impl.CategoryDAOImpl;
import poly.java.DAO.Impl.CouponDAOImpl;
import poly.java.DAO.Impl.OrderDAOImpl;
import poly.java.DAO.Impl.ProductDAOImpl;
import poly.java.DAO.Impl.UserDAOImpl;
import poly.java.Entity.Order;
import poly.java.Entity.Product;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAOImpl();
    private final ProductDAO productDAO = new ProductDAOImpl();
    private final UserDAO userDAO = new UserDAOImpl();
    private final CategoryDAO categoryDAO = new CategoryDAOImpl();
    private final CouponDAO couponDAO = new CouponDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            long totalProducts = productDAO.findAll().size();
            long totalOrders = orderDAO.countTotalOrders();
            long totalUsers = userDAO.findAll().size();
            long totalCategories = categoryDAO.findAll().size();
            long totalCoupons = couponDAO.findAll().size();

            // Tính doanh thu 30 ngày gần nhất
            var startInstant = LocalDate.now().minusDays(30).atStartOfDay(ZoneId.systemDefault()).toInstant();
            var endInstant = LocalDate.now().atTime(23, 59, 59).atZone(ZoneId.systemDefault()).toInstant();
            BigDecimal totalRevenue = orderDAO.calculateRevenue(startInstant, endInstant);

            // Lấy 5 đơn hàng gần nhất & 5 sản phẩm gần nhất
            List<Order> recentOrders = orderDAO.findAllPaginated(1, 5);
            List<Product> recentProducts = productDAO.findAll();
            if (recentProducts.size() > 5) {
                recentProducts = recentProducts.subList(0, 5);
            }

            req.setAttribute("totalProducts", totalProducts);
            req.setAttribute("totalOrders", totalOrders);
            req.setAttribute("totalUsers", totalUsers);
            req.setAttribute("totalCategories", totalCategories);
            req.setAttribute("totalCoupons", totalCoupons);
            req.setAttribute("totalRevenue", totalRevenue != null ? totalRevenue : BigDecimal.ZERO);
            req.setAttribute("recentOrders", recentOrders);
            req.setAttribute("recentProducts", recentProducts);
        } catch (Exception e) {
            e.printStackTrace();
        }

        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }
}