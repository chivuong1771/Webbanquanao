package poly.java.DAO.Impl;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import poly.java.DAO.InventoryHistoryDAO;
import poly.java.Entity.InventoryHistory;
import poly.java.Utils.JpaUtil;

import java.util.List;

public class InventoryHistoryDAOImpl extends GenericDAOImpl<InventoryHistory, Integer> implements InventoryHistoryDAO {

    public InventoryHistoryDAOImpl() {
        super(InventoryHistory.class);
    }

    @Override
    public List<InventoryHistory> findByVariantId(Integer variantId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String jpql = "SELECT ih FROM InventoryHistory ih WHERE ih.productVariant.id = :variantId ORDER BY ih.createdAt DESC";
            TypedQuery<InventoryHistory> query = em.createQuery(jpql, InventoryHistory.class);
            query.setParameter("variantId", variantId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
}