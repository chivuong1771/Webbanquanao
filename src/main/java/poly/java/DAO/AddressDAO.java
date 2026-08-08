package poly.java.DAO;

import poly.java.Entity.Address;
import java.util.List;

public interface AddressDAO extends GenericDAO<Address, Integer> {

    List<Address> findByUser(int userId);

    Address findDefaultAddress(int userId);

}