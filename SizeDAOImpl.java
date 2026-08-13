package poly.java.DAO.Impl;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import poly.java.DAO.SizeDAO;
import poly.java.Entity.Size;
import poly.java.Utils.JpaUtil;

import java.util.List;

public class SizeDAOImpl extends GenericDAOImpl<Size, Integer> implements SizeDAO {

    public SizeDAOImpl() {
        super(Size.class);
    }

    @Override
    public Size findByName(String name) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = "SELECT s FROM Size s WHERE s.sizeName = :name";
            TypedQuery<Size> query = em.createQuery(jpql, Size.class);
            query.setParameter("name", name);
            List<Size> results = query.getResultList();
            return results.isEmpty() ? null : results.get(0);
        } finally {
            em.close();
        }
    }
}