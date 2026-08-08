package poly.java.DAO;

import poly.java.Entity.Review;
import java.util.List;

public interface ReviewDAO extends GenericDAO<Review, Integer> {

    List<Review> findByProduct(int productId);

    List<Review> findByUser(int userId);

}