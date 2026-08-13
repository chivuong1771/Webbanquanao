package poly.java.DAO.Impl;

import jakarta.persistence.EntityManager;
import poly.java.DAO.ProductImageDAO;
import poly.java.Entity.ProductImage;
import poly.java.Utils.JpaUtil;

import java.util.List;

public class ProductImageDAOImpl extends GenericDAOImpl<ProductImage, Integer> implements ProductImageDAO {

    public ProductImageDAOImpl() {
        super(ProductImage.class);
    }

    @Override
    public List<ProductImage> findByProduct(int productId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = "SELECT pi FROM ProductImage pi WHERE pi.productID.id = :productId";
            return em.createQuery(jpql, ProductImage.class)
                    .setParameter("productId", productId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public ProductImage findMainImage(int productId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = "SELECT pi FROM ProductImage pi WHERE pi.productID.id = :productId AND pi.isMain = true";
            List<ProductImage> list = em.createQuery(jpql, ProductImage.class)
                    .setParameter("productId", productId)
                    .getResultList();
            if (!list.isEmpty()) {
                return list.get(0);
            }
            List<ProductImage> all = findByProduct(productId);
            return all.isEmpty() ? null : all.get(0);
        } finally {
            em.close();
        }
    }
}
