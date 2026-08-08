package poly.java.DAO;

import poly.java.Entity.OrderDetail;
import java.util.List;

public interface OrderDetailDAO extends GenericDAO<OrderDetail, Integer> {

    List<OrderDetail> findByOrder(int orderId);

}