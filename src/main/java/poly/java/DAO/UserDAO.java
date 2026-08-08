package poly.java.DAO;

import poly.java.Entity.User;
import java.util.List;

public interface UserDAO extends GenericDAO<User, Integer> {

    User login(String email, String password);

    User findByEmail(String email);

    boolean existsByEmail(String email);

    List<User> findByRole(int roleId);

    List<User> findActiveUsers();
}