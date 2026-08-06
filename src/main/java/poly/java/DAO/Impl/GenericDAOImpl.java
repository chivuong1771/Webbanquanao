package poly.java.DAO.Impl;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import poly.java.DAO.GenericDAO;
import poly.java.Utils.JpaUtil;

import java.util.List;

public class GenericDAOImpl<T, ID>
        implements GenericDAO<T, ID> {

    private Class<T> entityClass;

    public GenericDAOImpl(Class<T> entityClass) {
        this.entityClass = entityClass;
    }

    public GenericDAOImpl() {
    }

    @Override
    public T findById(ID id) {

        EntityManager em =
                JpaUtil.getEntityManager();

        try {

            return em.find(entityClass, id);

        } finally {

            em.close();
        }
    }

    @Override
    public List<T> findAll() {

        EntityManager em =
                JpaUtil.getEntityManager();

        try {

            String jpql =
                    "SELECT e FROM "
                            + entityClass.getSimpleName()
                            + " e";

            return em.createQuery(
                    jpql,
                    entityClass
            ).getResultList();

        } finally {

            em.close();
        }
    }

    @Override
    public T create(T entity) {

        EntityManager em =
                JpaUtil.getEntityManager();

        EntityTransaction transaction =
                em.getTransaction();

        try {

            transaction.begin();

            em.persist(entity);

            transaction.commit();

            return entity;

        } catch (Exception e) {

            if (transaction.isActive()) {
                transaction.rollback();
            }

            throw e;

        } finally {

            em.close();
        }
    }

    @Override
    public T update(T entity) {

        EntityManager em =
                JpaUtil.getEntityManager();

        EntityTransaction transaction =
                em.getTransaction();

        try {

            transaction.begin();

            T result = em.merge(entity);

            transaction.commit();

            return result;

        } catch (Exception e) {

            if (transaction.isActive()) {
                transaction.rollback();
            }

            throw e;

        } finally {

            em.close();
        }
    }

    @Override
    public void delete(ID id) {

        EntityManager em =
                JpaUtil.getEntityManager();

        EntityTransaction transaction =
                em.getTransaction();

        try {

            transaction.begin();

            T entity =
                    em.find(entityClass, id);

            if (entity != null) {
                em.remove(entity);
            }

            transaction.commit();

        } catch (Exception e) {

            if (transaction.isActive()) {
                transaction.rollback();
            }

            throw e;

        } finally {

            em.close();
        }
    }
}