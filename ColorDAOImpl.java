package poly.java.DAO.Impl;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import poly.java.DAO.ColorDAO;
import poly.java.Entity.Color;
import poly.java.Utils.JpaUtil;

import java.util.List;

public class ColorDAOImpl extends GenericDAOImpl<Color, Integer> implements ColorDAO {

    public ColorDAOImpl() {
        super(Color.class);
    }

    @Override
    public Color findByName(String name) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = "SELECT c FROM Color c WHERE c.colorName = :name";
            TypedQuery<Color> query = em.createQuery(jpql, Color.class);
            query.setParameter("name", name);
            List<Color> results = query.getResultList();
            return results.isEmpty() ? null : results.get(0);
        } finally {
            em.close();
        }
    }
}