package poly.java.DAO.Impl;

import jakarta.persistence.EntityManager;
import poly.java.DAO.OrderDetailDAO;
import poly.java.Entity.OrderDetail;
import poly.java.Utils.JpaUtil;

import java.util.List;

public class OrderDetailDAOImpl implements OrderDetailDAO {

    @Override
    public OrderDetail create(OrderDetail entity) {
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
    public OrderDetail update(OrderDetail entity) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            OrderDetail updated = em.merge(entity);
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
            OrderDetail d = em.find(OrderDetail.class, id);
            if (d != null) em.remove(d);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    @Override
    public OrderDetail findById(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = """
                SELECT d FROM OrderDetail d 
                JOIN FETCH d.variantID v 
                JOIN FETCH v.productID p 
                LEFT JOIN FETCH v.colorID c 
                LEFT JOIN FETCH v.sizeID s 
                WHERE d.id = :id
                """;
            List<OrderDetail> list = em.createQuery(jpql, OrderDetail.class)
                    .setParameter("id", id)
                    .getResultList();
            return list.isEmpty() ? em.find(OrderDetail.class, id) : list.get(0);
        } finally {
            em.close();
        }
    }

    @Override
    public List<OrderDetail> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = """
                SELECT d FROM OrderDetail d 
                JOIN FETCH d.variantID v 
                JOIN FETCH v.productID p 
                LEFT JOIN FETCH v.colorID c 
                LEFT JOIN FETCH v.sizeID s
                """;
            return em.createQuery(jpql, OrderDetail.class).getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<OrderDetail> findByOrder(int orderId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = """
                SELECT d FROM OrderDetail d 
                JOIN FETCH d.variantID v 
                JOIN FETCH v.productID p 
                LEFT JOIN FETCH v.colorID c 
                LEFT JOIN FETCH v.sizeID s 
                WHERE d.orderID.id = :orderId
                """;
            return em.createQuery(jpql, OrderDetail.class)
                    .setParameter("orderId", orderId)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}
