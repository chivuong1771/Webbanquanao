package poly.java.DAO;

import poly.java.Entity.User;
import poly.java.Entity.Wishlist;

import java.util.List;

public interface WishlistDAO
        extends GenericDAO<Wishlist, Integer> {

    List<Wishlist> findByUser(User user);
}