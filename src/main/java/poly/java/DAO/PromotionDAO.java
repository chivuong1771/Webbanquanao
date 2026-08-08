package poly.java.DAO;

import poly.java.Entity.Promotion;
import java.util.List;

public interface PromotionDAO extends GenericDAO<Promotion, Integer> {

    List<Promotion> findActive();

}