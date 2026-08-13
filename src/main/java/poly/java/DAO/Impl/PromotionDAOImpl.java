package poly.java.DAO.Impl;

import jakarta.persistence.EntityManager;
import poly.java.DAO.PromotionDAO;
import poly.java.Entity.Promotion;
import poly.java.Utils.JpaUtil;

import java.util.List;

public class PromotionDAOImpl extends GenericDAOImpl<Promotion, Integer> implements PromotionDAO {

    public PromotionDAOImpl() {
        super(Promotion.class);
    }

    @Override
    public List<Promotion> findActive() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = "SELECT p FROM Promotion p WHERE p.status = true";
            return em.createQuery(jpql, Promotion.class).getResultList();
        } finally {
            em.close();
        }
    }
}
