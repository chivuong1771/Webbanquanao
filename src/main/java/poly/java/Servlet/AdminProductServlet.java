package poly.java.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import poly.java.DAO.CategoryDAO;
import poly.java.DAO.ProductDAO;
import poly.java.DAO.Impl.CategoryDAOImpl;
import poly.java.DAO.Impl.ProductDAOImpl;
import poly.java.Entity.Brand;
import poly.java.Entity.Category;
import poly.java.Entity.Product;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet({"/admin/products", "/admin/product/create", "/admin/product/edit", "/admin/product/delete"})
public class AdminProductServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAOImpl();
    private final CategoryDAO categoryDAO = new CategoryDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        switch (path) {
            case "/admin/product/edit" -> {
                int id = Integer.parseInt(req.getParameter("id"));
                Product product = productDAO.findById(id);
                req.setAttribute("product", product);
            }
            case "/admin/product/delete" -> {
                int id = Integer.parseInt(req.getParameter("id"));
                productDAO.delete(id);
                resp.sendRedirect(req.getContextPath() + "/admin/products");
                return;
            }
        }

        req.setAttribute("categories", categoryDAO.findActiveCategories());
        req.setAttribute("products", productDAO.findAll());
        req.getRequestDispatcher("/WEB-INF/views/admin/products.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String idStr = req.getParameter("id");
        String productName = req.getParameter("productName");
        int categoryId = Integer.parseInt(req.getParameter("categoryId"));
        int brandId = Integer.parseInt(req.getParameter("brandId"));
        BigDecimal price = new BigDecimal(req.getParameter("price"));

        String discountStr = req.getParameter("discountPrice");
        BigDecimal discountPrice = (discountStr != null && !discountStr.isBlank()) ? new BigDecimal(discountStr) : null;

        String material = req.getParameter("material");
        String thumbnail = req.getParameter("thumbnail");
        String description = req.getParameter("description");
        boolean status = req.getParameter("status") != null;

        Product product = new Product();
        product.setProductName(productName);

        Category category = new Category();
        category.setId(categoryId);
        product.setCategoryID(category);

        Brand brand = new Brand();
        brand.setId(brandId);
        product.setBrandID(brand);

        product.setPrice(price);
        product.setDiscountPrice(discountPrice);
        product.setMaterial(material);
        product.setThumbnail(thumbnail);
        product.setDescription(description);
        product.setStatus(status);

        if (idStr != null && !idStr.isBlank()) {
            product.setId(Integer.parseInt(idStr));
            productDAO.update(product);
        } else {
            product.setSoldQuantity(0);
            product.setViewCount(0);
            productDAO.create(product);
        }

        resp.sendRedirect(req.getContextPath() + "/admin/products");
    }
}