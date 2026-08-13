package poly.java.DAO.Impl;

import jakarta.persistence.EntityManager;
import poly.java.DAO.BrandDAO;
import poly.java.Entity.Brand;
import poly.java.Utils.JpaUtil;

import java.util.List;

public class BrandDAOImpl extends GenericDAOImpl<Brand, Integer> implements BrandDAO {

    public BrandDAOImpl() {
        super(Brand.class);
    }

    @Override
    public Brand findByName(String name) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = "SELECT b FROM Brand b WHERE b.brandName = :name";
            List<Brand> list = em.createQuery(jpql, Brand.class)
                    .setParameter("name", name)
                    .getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }
}
