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
            
            // 1. Xóa các bảng liên kết trực tiếp với Product
            em.createQuery("DELETE FROM Wishlist w WHERE w.productID.id = :id").setParameter("id", id).executeUpdate();
            em.createQuery("DELETE FROM Review r WHERE r.productID.id = :id").setParameter("id", id).executeUpdate();
            em.createQuery("DELETE FROM PromotionDetail pd WHERE pd.productID.id = :id").setParameter("id", id).executeUpdate();
            em.createQuery("DELETE FROM ProductImage pi WHERE pi.productID.id = :id").setParameter("id", id).executeUpdate();

            // 2. Lấy danh sách VariantID của sản phẩm này để xóa các ràng buộc khóa ngoại con
            List<Integer> variantIds = em.createQuery("SELECT pv.id FROM ProductVariant pv WHERE pv.productID.id = :id", Integer.class)
                    .setParameter("id", id)
                    .getResultList();

            if (!variantIds.isEmpty()) {
                em.createQuery("DELETE FROM CartDetail cd WHERE cd.variantID.id IN :vids").setParameter("vids", variantIds).executeUpdate();
                em.createQuery("DELETE FROM OrderDetail od WHERE od.variantID.id IN :vids").setParameter("vids", variantIds).executeUpdate();
                em.createQuery("DELETE FROM InventoryHistory ih WHERE ih.variantID.id IN :vids").setParameter("vids", variantIds).executeUpdate();
                em.createQuery("DELETE FROM ProductVariant pv WHERE pv.productID.id = :id").setParameter("id", id).executeUpdate();
            }

            // 3. Xóa vĩnh viễn sản phẩm khỏi bảng Products
            Product product = em.find(Product.class, id);
            if (product != null) {
                em.remove(product);
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

    // Bài 1: Tìm kiếm kết hợp phân trang thức uống / sản phẩm (mỗi trang 10 sản phẩm)
    @Override
    public List<Product> searchProducts(String keyword, Integer categoryId, Boolean status, int page, int pageSize) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("SELECT p FROM Product p JOIN FETCH p.categoryID JOIN FETCH p.brandID WHERE 1=1");
            if (keyword != null && !keyword.isBlank()) {
                jpql.append(" AND LOWER(p.productName) LIKE :kw");
            }
            if (categoryId != null && categoryId > 0) {
                jpql.append(" AND p.categoryID.id = :catId");
            }
            if (status != null) {
                jpql.append(" AND p.status = :status");
            }
            jpql.append(" ORDER BY p.id DESC");

            var query = em.createQuery(jpql.toString(), Product.class);
            if (keyword != null && !keyword.isBlank()) {
                query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
            }
            if (categoryId != null && categoryId > 0) {
                query.setParameter("catId", categoryId);
            }
            if (status != null) {
                query.setParameter("status", status);
            }

            query.setFirstResult((page - 1) * pageSize);
            query.setMaxResults(pageSize);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public long countSearchProducts(String keyword, Integer categoryId, Boolean status) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("SELECT COUNT(p) FROM Product p WHERE 1=1");
            if (keyword != null && !keyword.isBlank()) {
                jpql.append(" AND LOWER(p.productName) LIKE :kw");
            }
            if (categoryId != null && categoryId > 0) {
                jpql.append(" AND p.categoryID.id = :catId");
            }
            if (status != null) {
                jpql.append(" AND p.status = :status");
            }

            var query = em.createQuery(jpql.toString(), Long.class);
            if (keyword != null && !keyword.isBlank()) {
                query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
            }
            if (categoryId != null && categoryId > 0) {
                query.setParameter("catId", categoryId);
            }
            if (status != null) {
                query.setParameter("status", status);
            }
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }
}