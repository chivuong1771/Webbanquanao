package poly.java.DAO.Impl;

import jakarta.persistence.EntityManager;
import poly.java.DAO.CouponDAO;
import poly.java.Entity.Coupon;
import poly.java.Utils.JpaUtil;

import java.util.List;

public class CouponDAOImpl implements CouponDAO {

    @Override
    public Coupon create(Coupon entity) {
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
    public Coupon update(Coupon entity) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Coupon updated = em.merge(entity);
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
            Coupon coupon = em.find(Coupon.class, id);
            if (coupon != null) {
                coupon.setStatus(false);
                em.merge(coupon);
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
    public Coupon findById(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.find(Coupon.class, id);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Coupon> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery("SELECT c FROM Coupon c", Coupon.class).getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public Coupon findByCode(String code) {
        if (code == null || code.isBlank()) return null;
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = "SELECT c FROM Coupon c WHERE LOWER(c.code) = LOWER(:code) AND (c.status = true OR c.status IS NULL)";
            List<Coupon> list = em.createQuery(jpql, Coupon.class)
                    .setParameter("code", code.trim())
                    .getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }
}
