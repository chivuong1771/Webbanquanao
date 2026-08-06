package poly.java.DAO;

import poly.java.Entity.Product;
import poly.java.Entity.Review;
import poly.java.Entity.User;

import java.util.List;

public interface ReviewDAO
        extends GenericDAO<Review, Integer> {

    List<Review> findByProduct(Product product);

    List<Review> findByUser(User user);
}