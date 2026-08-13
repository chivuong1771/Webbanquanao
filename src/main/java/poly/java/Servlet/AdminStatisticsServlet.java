package poly.java.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import poly.java.DAO.OrderDAO;
import poly.java.DAO.ProductDAO;
import poly.java.DAO.UserDAO;
import poly.java.DAO.Impl.OrderDAOImpl;
import poly.java.DAO.Impl.ProductDAOImpl;
import poly.java.DAO.Impl.UserDAOImpl;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet({"/admin/statistics", "/admin/dashboard"})
public class AdminStatisticsServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAOImpl();
    private final ProductDAO productDAO = new ProductDAOImpl();
    private final UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String startDateStr = req.getParameter("startDate");
        String endDateStr = req.getParameter("endDate");

        LocalDate startDate = null;
        LocalDate endDate = null;

        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        if (startDateStr != null && !startDateStr.isBlank()) {
            try {
                startDate = LocalDate.parse(startDateStr, dtf);
            } catch (Exception ignored) {}
        }
        if (endDateStr != null && !endDateStr.isBlank()) {
            try {
                endDate = LocalDate.parse(endDateStr, dtf);
            } catch (Exception ignored) {}
        }

        // Mặc định khoảng thời gian 30 ngày gần nhất nếu chưa chọn
        if (startDate == null) {
            startDate = LocalDate.now().minusDays(30);
        }
        if (endDate == null) {
            endDate = LocalDate.now();
        }

        var startInstant = startDate.atStartOfDay(ZoneId.systemDefault()).toInstant();
        var endInstant = endDate.atTime(23, 59, 59).atZone(ZoneId.systemDefault()).toInstant();

        // Bài 2: Thống kê 5 thức uống / sản phẩm bán chạy nhất theo khoảng thời gian
        List<Object[]> top5Selling = orderDAO.findTopSellingProducts(startInstant, endInstant, 5);

        // Bài 3: Thống kê doanh thu theo khoảng thời gian & Dữ liệu biểu đồ
        BigDecimal totalRevenue = orderDAO.calculateRevenue(startInstant, endInstant);
        List<Object[]> dailyRevenue = orderDAO.getDailyRevenue(startInstant, endInstant);

        // Bài 4: Thống kê tổng hợp Dashboard (Tổng đơn, Tổng sản phẩm, Tổng khách hàng)
        long totalOrders = orderDAO.countTotalOrders();
        long totalProducts = productDAO.findAll().size();
        long totalUsers = userDAO.findAll().size();

        req.setAttribute("top5Selling", top5Selling);
        req.setAttribute("totalRevenue", totalRevenue);
        req.setAttribute("dailyRevenue", dailyRevenue);
        req.setAttribute("startDate", startDate.format(dtf));
        req.setAttribute("endDate", endDate.format(dtf));

        req.setAttribute("totalOrders", totalOrders);
        req.setAttribute("totalProducts", totalProducts);
        req.setAttribute("totalUsers", totalUsers);

        req.getRequestDispatcher("/WEB-INF/views/admin/statistics.jsp").forward(req, resp);
    }
}
