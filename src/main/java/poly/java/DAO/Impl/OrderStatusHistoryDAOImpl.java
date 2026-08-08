package poly.java.DAO.Impl;

import jakarta.persistence.EntityManager;
import poly.java.DAO.OrderStatusHistoryDAO;
import poly.java.Entity.OrderStatusHistory;
import poly.java.Utils.JpaUtil;

import java.util.List;

public class OrderStatusHistoryDAOImpl implements OrderStatusHistoryDAO {

    @Override
    public OrderStatusHistory create(OrderStatusHistory entity) {
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
    public OrderStatusHistory update(OrderStatusHistory entity) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            OrderStatusHistory updated = em.merge(entity);
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
            OrderStatusHistory history = em.find(OrderStatusHistory.class, id);
            if (history != null) {
                em.remove(history);
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
    public OrderStatusHistory findById(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.find(OrderStatusHistory.class, id);
        } finally {
            em.close();
        }
    }

    @Override
    public List<OrderStatusHistory> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery("SELECT h FROM OrderStatusHistory h ORDER BY h.changedAt DESC", OrderStatusHistory.class).getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<OrderStatusHistory> findByOrder(int orderId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = "SELECT h FROM OrderStatusHistory h WHERE h.orderID.id = :orderId ORDER BY h.changedAt DESC";
            return em.createQuery(jpql, OrderStatusHistory.class)
                    .setParameter("orderId", orderId)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}
