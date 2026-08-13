package poly.java.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import poly.java.DAO.BannerDAO;
import poly.java.DAO.CategoryDAO;
import poly.java.DAO.ProductDAO;
import poly.java.DAO.Impl.BannerDAOImpl;
import poly.java.DAO.Impl.CategoryDAOImpl;
import poly.java.DAO.Impl.ProductDAOImpl;
import poly.java.Entity.Banner;
import poly.java.Entity.Category;
import poly.java.Entity.Product;

import java.io.IOException;
import java.util.List;

@WebServlet({"", "/home", "/index"})
public class HomeServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAOImpl();
    private final CategoryDAO categoryDAO = new CategoryDAOImpl();
    private final BannerDAO bannerDAO = new BannerDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<Category> categories = categoryDAO.findActiveCategories();
            List<Product> products = productDAO.findActiveProducts();
            List<Banner> banners = bannerDAO.findActive();

            req.getServletContext().setAttribute("categories", categories);

            req.setAttribute("categories", categories);
            req.setAttribute("products", products);
            req.setAttribute("newArrivals", products);
            req.setAttribute("bestSellers", products);
            req.setAttribute("discountProducts", products);
            req.setAttribute("banners", banners);
        } catch (Exception e) {
            e.printStackTrace();
        }

        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }
}
