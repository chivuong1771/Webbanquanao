package poly.java.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import poly.java.DAO.CategoryDAO;
import poly.java.DAO.ProductDAO;
import poly.java.DAO.Impl.CategoryDAOImpl;
import poly.java.DAO.Impl.ProductDAOImpl;
import poly.java.Entity.Brand;
import poly.java.Entity.Category;
import poly.java.Entity.Product;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet({"/admin/products", "/admin/products/add", "/admin/products/edit", "/admin/product/create", "/admin/product/edit", "/admin/product/delete"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AdminProductServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAOImpl();
    private final CategoryDAO categoryDAO = new CategoryDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        switch (path) {
            case "/admin/product/edit", "/admin/products/edit" -> {
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    Product product = productDAO.findById(id);
                    req.setAttribute("product", product);
                } catch (Exception ignored) {}
            }
            case "/admin/product/delete" -> {
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    productDAO.delete(id);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                resp.sendRedirect(req.getContextPath() + "/admin/products");
                return;
            }
        }

        req.setAttribute("categories", categoryDAO.findAll());
        req.setAttribute("products", productDAO.findAll());
        req.getRequestDispatcher("/admin/products.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String idStr = req.getParameter("id");
        String productName = req.getParameter("name");
        if (productName == null || productName.isBlank()) {
            productName = req.getParameter("productName");
        }

        String categoryIdStr = req.getParameter("categoryId");
        String brandIdStr = req.getParameter("brandId");
        String priceStr = req.getParameter("price");
        String discountStr = req.getParameter("discountPrice");
        String description = req.getParameter("description");
        String imageUrlParam = req.getParameter("imageUrl");

        String thumbnail = imageUrlParam;

        // Xử lý upload file ảnh từ máy tính
        try {
            Part filePart = req.getPart("imageFile");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = extractFileName(filePart);
                if (fileName != null && !fileName.isBlank()) {
                    String uploadPath = req.getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "products";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    String newFileName = System.currentTimeMillis() + "_" + fileName;
                    String filePath = uploadPath + File.separator + newFileName;
                    filePart.write(filePath);
                    thumbnail = "uploads/products/" + newFileName;
                }
            }
        } catch (Exception e) {
            System.err.println("Upload image error: " + e.getMessage());
        }

        int categoryId = categoryIdStr != null && !categoryIdStr.isBlank() ? Integer.parseInt(categoryIdStr) : 1;
        int brandId = brandIdStr != null && !brandIdStr.isBlank() ? Integer.parseInt(brandIdStr) : 1;
        BigDecimal price = priceStr != null && !priceStr.isBlank() ? new BigDecimal(priceStr) : BigDecimal.ZERO;
        BigDecimal discountPrice = (discountStr != null && !discountStr.isBlank()) ? new BigDecimal(discountStr) : null;

        Product product = new Product();
        if (idStr != null && !idStr.isBlank()) {
            Product existing = productDAO.findById(Integer.parseInt(idStr));
            if (existing != null) {
                product = existing;
            }
        }

        product.setProductName(productName);

        Category category = new Category();
        category.setId(categoryId);
        product.setCategoryID(category);

        Brand brand = new Brand();
        brand.setId(brandId);
        product.setBrandID(brand);

        product.setPrice(price);
        product.setDiscountPrice(discountPrice);
        if (thumbnail != null && !thumbnail.isBlank()) {
            product.setThumbnail(thumbnail);
        }
        product.setDescription(description);
        product.setStatus(true);

        if (product.getId() != null) {
            productDAO.update(product);
        } else {
            product.setSoldQuantity(0);
            product.setViewCount(0);
            productDAO.create(product);
        }

        resp.sendRedirect(req.getContextPath() + "/admin/products");
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        for (String s : contentDisp.split(";")) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }
}