package poly.java.DAO;

import poly.java.Entity.User;
import java.util.List;

public interface UserDAO extends GenericDAO<User, Integer> {

    User login(String email, String password);

    User findByEmail(String email);

    boolean existsByEmail(String email);

    List<User> findByRole(int roleId);

    List<User> findActiveUsers();

    // Bài 2: Tìm kiếm kết hợp phân trang nhân viên (người dùng)
    List<User> searchUsers(String keyword, String email, Boolean status, int page, int pageSize);
    long countSearchUsers(String keyword, String email, Boolean status);
}