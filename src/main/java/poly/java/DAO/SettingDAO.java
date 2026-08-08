package poly.java.DAO;

import poly.java.Entity.Setting;

public interface SettingDAO extends GenericDAO<Setting, Integer> {

    Setting findByKey(String key);

}