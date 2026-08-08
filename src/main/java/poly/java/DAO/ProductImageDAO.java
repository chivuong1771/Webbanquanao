package poly.java.DAO;

import poly.java.Entity.ProductImage;
import java.util.List;

public interface ProductImageDAO extends GenericDAO<ProductImage, Integer> {

    List<ProductImage> findByProduct(int productId);

    ProductImage findMainImage(int productId);

}