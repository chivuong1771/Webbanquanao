package poly.java.DAO;

import poly.java.Entity.Product;
import java.util.List;

public interface ProductDAO {
    Product create(Product entity);
    Product update(Product entity);
    void delete(Integer id);
    Product findById(Integer id);
    List<Product> findAll();
    List<Product> findByCategoryId(Integer categoryId);
    List<Product> findActiveProducts();
    void updateViewCount(Integer productId);

    // Bài 1: Tìm kiếm kết hợp phân trang thức uống (sản phẩm)
    List<Product> searchProducts(String keyword, Integer categoryId, Boolean status, int page, int pageSize);
    long countSearchProducts(String keyword, Integer categoryId, Boolean status);
}