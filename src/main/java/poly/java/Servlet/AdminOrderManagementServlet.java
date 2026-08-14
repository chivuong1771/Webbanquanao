package poly.java.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import poly.java.DAO.OrderDAO;
import poly.java.DAO.OrderDetailDAO;
import poly.java.DAO.Impl.OrderDAOImpl;
import poly.java.DAO.Impl.OrderDetailDAOImpl;
import poly.java.Entity.Order;
import poly.java.Entity.OrderDetail;

import java.io.IOException;
import java.util.List;

@WebServlet({"/admin/orders/detail", "/admin/orders/cancel"})
public class AdminOrderManagementServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAOImpl();
    private final OrderDetailDAO orderDetailDAO = new OrderDetailDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        // Xem chi tiết hóa đơn / đơn hàng
        if ("/admin/orders/detail".equals(path)) {
            String orderIdStr = req.getParameter("id");
            if (orderIdStr != null) {
                try {
                    int orderId = Integer.parseInt(orderIdStr);
                    Order order = orderDAO.findById(orderId);
                    if (order != null) {
                        List<OrderDetail> details = orderDetailDAO.findByOrder(orderId);
                        req.setAttribute("order", order);
                        req.setAttribute("orderDetails", details);
                        req.getRequestDispatcher("/WEB-INF/views/admin/order-detail.jsp").forward(req, resp);
                        return;
                    }
                } catch (Exception ignored) {}
            }
            resp.sendRedirect(req.getContextPath() + "/admin/orders");
            return;
        }

        // Hủy hóa đơn / đơn hàng phía Admin
        if ("/admin/orders/cancel".equals(path)) {
            String orderIdStr = req.getParameter("id");
            if (orderIdStr != null) {
                try {
                    int orderId = Integer.parseInt(orderIdStr);
                    orderDAO.cancelOrder(orderId);
                    resp.sendRedirect(req.getContextPath() + "/admin/orders?success=cancel_order");
                    return;
                } catch (Exception ignored) {}
            }
            resp.sendRedirect(req.getContextPath() + "/admin/orders");
            return;
        }

        // Bài 1: Hiển thị danh sách tất cả đơn hàng ở phía admin, phân trang 10 đơn / trang
        String pageStr = req.getParameter("page");
        int page = 1;
        int pageSize = 10; // 10 đơn hàng mỗi trang theo yêu cầu Bài 1 Lab 6

        if (pageStr != null && !pageStr.isBlank()) {
            try {
                page = Math.max(1, Integer.parseInt(pageStr));
            } catch (NumberFormatException ignored) {}
        }

        List<Order> orderList = orderDAO.findAllPaginated(page, pageSize);
        long totalOrders = orderDAO.countTotalOrders();
        int totalPages = (int) Math.ceil((double) totalOrders / pageSize);
        if (totalPages < 1) totalPages = 1;

        req.setAttribute("orders", orderList);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalOrders", totalOrders);

        req.getRequestDispatcher("/WEB-INF/views/admin/orders.jsp").forward(req, resp);
    }
}
