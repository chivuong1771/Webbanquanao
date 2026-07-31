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

@WebServlet({"/products", "/product-detail"})
public class ProductServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAOImpl();
    private final CategoryDAO categoryDAO = new CategoryDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/product-detail".equals(path)) {
            // Xem chi tiết 1 sản phẩm
            showProductDetail(request, response);
        } else {
            // Xem danh sách sản phẩm (/products)
            showProductList(request, response);
        }
    }

    private void showProductList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String categoryIdStr = request.getParameter("categoryId");
        List<Product> products;

        if (categoryIdStr != null && !categoryIdStr.isBlank()) {
            try {
                int categoryId = Integer.parseInt(categoryIdStr);
                products = productDAO.findByCategoryId(categoryId);
                request.setAttribute("selectedCategoryId", categoryId);
            } catch (NumberFormatException e) {
                products = productDAO.findActiveProducts();
            }
        } else {
            products = productDAO.findActiveProducts();
        }

        request.setAttribute("categories", categoryDAO.findActiveCategories());
        request.setAttribute("products", products);
        request.getRequestDispatcher("/WEB-INF/views/products.jsp").forward(request, response);
    }

    private void showProductDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                Product product = productDAO.findById(id);
                if (product != null) {
                    // Tăng lượt xem
                    productDAO.updateViewCount(id);

                    request.setAttribute("product", product);
                    request.getRequestDispatcher("/WEB-INF/views/product-detail.jsp").forward(request, response);
                    return;
                }
            } catch (Exception ignored) {}
        }

        response.sendRedirect(request.getContextPath() + "/products");
    }
}