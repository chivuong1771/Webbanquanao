package poly.java.DAO;

import java.util.List;

public interface GenericDAO<T, ID> {

    T create(T entity);

    T update(T entity);

    void delete(ID id);

    T findById(ID id);

    List<T> findAll();
}