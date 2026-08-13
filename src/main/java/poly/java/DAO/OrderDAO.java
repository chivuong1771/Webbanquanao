package poly.java.DAO;

import poly.java.Entity.Order;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

public interface OrderDAO extends GenericDAO<Order, Integer> {

    List<Order> findByUser(int userId);

    List<Order> findByStatus(String status);

    List<Order> findUnpaidOrders();

    // Lab 6 - Bài 1: Quản lý hóa đơn phía Admin (Phân trang 10 đơn / trang & Hủy đơn)
    List<Order> findAllPaginated(int page, int pageSize);
    long countTotalOrders();
    void cancelOrder(Integer orderId);

    // Lab 6 - Bài 2: Thống kê 5 thức uống / sản phẩm bán chạy nhất theo khoảng thời gian
    List<Object[]> findTopSellingProducts(Instant startDate, Instant endDate, int limit);

    // Lab 6 - Bài 3: Thống kê doanh thu theo khoảng thời gian & vẽ biểu đồ
    BigDecimal calculateRevenue(Instant startDate, Instant endDate);
    List<Object[]> getDailyRevenue(Instant startDate, Instant endDate);
}