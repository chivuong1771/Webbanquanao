package poly.java.Service;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;

import poly.java.DTO.CartItemDTO;
import poly.java.Entity.Cart;
import poly.java.Entity.CartDetail;
import poly.java.Entity.Product;
import poly.java.Entity.ProductVariant;
import poly.java.Entity.User;
import poly.java.Utils.JpaUtil;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class CartService {

    /**
     * Lấy toàn bộ sản phẩm trong giỏ hàng
     */
    public List<CartItemDTO> getCartItems(User user) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            List<CartItemDTO> result = new ArrayList<>();

            List<CartDetail> details = em.createQuery(
                            """
                            SELECT cd
                            FROM CartDetail cd
                            JOIN FETCH cd.variant v
                            JOIN FETCH v.productID p
                            WHERE cd.cart.user = :user
                            ORDER BY cd.cartDetailId DESC
                            """,
                            CartDetail.class
                    )
                    .setParameter("user", user)
                    .getResultList();

            for (CartDetail detail : details) {

                ProductVariant variant =
                        detail.getVariant();

                Product product =
                        variant.getProductID();

                CartItemDTO dto =
                        new CartItemDTO();

                // ID CartDetail
                dto.setId(
                        detail.getCartDetailId()
                );

                // ID Variant
                dto.setVariantId(
                        variant.getId()
                );

                // ID Product
                dto.setProductId(
                        product.getId()
                );

                // Tên sản phẩm
                dto.setProductName(
                        product.getProductName()
                );

                // Số lượng
                dto.setQuantity(
                        detail.getQuantity()
                );

                // Giá
                BigDecimal price =
                        variant.getPrice();

                /*
                 * Nếu Variant không có giá,
                 * lấy giá của Product.
                 */
                if (price == null) {
                    price = product.getPrice();
                }

                dto.setActualPrice(price);

                // Thành tiền
                BigDecimal totalAmount =
                        price.multiply(
                                BigDecimal.valueOf(
                                        detail.getQuantity()
                                )
                        );

                dto.setTotalAmount(
                        totalAmount
                );

                /*
                 * Color và Size hiện tại là
                 * Entity riêng nên chưa thể
                 * gọi getColor() hoặc getSize().
                 *
                 * Tạm thời lấy object và chuyển
                 * thành String.
                 */
                if (variant.getColorID() != null) {
                    dto.setColor(
                            variant.getColorID().toString()
                    );
                }

                if (variant.getSizeID() != null) {
                    dto.setSize(
                            variant.getSizeID().toString()
                    );
                }

                // Ảnh sản phẩm
                dto.setImageUrl(
                        product.getThumbnail()
                );

                result.add(dto);
            }

            return result;

        } finally {

            em.close();
        }
    }


    /**
     * Tính tổng tiền
     */
    public BigDecimal calculateSubTotal(
            List<CartItemDTO> cartItems) {

        BigDecimal total =
                BigDecimal.ZERO;

        for (CartItemDTO item : cartItems) {

            if (item.getTotalAmount() != null) {

                total = total.add(
                        item.getTotalAmount()
                );
            }
        }

        return total;
    }


    /**
     * Cập nhật số lượng sản phẩm
     */
    public boolean updateQuantity(
            User user,
            int cartItemId,
            int quantity) {

        EntityManager em =
                JpaUtil.getEntityManager();

        EntityTransaction tx =
                em.getTransaction();

        try {

            tx.begin();

            CartDetail detail =
                    em.find(
                            CartDetail.class,
                            cartItemId
                    );

            if (detail == null) {

                tx.rollback();

                return false;
            }

            /*
             * Kiểm tra CartDetail có thuộc
             * đúng User hiện tại không.
             */
            Cart cart =
                    detail.getCart();

            if (cart == null ||
                    cart.getUser() == null ||
                    !cart.getUser()
                            .getId()
                            .equals(user.getId())) {

                tx.rollback();

                return false;
            }

            ProductVariant variant =
                    detail.getVariant();

            /*
             * quantity của ProductVariant
             * chính là số lượng tồn kho.
             */
            Integer stock =
                    variant.getQuantity();

            if (stock == null ||
                    stock < quantity) {

                tx.rollback();

                return false;
            }

            detail.setQuantity(quantity);

            em.merge(detail);

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


    /**
     * Xóa sản phẩm khỏi giỏ hàng
     */
    public boolean removeItem(
            User user,
            int cartItemId) {

        EntityManager em =
                JpaUtil.getEntityManager();

        EntityTransaction tx =
                em.getTransaction();

        try {

            tx.begin();

            CartDetail detail =
                    em.find(
                            CartDetail.class,
                            cartItemId
                    );

            if (detail == null) {

                tx.rollback();

                return false;
            }

            /*
             * Kiểm tra CartDetail có thuộc
             * đúng User hiện tại không.
             */
            Cart cart =
                    detail.getCart();

            if (cart == null ||
                    cart.getUser() == null ||
                    !cart.getUser()
                            .getId()
                            .equals(user.getId())) {

                tx.rollback();

                return false;
            }

            em.remove(detail);

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