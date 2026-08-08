package poly.java.Service;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;

import poly.java.Entity.Product;
import poly.java.Entity.Review;
import poly.java.Entity.User;

import poly.java.Utils.JpaUtil;

import java.time.LocalDateTime;
import java.util.List;

public class ReviewService {

    public void addReview(
            User user,
            Product product,
            int rating,
            String comment) {

        if (rating < 1 || rating > 5) {

            throw new IllegalArgumentException(
                    "Đánh giá phải từ 1 đến 5 sao"
            );
        }

        if (comment == null ||
                comment.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Vui lòng nhập nội dung đánh giá"
            );
        }

        EntityManager em =
                JpaUtil.getEntityManager();

        EntityTransaction tx =
                em.getTransaction();

        try {

            tx.begin();

            Review review = new Review();

            review.setUserID(user);
            review.setProductID(product);
            review.setRating(rating);
            review.setComment(comment);
            review.setCreatedAt(
                    java.time.Instant.now()
            );

            em.persist(review);

            tx.commit();

        } catch (Exception e) {

            if (tx.isActive()) {
                tx.rollback();
            }

            throw e;

        } finally {
            em.close();
        }
    }

    public List<Review> getByProduct(
            Product product) {

        EntityManager em =
                JpaUtil.getEntityManager();

        try {

            return em.createQuery(
                            """
                            SELECT r
                            FROM Review r
                            JOIN FETCH r.user
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

    public void deleteReview(
            int reviewId) {

        EntityManager em =
                JpaUtil.getEntityManager();

        EntityTransaction tx =
                em.getTransaction();

        try {

            tx.begin();

            Review review =
                    em.find(
                            Review.class,
                            reviewId
                    );

            if (review != null) {
                em.remove(review);
            }

            tx.commit();

        } catch (Exception e) {

            if (tx.isActive()) {
                tx.rollback();
            }

            throw e;

        } finally {
            em.close();
        }
    }
}