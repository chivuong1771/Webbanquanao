package poly.java.DAO.Impl;

import poly.java.DAO.SizeDAO;
import poly.java.Entity.Size;

public class SizeDAOImpl extends GenericDAOImpl<Size, Integer> implements SizeDAO {

    public SizeDAOImpl() {
        super(Size.class);
    }
}
