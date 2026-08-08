package poly.java.DAO.Impl;

import jakarta.persistence.EntityManager;
import poly.java.DAO.OrderDAO;
import poly.java.Entity.Order;
import poly.java.Utils.JpaUtil;

import java.util.List;

public class OrderDAOImpl implements OrderDAO {

    @Override
    public Order create(Order entity) {
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
    public Order update(Order entity) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Order updated = em.merge(entity);
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
            Order order = em.find(Order.class, id);
            if (order != null) {
                em.remove(order);
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
    public Order findById(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.find(Order.class, id);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Order> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery("SELECT o FROM Order o ORDER BY o.orderDate DESC", Order.class).getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Order> findByUser(int userId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = "SELECT o FROM Order o WHERE o.userID.id = :userId ORDER BY o.orderDate DESC";
            return em.createQuery(jpql, Order.class)
                    .setParameter("userId", userId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Order> findByStatus(String status) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = "SELECT o FROM Order o WHERE UPPER(o.orderStatus) = UPPER(:status) ORDER BY o.orderDate DESC";
            return em.createQuery(jpql, Order.class)
                    .setParameter("status", status)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Order> findUnpaidOrders() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = "SELECT o FROM Order o WHERE UPPER(o.paymentMethod) = 'ONLINE' AND UPPER(o.paymentStatus) = 'UNPAID' AND UPPER(o.orderStatus) != 'CANCELLED' ORDER BY o.orderDate DESC";
            return em.createQuery(jpql, Order.class).getResultList();
        } finally {
            em.close();
        }
    }
}
