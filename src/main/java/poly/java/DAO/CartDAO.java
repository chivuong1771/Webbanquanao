package poly.java.DAO;

import poly.java.Entity.Cart;

public interface CartDAO extends GenericDAO<Cart, Integer> {

    Cart findByUser(int userId);

}