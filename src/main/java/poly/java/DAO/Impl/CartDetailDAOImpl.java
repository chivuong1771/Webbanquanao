package poly.java.DAO.Impl;

import jakarta.persistence.EntityManager;
import poly.java.DAO.CartDetailDAO;
import poly.java.Entity.Cart;
import poly.java.Entity.CartDetail;
import poly.java.Entity.ProductVariant;
import poly.java.Utils.JpaUtil;

import java.util.List;

public class CartDetailDAOImpl
        extends GenericDAOImpl<CartDetail, Integer>
        implements CartDetailDAO {

    @Override
    public List<CartDetail> findByCart(Cart cart) {

        EntityManager em = JpaUtil.getEntityManager();

        try {
            return em.createQuery(
                            """
                            SELECT cd
                            FROM CartDetail cd
                            WHERE cd.cart = :cart
                            """,
                            CartDetail.class
                    )
                    .setParameter("cart", cart)
                    .getResultList();

        } finally {
            em.close();
        }
    }

    @Override
    public CartDetail findByCartAndVariant(
            Cart cart,
            ProductVariant variant) {

        EntityManager em = JpaUtil.getEntityManager();

        try {
            return em.createQuery(
                            """
                            SELECT cd
                            FROM CartDetail cd
                            WHERE cd.cart = :cart
                            AND cd.variant = :variant
                            """,
                            CartDetail.class
                    )
                    .setParameter("cart", cart)
                    .setParameter("variant", variant)
                    .getResultStream()
                    .findFirst()
                    .orElse(null);

        } finally {
            em.close();
        }
    }
}