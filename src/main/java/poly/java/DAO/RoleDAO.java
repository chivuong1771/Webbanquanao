package poly.java.DAO;

import poly.java.Entity.Role;

public interface RoleDAO extends GenericDAO<Role, Integer> {

    Role findByName(String roleName);

}