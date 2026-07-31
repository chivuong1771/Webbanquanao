package poly.java.DAO.Impl;

import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import poly.java.DAO.UserDAO;
import poly.java.Entity.User;
import poly.java.Utils.JpaUtil;

import java.util.List;

public class UserDAOImpl implements UserDAO {

    @Override
    public User login(String email, String password) {
        EntityManager em = JpaUtil.getEntityManager();

        try {
            String jpql = """
                SELECT u
                FROM User u
                JOIN FETCH u.roleID
                WHERE u.email = :email
                AND u.password = :password
                AND u.status = true
                """;

            return em.createQuery(jpql, User.class)
                    .setParameter("email", email)
                    .setParameter("password", password)
                    .getSingleResult();

        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    @Override
    public User findByEmail(String email) {
        EntityManager em = JpaUtil.getEntityManager();

        try {
            // Đã thêm JOIN FETCH u.roleID để tránh lỗi Lazy Loading
            String jpql = """
                SELECT u 
                FROM User u 
                JOIN FETCH u.roleID 
                WHERE u.email = :email
                """;

            return em.createQuery(jpql, User.class)
                    .setParameter("email", email)
                    .getSingleResult();

        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    @Override
    public boolean existsByEmail(String email) {
        return findByEmail(email) != null;
    }

    @Override
    public List<User> findByRole(int roleId) {
        EntityManager em = JpaUtil.getEntityManager();

        try {
            String jpql = """
                    SELECT u
                    FROM User u
                    JOIN FETCH u.roleID
                    WHERE u.roleID.id = :roleId
                    """;

            return em.createQuery(jpql, User.class)
                    .setParameter("roleId", roleId)
                    .getResultList();

        } finally {
            em.close();
        }
    }

    @Override
    public List<User> findActiveUsers() {
        EntityManager em = JpaUtil.getEntityManager();

        try {
            String jpql = """
                    SELECT u
                    FROM User u
                    JOIN FETCH u.roleID
                    WHERE u.status = true
                    """;

            return em.createQuery(jpql, User.class)
                    .getResultList();

        } finally {
            em.close();
        }
    }

    // ==========================
    // CRUD từ GenericDAO
    // ==========================

    @Override
    public User create(User entity) {
        EntityManager em = JpaUtil.getEntityManager();

        try {
            em.getTransaction().begin();
            em.persist(entity);
            em.getTransaction().commit();
            return entity;

        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;

        } finally {
            em.close();
        }
    }

    @Override
    public User update(User entity) {
        EntityManager em = JpaUtil.getEntityManager();

        try {
            em.getTransaction().begin();
            User user = em.merge(entity);
            em.getTransaction().commit();
            return user;

        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
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

            User user = em.find(User.class, id);

            if (user != null) {
                em.remove(user);
            }

            em.getTransaction().commit();

        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;

        } finally {
            em.close();
        }
    }

    @Override
    public User findById(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();

        try {
            // Đã thay em.find bằng JPQL có JOIN FETCH u.roleID
            String jpql = """
                SELECT u 
                FROM User u 
                JOIN FETCH u.roleID 
                WHERE u.id = :id
                """;

            return em.createQuery(jpql, User.class)
                    .setParameter("id", id)
                    .getSingleResult();

        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    @Override
    public List<User> findAll() {
        EntityManager em = JpaUtil.getEntityManager();

        try {
            // Đã bổ sung JOIN FETCH u.roleID
            String jpql = "SELECT u FROM User u JOIN FETCH u.roleID";
            return em.createQuery(jpql, User.class)
                    .getResultList();

        } finally {
            em.close();
        }
    }
}