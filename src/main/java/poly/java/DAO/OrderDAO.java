package poly.java.DAO;

import poly.java.Entity.Order;
import java.util.List;

public interface OrderDAO extends GenericDAO<Order, Integer> {

    List<Order> findByUser(int userId);

    List<Order> findByStatus(String status);

}