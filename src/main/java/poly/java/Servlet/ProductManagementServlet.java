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
import poly.java.Entity.Product;

import java.io.IOException;
import java.util.List;

@WebServlet({"/admin/products"})
public class ProductManagementServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAOImpl();
    private final CategoryDAO categoryDAO = new CategoryDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        String categoryIdStr = req.getParameter("categoryId");
        String statusStr = req.getParameter("status");
        String pageStr = req.getParameter("page");

        Integer categoryId = null;
        if (categoryIdStr != null && !categoryIdStr.isBlank()) {
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (NumberFormatException ignored) {}
        }

        Boolean status = null;
        if (statusStr != null && !statusStr.isBlank()) {
            status = Boolean.parseBoolean(statusStr);
        }

        int page = 1;
        int pageSize = 10; // Bài 1: Phân trang thức uống / sản phẩm, mỗi trang 10 sản phẩm

        if (pageStr != null && !pageStr.isBlank()) {
            try {
                page = Math.max(1, Integer.parseInt(pageStr));
            } catch (NumberFormatException ignored) {}
        }

        List<Product> productList = productDAO.searchProducts(keyword, categoryId, status, page, pageSize);
        long totalProducts = productDAO.countSearchProducts(keyword, categoryId, status);
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
        if (totalPages < 1) totalPages = 1;

        req.setAttribute("products", productList);
        req.setAttribute("categories", categoryDAO.findAll());
        req.setAttribute("keyword", keyword);
        req.setAttribute("categoryId", categoryId);
        req.setAttribute("status", statusStr);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalProducts", totalProducts);

        req.getRequestDispatcher("/WEB-INF/views/admin/products.jsp").forward(req, resp);
    }
}
