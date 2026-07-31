package poly.java.DAO;

import poly.java.Entity.Payment;

public interface PaymentDAO extends GenericDAO<Payment, Integer> {

    Payment findByOrder(int orderId);

    Payment findByTransactionCode(String code);

}