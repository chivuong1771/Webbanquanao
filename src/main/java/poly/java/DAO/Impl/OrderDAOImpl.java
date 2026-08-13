package poly.java.DAO.Impl;

import jakarta.persistence.EntityManager;
import poly.java.DAO.OrderDAO;
import poly.java.Entity.Order;
import poly.java.Utils.JpaUtil;

import java.math.BigDecimal;
import java.time.Instant;
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
            String jpql = "SELECT o FROM Order o JOIN FETCH o.userID LEFT JOIN FETCH o.addressID WHERE o.id = :id";
            List<Order> list = em.createQuery(jpql, Order.class).setParameter("id", id).getResultList();
            return list.isEmpty() ? em.find(Order.class, id) : list.get(0);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Order> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery("SELECT o FROM Order o JOIN FETCH o.userID ORDER BY o.orderDate DESC", Order.class).getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Order> findByUser(int userId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = "SELECT o FROM Order o JOIN FETCH o.userID WHERE o.userID.id = :userId ORDER BY o.orderDate DESC";
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
            String jpql = "SELECT o FROM Order o JOIN FETCH o.userID WHERE UPPER(o.orderStatus) = UPPER(:status) ORDER BY o.orderDate DESC";
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
            String jpql = "SELECT o FROM Order o JOIN FETCH o.userID WHERE UPPER(o.paymentMethod) = 'ONLINE' AND UPPER(o.paymentStatus) = 'UNPAID' AND UPPER(o.orderStatus) != 'CANCELLED' ORDER BY o.orderDate DESC";
            return em.createQuery(jpql, Order.class).getResultList();
        } finally {
            em.close();
        }
    }

    // =========================================================================
    // LAB 6 - BÀI 1: Quản lý hóa đơn phía Admin (Phân trang 10 đơn / trang)
    // =========================================================================
    @Override
    public List<Order> findAllPaginated(int page, int pageSize) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = "SELECT o FROM Order o JOIN FETCH o.userID ORDER BY o.orderDate DESC";
            var query = em.createQuery(jpql, Order.class);
            query.setFirstResult((page - 1) * pageSize);
            query.setMaxResults(pageSize); // Mỗi trang 10 đơn hàng
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public long countTotalOrders() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery("SELECT COUNT(o) FROM Order o", Long.class).getSingleResult();
        } finally {
            em.close();
        }
    }

    @Override
    public void cancelOrder(Integer orderId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Order order = em.find(Order.class, orderId);
            if (order != null) {
                order.setOrderStatus("CANCELLED");
                em.merge(order);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    // =========================================================================
    // LAB 6 - BÀI 2: Thống kê 5 thức uống / sản phẩm bán chạy nhất
    // =========================================================================
    @Override
    public List<Object[]> findTopSellingProducts(Instant startDate, Instant endDate, int limit) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("""
                SELECT od.variantID.productID, SUM(od.quantity), SUM(od.total) 
                FROM OrderDetail od 
                JOIN od.orderID o 
                WHERE UPPER(o.orderStatus) != 'CANCELLED'
                """);

            if (startDate != null) jpql.append(" AND o.orderDate >= :start");
            if (endDate != null) jpql.append(" AND o.orderDate <= :end");

            jpql.append(" GROUP BY od.variantID.productID ORDER BY SUM(od.quantity) DESC");

            var query = em.createQuery(jpql.toString(), Object[].class);
            if (startDate != null) query.setParameter("start", startDate);
            if (endDate != null) query.setParameter("end", endDate);

            query.setMaxResults(limit); // 5 thức uống / sản phẩm bán chạy nhất
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    // =========================================================================
    // LAB 6 - BÀI 3: Thống kê doanh thu theo khoảng thời gian
    // =========================================================================
    @Override
    public BigDecimal calculateRevenue(Instant startDate, Instant endDate) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("SELECT SUM(o.finalAmount) FROM Order o WHERE UPPER(o.orderStatus) != 'CANCELLED'");
            if (startDate != null) jpql.append(" AND o.orderDate >= :start");
            if (endDate != null) jpql.append(" AND o.orderDate <= :end");

            var query = em.createQuery(jpql.toString(), BigDecimal.class);
            if (startDate != null) query.setParameter("start", startDate);
            if (endDate != null) query.setParameter("end", endDate);

            BigDecimal result = query.getSingleResult();
            return result != null ? result : BigDecimal.ZERO;
        } finally {
            em.close();
        }
    }

    @Override
    public List<Object[]> getDailyRevenue(Instant startDate, Instant endDate) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("""
                SELECT CAST(o.orderDate AS date), SUM(o.finalAmount) 
                FROM Order o 
                WHERE UPPER(o.orderStatus) != 'CANCELLED'
                """);

            if (startDate != null) jpql.append(" AND o.orderDate >= :start");
            if (endDate != null) jpql.append(" AND o.orderDate <= :end");

            jpql.append(" GROUP BY CAST(o.orderDate AS date) ORDER BY CAST(o.orderDate AS date) ASC");

            var query = em.createQuery(jpql.toString(), Object[].class);
            if (startDate != null) query.setParameter("start", startDate);
            if (endDate != null) query.setParameter("end", endDate);

            return query.getResultList();
        } finally {
            em.close();
        }
    }
}
