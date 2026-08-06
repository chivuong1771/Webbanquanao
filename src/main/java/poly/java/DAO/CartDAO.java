package poly.java.DAO;

import poly.java.Entity.Cart;
import poly.java.Entity.User;

public interface CartDAO extends GenericDAO<Cart, Integer> {

    Cart findByUser(User user);
}