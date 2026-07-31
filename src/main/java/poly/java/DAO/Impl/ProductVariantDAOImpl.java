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
    public List<ProductVariant> findByProductId(Integer productId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            // Join Fetch ca Color va Size
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
}