package poly.java.DAO.Impl;

import jakarta.persistence.EntityManager;
import poly.java.DAO.InventoryHistoryDAO;
import poly.java.Entity.InventoryHistory;
import poly.java.Utils.JpaUtil;

import java.util.List;

public class InventoryHistoryDAOImpl extends GenericDAOImpl<InventoryHistory, Integer> implements InventoryHistoryDAO {

    public InventoryHistoryDAOImpl() {
        super(InventoryHistory.class);
    }

    @Override
    public List<InventoryHistory> findByVariant(int variantId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = "SELECT ih FROM InventoryHistory ih WHERE ih.variantID.id = :variantId ORDER BY ih.createdAt DESC";
            return em.createQuery(jpql, InventoryHistory.class)
                    .setParameter("variantId", variantId)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}
