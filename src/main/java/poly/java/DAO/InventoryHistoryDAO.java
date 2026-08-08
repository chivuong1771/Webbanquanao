package poly.java.DAO;

import poly.java.Entity.InventoryHistory;
import java.util.List;

public interface InventoryHistoryDAO extends GenericDAO<InventoryHistory, Integer> {

    List<InventoryHistory> findByVariant(int variantId);

}