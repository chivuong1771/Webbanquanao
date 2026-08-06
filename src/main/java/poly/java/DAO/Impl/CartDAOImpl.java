package poly.java.DAO.Impl;

import jakarta.persistence.EntityManager;
import poly.java.DAO.CartDAO;
import poly.java.Entity.Cart;
import poly.java.Entity.User;
import poly.java.Utils.JpaUtil;

public class CartDAOImpl
        extends GenericDAOImpl<Cart, Integer>
        implements CartDAO {

    @Override
    public Cart findByUser(User user) {

        EntityManager em = JpaUtil.getEntityManager();

        try {
            return em.createQuery(
                            "SELECT c FROM Cart c WHERE c.user = :user",
                            Cart.class
                    )
                    .setParameter("user", user)
                    .getResultStream()
                    .findFirst()
                    .orElse(null);

        } finally {
            em.close();
        }
    }
}