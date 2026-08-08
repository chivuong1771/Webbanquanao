package poly.java.DAO.Impl;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import poly.java.DAO.ProductVariantDAO;
import poly.java.Entity.ProductVariant;
import poly.java.Utils.JpaUtil;

import java.util.List;

public class ProductVariantDAOImpl extends GenericDAOImpl<ProductVariant, Integer> implements ProductVariantDAO {

    public ProductVariantDAOImpl() {
        super(ProductVariant.class);
    }

    @Override
    public List<ProductVariant> findByProductId(Integer productId) {
        try (EntityManager em = JpaUtil.getEntityManager()) {
            String jpql = "SELECT pv FROM ProductVariant pv WHERE pv.product.id = :productId";
            TypedQuery<ProductVariant> query = em.createQuery(jpql, ProductVariant.class);
            query.setParameter("productId", productId);
            return query.getResultList();
        }
    }

    @Override
    public ProductVariant findByProductColorSize(Integer productId, Integer colorId, Integer sizeId) {
        try (EntityManager em = JpaUtil.getEntityManager()) {
            String jpql = "SELECT pv FROM ProductVariant pv WHERE pv.product.id = :productId AND pv.color.id = :colorId AND pv.size.id = :sizeId";
            TypedQuery<ProductVariant> query = em.createQuery(jpql, ProductVariant.class);
            query.setParameter("productId", productId);
            query.setParameter("colorId", colorId);
            query.setParameter("sizeId", sizeId);
            return query.getResultStream().findFirst().orElse(null);
        }
    }
}