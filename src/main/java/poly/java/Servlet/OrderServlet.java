package poly.java.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import poly.java.DAO.OrderDAO;
import poly.java.DAO.OrderDetailDAO;
import poly.java.DAO.OrderStatusHistoryDAO;
import poly.java.DAO.Impl.OrderDAOImpl;
import poly.java.DAO.Impl.OrderDetailDAOImpl;
import poly.java.DAO.Impl.OrderStatusHistoryDAOImpl;
import poly.java.Entity.Order;
import poly.java.Entity.OrderDetail;
import poly.java.Entity.OrderStatusHistory;
import poly.java.Entity.User;

import java.io.IOException;
import java.time.Instant;
import java.util.List;

@WebServlet({"/orders", "/orders/detail", "/orders/cancel"})
public class OrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAOImpl();
    private final OrderDetailDAO orderDetailDAO = new OrderDetailDAOImpl();
    private final OrderStatusHistoryDAO historyDAO = new OrderStatusHistoryDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("currentUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String path = req.getServletPath();

        if ("/orders/cancel".equals(path)) {
            String idStr = req.getParameter("id");
            if (idStr != null) {
                try {
                    int orderId = Integer.parseInt(idStr);
                    Order order = orderDAO.findById(orderId);
                    if (order != null && order.getUserID().getId().equals(user.getId()) && "PENDING".equalsIgnoreCase(order.getOrderStatus())) {
                        order.setOrderStatus("CANCELLED");
                        orderDAO.update(order);

                        OrderStatusHistory history = new OrderStatusHistory();
                        history.setOrderID(order);
                        history.setStatus("CANCELLED");
                        history.setChangedAt(Instant.now());
                        history.setChangedBy(user);
                        historyDAO.create(history);

                        resp.sendRedirect(req.getContextPath() + "/orders?success=cancel_ok");
                        return;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            resp.sendRedirect(req.getContextPath() + "/orders?error=cancel_failed");
            return;
        }

        String idParam = req.getParameter("id");
        if (idParam != null && !idParam.isBlank()) {
            try {
                int orderId = Integer.parseInt(idParam);
                Order order = orderDAO.findById(orderId);
                if (order != null && (order.getUserID().getId().equals(user.getId()) || "ADMIN".equalsIgnoreCase(user.getRole()))) {
                    List<OrderDetail> details = orderDetailDAO.findByOrder(orderId);
                    order.setOrderDetails(details);
                    req.setAttribute("order", order);
                    req.getRequestDispatcher("/order-detail.jsp").forward(req, resp);
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        List<Order> orders = orderDAO.findByUser(user.getId());
        req.setAttribute("orders", orders);
        req.getRequestDispatcher("/orders.jsp").forward(req, resp);
    }
}
