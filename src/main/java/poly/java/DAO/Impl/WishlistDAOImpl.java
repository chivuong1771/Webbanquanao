package poly.java.DAO.Impl;

import jakarta.persistence.EntityManager;
import poly.java.DAO.WishlistDAO;
import poly.java.Entity.User;
import poly.java.Entity.Wishlist;
import poly.java.Utils.JpaUtil;

import java.util.List;

public class WishlistDAOImpl
        extends GenericDAOImpl<Wishlist, Integer>
        implements WishlistDAO {

    @Override
    public List<Wishlist> findByUser(User user) {

        EntityManager em = JpaUtil.getEntityManager();

        try {
            return em.createQuery(
                            """
                            SELECT w
                            FROM Wishlist w
                            WHERE w.user = :user
                            """,
                            Wishlist.class
                    )
                    .setParameter("user", user)
                    .getResultList();

        } finally {
            em.close();
        }
    }
}