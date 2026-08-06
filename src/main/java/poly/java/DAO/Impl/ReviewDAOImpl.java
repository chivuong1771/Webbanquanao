package poly.java.DAO.Impl;

import jakarta.persistence.EntityManager;
import poly.java.DAO.ReviewDAO;
import poly.java.Entity.Product;
import poly.java.Entity.Review;
import poly.java.Entity.User;
import poly.java.Utils.JpaUtil;

import java.util.List;

public class ReviewDAOImpl
        extends GenericDAOImpl<Review, Integer>
        implements ReviewDAO {

    @Override
    public List<Review> findByProduct(Product product) {

        EntityManager em = JpaUtil.getEntityManager();

        try {
            return em.createQuery(
                            """
                            SELECT r
                            FROM Review r
                            WHERE r.product = :product
                            ORDER BY r.createdAt DESC
                            """,
                            Review.class
                    )
                    .setParameter("product", product)
                    .getResultList();

        } finally {
            em.close();
        }
    }

    @Override
    public List<Review> findByUser(User user) {

        EntityManager em = JpaUtil.getEntityManager();

        try {
            return em.createQuery(
                            """
                            SELECT r
                            FROM Review r
                            WHERE r.user = :user
                            ORDER BY r.createdAt DESC
                            """,
                            Review.class
                    )
                    .setParameter("user", user)
                    .getResultList();

        } finally {
            em.close();
        }
    }
}