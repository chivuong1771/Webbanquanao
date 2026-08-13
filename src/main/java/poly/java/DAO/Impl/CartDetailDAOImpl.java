package poly.java.DAO.Impl;

import jakarta.persistence.EntityManager;
import poly.java.DAO.CartDetailDAO;
import poly.java.Entity.CartDetail;
import poly.java.Utils.JpaUtil;

import java.util.List;

public class CartDetailDAOImpl implements CartDetailDAO {

    @Override
    public CartDetail create(CartDetail entity) {
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
    public CartDetail update(CartDetail entity) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            CartDetail updated = em.merge(entity);
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
            CartDetail cd = em.find(CartDetail.class, id);
            if (cd != null) {
                em.remove(cd);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    @Override
    public CartDetail findById(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = """
                SELECT cd FROM CartDetail cd 
                JOIN FETCH cd.variantID v 
                JOIN FETCH v.productID p 
                LEFT JOIN FETCH v.colorID c 
                LEFT JOIN FETCH v.sizeID s 
                WHERE cd.id = :id
                """;
            List<CartDetail> list = em.createQuery(jpql, CartDetail.class)
                    .setParameter("id", id)
                    .getResultList();
            return list.isEmpty() ? em.find(CartDetail.class, id) : list.get(0);
        } finally {
            em.close();
        }
    }

    @Override
    public List<CartDetail> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = """
                SELECT cd FROM CartDetail cd 
                JOIN FETCH cd.variantID v 
                JOIN FETCH v.productID p 
                LEFT JOIN FETCH v.colorID c 
                LEFT JOIN FETCH v.sizeID s
                """;
            return em.createQuery(jpql, CartDetail.class).getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<CartDetail> findByCart(int cartId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = """
                SELECT cd FROM CartDetail cd 
                JOIN FETCH cd.variantID v 
                JOIN FETCH v.productID p 
                LEFT JOIN FETCH v.colorID c 
                LEFT JOIN FETCH v.sizeID s 
                WHERE cd.cartID.id = :cartId
                """;
            return em.createQuery(jpql, CartDetail.class)
                    .setParameter("cartId", cartId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public CartDetail findByCartAndVariant(int cartId, int variantId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = """
                SELECT cd FROM CartDetail cd 
                JOIN FETCH cd.variantID v 
                JOIN FETCH v.productID p 
                LEFT JOIN FETCH v.colorID c 
                LEFT JOIN FETCH v.sizeID s 
                WHERE cd.cartID.id = :cartId AND cd.variantID.id = :variantId
                """;
            List<CartDetail> list = em.createQuery(jpql, CartDetail.class)
                    .setParameter("cartId", cartId)
                    .setParameter("variantId", variantId)
                    .getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }
}
