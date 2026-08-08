package poly.java.DAO.Impl;

import jakarta.persistence.EntityManager;
import poly.java.DAO.ProductVariantDAO;
import poly.java.Entity.ProductVariant;
import poly.java.Utils.JpaUtil;

import java.util.List;

public class ProductVariantDAOImpl implements ProductVariantDAO {

    @Override
    public ProductVariant create(ProductVariant entity) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(entity);
            em.getTransaction().commit();
            return entity;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    @Override
    public ProductVariant update(ProductVariant entity) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            ProductVariant updated = em.merge(entity);
            em.getTransaction().commit();
            return updated;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    @Override
    public void delete(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            ProductVariant variant = em.find(ProductVariant.class, id);
            if (variant != null) em.remove(variant);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    @Override
    public ProductVariant findById(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.find(ProductVariant.class, id);
        } finally {
            em.close();
        }
    }

    @Override
    public List<ProductVariant> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery("SELECT pv FROM ProductVariant pv", ProductVariant.class).getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<ProductVariant> findByProductId(Integer productId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = """
                SELECT pv FROM ProductVariant pv 
                JOIN FETCH pv.colorID 
                JOIN FETCH pv.sizeID 
                WHERE pv.productID.id = :productId
                """;
            return em.createQuery(jpql, ProductVariant.class)
                    .setParameter("productId", productId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public ProductVariant findByProductColorSize(Integer productId, String colorName, String sizeName) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = """
                SELECT pv FROM ProductVariant pv 
                WHERE pv.productID.id = :productId 
                AND (pv.colorID.colorName = :colorName OR :colorName IS NULL)
                AND (pv.sizeID.sizeName = :sizeName OR :sizeName IS NULL)
                """;
            List<ProductVariant> list = em.createQuery(jpql, ProductVariant.class)
                    .setParameter("productId", productId)
                    .setParameter("colorName", colorName)
                    .setParameter("sizeName", sizeName)
                    .getResultList();
            if (!list.isEmpty()) {
                return list.get(0);
            }
            // Fallback to any variant of the product
            List<ProductVariant> fallback = findByProductId(productId);
            return fallback.isEmpty() ? null : fallback.get(0);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }
}