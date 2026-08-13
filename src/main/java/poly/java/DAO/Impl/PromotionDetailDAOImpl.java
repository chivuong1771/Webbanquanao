package poly.java.DAO.Impl;

import jakarta.persistence.EntityManager;
import poly.java.DAO.PromotionDetailDAO;
import poly.java.Entity.PromotionDetail;
import poly.java.Utils.JpaUtil;

import java.util.List;

public class PromotionDetailDAOImpl extends GenericDAOImpl<PromotionDetail, Integer> implements PromotionDetailDAO {

    public PromotionDetailDAOImpl() {
        super(PromotionDetail.class);
    }

    @Override
    public List<PromotionDetail> findByPromotion(int promotionId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = "SELECT pd FROM PromotionDetail pd WHERE pd.promotionID.id = :promotionId";
            return em.createQuery(jpql, PromotionDetail.class)
                    .setParameter("promotionId", promotionId)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}
