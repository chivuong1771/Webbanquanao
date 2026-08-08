package poly.java.DAO;

import poly.java.Entity.Banner;
import java.util.List;

public interface BannerDAO extends GenericDAO<Banner, Integer> {

    List<Banner> findActive();

}