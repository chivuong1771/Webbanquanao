package poly.java.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import poly.java.DAO.OrderDAO;
import poly.java.DAO.OrderStatusHistoryDAO;
import poly.java.DAO.Impl.OrderDAOImpl;
import poly.java.DAO.Impl.OrderStatusHistoryDAOImpl;
import poly.java.Entity.Order;
import poly.java.Entity.OrderStatusHistory;
import poly.java.Entity.User;

import java.io.IOException;
import java.time.Instant;
import java.util.List;

@WebServlet({"/admin/orders", "/admin/orders/status", "/admin/orders/delete"})
public class AdminOrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAOImpl();
    private final OrderStatusHistoryDAO historyDAO = new OrderStatusHistoryDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/admin/orders/delete".equals(path)) {
            String idStr = req.getParameter("id");
            if (idStr != null) {
                try {
                    int orderId = Integer.parseInt(idStr);
                    orderDAO.delete(orderId);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            resp.sendRedirect(req.getContextPath() + "/admin/orders");
            return;
        }

        List<Order> orders = orderDAO.findAll();
        req.setAttribute("orders", orders);
        req.getRequestDispatcher("/admin/orders.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();

        if ("/admin/orders/status".equals(path)) {
            String orderIdStr = req.getParameter("orderId");
            String status = req.getParameter("status");
            String paymentStatus = req.getParameter("paymentStatus");

            if (orderIdStr != null && status != null) {
                try {
                    int orderId = Integer.parseInt(orderIdStr);
                    Order order = orderDAO.findById(orderId);
                    if (order != null) {
                        order.setOrderStatus(status);
                        if (paymentStatus != null && !paymentStatus.isBlank()) {
                            order.setPaymentStatus(paymentStatus);
                        }
                        orderDAO.update(order);

                        User adminUser = (User) req.getSession().getAttribute("currentUser");
                        OrderStatusHistory history = new OrderStatusHistory();
                        history.setOrderID(order);
                        history.setStatus(status + (paymentStatus != null ? " (" + paymentStatus + ")" : ""));
                        history.setChangedAt(Instant.now());
                        history.setChangedBy(adminUser != null ? adminUser : order.getUserID());
                        historyDAO.create(history);

                        resp.sendRedirect(req.getContextPath() + "/admin/orders?success=status_updated");
                        return;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            resp.sendRedirect(req.getContextPath() + "/admin/orders");
        }
    }
}
