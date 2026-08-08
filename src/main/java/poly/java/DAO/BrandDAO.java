package poly.java.DAO;

import poly.java.Entity.Brand;

public interface BrandDAO extends GenericDAO<Brand, Integer> {

    Brand findByName(String name);

}