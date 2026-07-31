package poly.java.DAO;

import poly.java.Entity.PromotionDetail;
import java.util.List;

public interface PromotionDetailDAO extends GenericDAO<PromotionDetail, Integer> {

    List<PromotionDetail> findByPromotion(int promotionId);

}