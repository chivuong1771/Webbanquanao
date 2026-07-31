package poly.java.DAO;

import poly.java.Entity.ProductVariant;
import java.util.List;

public interface ProductVariantDAO {
    ProductVariant create(ProductVariant entity);
    ProductVariant update(ProductVariant entity);
    void delete(Integer id);
    List<ProductVariant> findByProductId(Integer productId);
}