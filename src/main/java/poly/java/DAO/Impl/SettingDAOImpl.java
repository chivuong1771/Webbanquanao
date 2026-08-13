package poly.java.DAO.Impl;

import jakarta.persistence.EntityManager;
import poly.java.DAO.SettingDAO;
import poly.java.Entity.Setting;
import poly.java.Utils.JpaUtil;

import java.util.List;

public class SettingDAOImpl extends GenericDAOImpl<Setting, Integer> implements SettingDAO {

    public SettingDAOImpl() {
        super(Setting.class);
    }

    @Override
    public Setting findByKey(String key) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = "SELECT s FROM Setting s WHERE s.settingKey = :key";
            List<Setting> list = em.createQuery(jpql, Setting.class)
                    .setParameter("key", key)
                    .getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }
}
