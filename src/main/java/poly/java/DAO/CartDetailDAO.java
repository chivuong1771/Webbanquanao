package poly.java.DAO;

import poly.java.Entity.Cart;
import poly.java.Entity.CartDetail;
import poly.java.Entity.ProductVariant;

import java.util.List;

public interface CartDetailDAO
        extends GenericDAO<CartDetail, Integer> {

    List<CartDetail> findByCart(Cart cart);

    CartDetail findByCartAndVariant(
            Cart cart,
            ProductVariant variant
    );
}