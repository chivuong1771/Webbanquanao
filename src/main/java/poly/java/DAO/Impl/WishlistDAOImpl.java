package poly.java.DAO.Impl;

import jakarta.persistence.EntityManager;
import poly.java.DAO.WishlistDAO;
import poly.java.Entity.Wishlist;
import poly.java.Utils.JpaUtil;

import java.util.List;

public class WishlistDAOImpl extends GenericDAOImpl<Wishlist, Integer> implements WishlistDAO {

    public WishlistDAOImpl() {
        super(Wishlist.class);
    }

    @Override
    public List<Wishlist> findByUser(int userId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = "SELECT w FROM Wishlist w WHERE w.userID.id = :userId";
            return em.createQuery(jpql, Wishlist.class)
                    .setParameter("userId", userId)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}
