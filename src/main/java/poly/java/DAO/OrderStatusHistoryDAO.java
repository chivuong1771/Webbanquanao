package poly.java.DAO;

import poly.java.Entity.OrderStatusHistory;
import java.util.List;

public interface OrderStatusHistoryDAO extends GenericDAO<OrderStatusHistory, Integer> {

    List<OrderStatusHistory> findByOrder(int orderId);

}