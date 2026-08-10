package poly.java.DAO.Impl;

import jakarta.persistence.EntityManager;
import poly.java.DAO.ReviewDAO;
import poly.java.Entity.Review;
import poly.java.Utils.JpaUtil;

import java.util.List;

public class ReviewDAOImpl extends GenericDAOImpl<Review, Integer> implements ReviewDAO {

    public ReviewDAOImpl() {
        super(Review.class);
    }

    @Override
    public List<Review> findByProduct(int productId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = "SELECT r FROM Review r WHERE r.productID.id = :productId ORDER BY r.createdAt DESC";
            return em.createQuery(jpql, Review.class)
                    .setParameter("productId", productId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Review> findByUser(int userId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = "SELECT r FROM Review r WHERE r.userID.id = :userId ORDER BY r.createdAt DESC";
            return em.createQuery(jpql, Review.class)
                    .setParameter("userId", userId)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}
