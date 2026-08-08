package poly.java.Service;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;

import poly.java.Entity.User;
import poly.java.Entity.Wishlist;
import poly.java.Utils.JpaUtil;

import java.util.List;

public class WishlistService {

    /**
     * Lấy danh sách yêu thích của user
     */
    public List<Wishlist> getByUser(User user) {

        EntityManager em =
                JpaUtil.getEntityManager();

        try {

            return em.createQuery(
                            """
                            SELECT w
                            FROM Wishlist w
                            JOIN FETCH w.product
                            WHERE w.user = :user
                            ORDER BY w.wishlistId DESC
                            """,
                            Wishlist.class
                    )
                    .setParameter("user", user)
                    .getResultList();

        } finally {

            em.close();
        }
    }


    /**
     * Xóa sản phẩm khỏi danh sách yêu thích
     */
    public boolean remove(
            User user,
            int wishlistId) {

        EntityManager em =
                JpaUtil.getEntityManager();

        EntityTransaction tx =
                em.getTransaction();

        try {

            tx.begin();

            Wishlist wishlist =
                    em.find(
                            Wishlist.class,
                            wishlistId
                    );

            // Không tìm thấy
            if (wishlist == null) {

                tx.rollback();

                return false;
            }

            // Kiểm tra wishlist có thuộc user hiện tại không
            if (wishlist.getUserID() == null ||
                    wishlist.getUserID()
                            .getId()
                            .equals(user.getId()) == false) {

                tx.rollback();

                return false;
            }

            em.remove(wishlist);

            tx.commit();

            return true;

        } catch (Exception e) {

            if (tx.isActive()) {
                tx.rollback();
            }

            e.printStackTrace();

            return false;

        } finally {

            em.close();
        }
    }
}