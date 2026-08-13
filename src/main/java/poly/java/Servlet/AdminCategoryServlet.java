package poly.java.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import poly.java.DAO.CategoryDAO;
import poly.java.DAO.Impl.CategoryDAOImpl;
import poly.java.Entity.Category;

import java.io.IOException;

@WebServlet({"/admin/categories", "/admin/category/create", "/admin/category/edit", "/admin/category/delete"})
public class AdminCategoryServlet extends HttpServlet {

    private final CategoryDAO categoryDAO = new CategoryDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        switch (path) {
            case "/admin/category/edit" -> {
                int id = Integer.parseInt(req.getParameter("id"));
                Category category = categoryDAO.findById(id);
                req.setAttribute("category", category);
            }
            case "/admin/category/delete" -> {
                int id = Integer.parseInt(req.getParameter("id"));
                categoryDAO.delete(id); // Xóa mềm (chuyển status = false)
                resp.sendRedirect(req.getContextPath() + "/admin/categories");
                return;
            }
        }

        req.setAttribute("categories", categoryDAO.findAll());
        req.getRequestDispatcher("/WEB-INF/views/admin/categories.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String idStr = req.getParameter("id");
        String categoryName = req.getParameter("categoryName");
        String description = req.getParameter("description");
        boolean status = req.getParameter("status") != null;

        Category category = new Category();
        category.setCategoryName(categoryName);
        category.setDescription(description);
        category.setStatus(status);

        if (idStr != null && !idStr.isBlank()) {
            category.setId(Integer.parseInt(idStr));
            categoryDAO.update(category);
        } else {
            categoryDAO.create(category);
        }

        resp.sendRedirect(req.getContextPath() + "/admin/categories");
    }
}