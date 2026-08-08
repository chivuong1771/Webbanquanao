package poly.java.DAO.Impl;

import jakarta.persistence.EntityManager;
import poly.java.DAO.BannerDAO;
import poly.java.Entity.Banner;
import poly.java.Utils.JpaUtil;

import java.util.List;

public class BannerDAOImpl implements BannerDAO {

    @Override
    public Banner create(Banner entity) {
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
    public Banner update(Banner entity) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Banner updated = em.merge(entity);
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
            Banner banner = em.find(Banner.class, id);
            if (banner != null) {
                banner.setStatus(false);
                em.merge(banner);
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
    public Banner findById(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.find(Banner.class, id);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Banner> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery("SELECT b FROM Banner b", Banner.class).getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Banner> findActive() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = "SELECT b FROM Banner b WHERE b.status = true OR b.status IS NULL";
            return em.createQuery(jpql, Banner.class).getResultList();
        } finally {
            em.close();
        }
    }
}
