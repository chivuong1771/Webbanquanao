package poly.java.DAO;

import poly.java.Entity.Category;
import java.util.List;

public interface CategoryDAO {
    Category create(Category entity);
    Category update(Category entity);
    void delete(Integer id);
    Category findById(Integer id);
    List<Category> findAll();
    List<Category> findActiveCategories();
}