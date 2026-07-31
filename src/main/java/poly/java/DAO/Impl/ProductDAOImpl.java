package poly.java.DAO.Impl;

import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import poly.java.DAO.ProductDAO;
import poly.java.Entity.Product;
import poly.java.Utils.JpaUtil;

import java.util.List;

public class ProductDAOImpl implements ProductDAO {

    @Override
    public Product create(Product entity) {
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
    public Product update(Product entity) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Product updated = em.merge(entity);
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
            Product product = em.find(Product.class, id);
            if (product != null) {
                // Xóa mềm: Chuyển Status = false
                product.setStatus(false);
                em.merge(product);
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
    public Product findById(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            // JOIN FETCH categoryID và brandID để không dính lỗi Lazy / 500 ngoài JSP
            String jpql = """
                SELECT p FROM Product p 
                JOIN FETCH p.categoryID 
                JOIN FETCH p.brandID 
                WHERE p.id = :id
                """;
            return em.createQuery(jpql, Product.class)
                    .setParameter("id", id)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    @Override
    public List<Product> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = "SELECT p FROM Product p JOIN FETCH p.categoryID JOIN FETCH p.brandID";
            return em.createQuery(jpql, Product.class).getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Product> findByCategoryId(Integer categoryId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = """
                SELECT p FROM Product p 
                JOIN FETCH p.categoryID 
                JOIN FETCH p.brandID 
                WHERE p.categoryID.id = :catId AND p.status = true
                """;
            return em.createQuery(jpql, Product.class)
                    .setParameter("catId", categoryId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Product> findActiveProducts() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = """
                SELECT p FROM Product p 
                JOIN FETCH p.categoryID 
                JOIN FETCH p.brandID 
                WHERE p.status = true
                """;
            return em.createQuery(jpql, Product.class).getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public void updateViewCount(Integer productId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            String jpql = "UPDATE Product p SET p.viewCount = p.viewCount + 1 WHERE p.id = :id";
            em.createQuery(jpql).setParameter("id", productId).executeUpdate();
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }
}