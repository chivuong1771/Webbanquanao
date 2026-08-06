package poly.java.DAO;

import poly.java.Entity.ProductVariant;
import java.util.List;

public interface ProductVariantDAO extends GenericDAO<ProductVariant, Integer> {
    List<ProductVariant> findByProductId(Integer productId);
    ProductVariant findByProductColorSize(Integer productId, Integer colorId, Integer sizeId);
}