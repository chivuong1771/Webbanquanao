package poly.java.DAO;

import poly.java.Entity.CartDetail;
import java.util.List;

public interface CartDetailDAO extends GenericDAO<CartDetail, Integer> {

    List<CartDetail> findByCart(int cartId);

    CartDetail findByCartAndVariant(int cartId,int variantId);

}