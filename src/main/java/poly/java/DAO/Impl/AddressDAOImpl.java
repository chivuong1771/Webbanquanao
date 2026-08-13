package poly.java.DAO.Impl;

import jakarta.persistence.EntityManager;
import poly.java.DAO.AddressDAO;
import poly.java.Entity.Address;
import poly.java.Utils.JpaUtil;

import java.util.List;

public class AddressDAOImpl implements AddressDAO {

    @Override
    public Address create(Address entity) {
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
    public Address update(Address entity) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Address updated = em.merge(entity);
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
            Address address = em.find(Address.class, id);
            if (address != null) {
                em.remove(address);
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
    public Address findById(Integer id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.find(Address.class, id);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Address> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery("SELECT a FROM Address a", Address.class).getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Address> findByUser(int userId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = "SELECT a FROM Address a WHERE a.userID.id = :userId";
            return em.createQuery(jpql, Address.class)
                    .setParameter("userId", userId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public Address findDefaultAddress(int userId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = "SELECT a FROM Address a WHERE a.userID.id = :userId AND a.isDefault = true";
            List<Address> list = em.createQuery(jpql, Address.class)
                    .setParameter("userId", userId)
                    .getResultList();
            if (!list.isEmpty()) {
                return list.get(0);
            }
            List<Address> all = findByUser(userId);
            return all.isEmpty() ? null : all.get(0);
        } finally {
            em.close();
        }
    }
}
