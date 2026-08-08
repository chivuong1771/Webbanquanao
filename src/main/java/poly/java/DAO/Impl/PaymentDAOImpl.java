package poly.java.DAO.Impl;

import jakarta.persistence.EntityManager;
import poly.java.DAO.PaymentDAO;
import poly.java.Entity.Payment;
import poly.java.Utils.JpaUtil;

import java.util.List;

public class PaymentDAOImpl implements PaymentDAO {

    @Override
    public Payment create(Payment entity) {
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
    public Payment update(Payment entity) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Payment updated = em.merge(entity);
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
            Payment payment = em.find(Payment.class, id);
            if (payment != null) {
                em.remove(payment);
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
    public Payment findById(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.find(Payment.class, id);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Payment> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery("SELECT p FROM Payment p ORDER BY p.paymentDate DESC", Payment.class).getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public Payment findByOrder(int orderId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = "SELECT p FROM Payment p WHERE p.orderID.id = :orderId ORDER BY p.paymentDate DESC";
            List<Payment> list = em.createQuery(jpql, Payment.class)
                    .setParameter("orderId", orderId)
                    .getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }

    @Override
    public Payment findByTransactionCode(String code) {
        if (code == null || code.isBlank()) return null;
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = "SELECT p FROM Payment p WHERE p.transactionCode = :code";
            List<Payment> list = em.createQuery(jpql, Payment.class)
                    .setParameter("code", code.trim())
                    .getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }
}
