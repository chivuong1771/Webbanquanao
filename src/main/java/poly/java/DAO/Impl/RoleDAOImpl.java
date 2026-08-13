package poly.java.DAO.Impl;

import jakarta.persistence.EntityManager;
import poly.java.DAO.RoleDAO;
import poly.java.Entity.Role;
import poly.java.Utils.JpaUtil;

import java.util.List;

public class RoleDAOImpl extends GenericDAOImpl<Role, Integer> implements RoleDAO {

    public RoleDAOImpl() {
        super(Role.class);
    }

    @Override
    public Role findByName(String roleName) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = "SELECT r FROM Role r WHERE r.roleName = :roleName";
            List<Role> list = em.createQuery(jpql, Role.class)
                    .setParameter("roleName", roleName)
                    .getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }
}
