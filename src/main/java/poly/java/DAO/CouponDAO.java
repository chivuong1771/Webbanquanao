package poly.java.DAO;

import poly.java.Entity.Coupon;

public interface CouponDAO extends GenericDAO<Coupon, Integer> {

    Coupon findByCode(String code);

}