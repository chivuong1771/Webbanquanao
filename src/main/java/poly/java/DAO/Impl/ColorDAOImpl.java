package poly.java.DAO.Impl;

import poly.java.DAO.ColorDAO;
import poly.java.Entity.Color;

public class ColorDAOImpl extends GenericDAOImpl<Color, Integer> implements ColorDAO {

    public ColorDAOImpl() {
        super(Color.class);
    }
}
