<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Loại Sản Phẩm</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container py-4">
<h2 class="mb-4">${category != null ? "Cập Nhật Loại Sản Phẩm" : "Thêm Loại Sản Phẩm Mới"}</h2>

<!-- Form Thêm / Sửa -->
<div class="card mb-4">
    <div class="card-body">
        <form action="${pageContext.request.contextPath}/admin/categories" method="post">
            <input type="hidden" name="id" value="${category.id}">

            <div class="mb-3">
                <label class="form-label">Tên Loại Sản Phẩm (*)</label>
                <input type="text" name="categoryName" class="form-control" value="${category.categoryName}" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Mô Tả</label>
                <textarea name="description" class="form-control" rows="3">${category.description}</textarea>
            </div>

            <div class="form-check mb-3">
                <input class="form-check-input" type="checkbox" name="status" id="status" ${category == null || category.status ? 'checked' : ''}>
                <label class="form-check-label" for="status">Hoạt động (Hiển thị)</label>
            </div>

            <button type="submit" class="btn btn-primary">${category != null ? "Cập Nhật" : "Tạo Mới"}</button>
            <c:if test="${category != null}">
                <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-secondary">Hủy</a>
            </c:if>
        </form>
    </div>
</div>

<!-- Danh sách Danh mục -->
<h3>Danh Sách Loại Sản Phẩm</h3>
<table class="table table-bordered table-striped align-middle">
    <thead class="table-dark">
    <tr>
        <th>ID</th>
        <th>Tên Loại</th>
        <th>Mô Tả</th>
        <th>Trạng Thái</th>
        <th>Hành Động</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="item" items="${categories}">
        <tr>
            <td>${item.id}</td>
            <td><strong>${item.categoryName}</strong></td>
            <td>${item.description}</td>
            <td>
                        <span class="badge ${item.status ? 'bg-success' : 'bg-danger'}">
                                ${item.status ? 'Kích hoạt' : 'Ẩn'}
                        </span>
            </td>
            <td>
                <a href="${pageContext.request.contextPath}/admin/category/edit?id=${item.id}" class="btn btn-sm btn-warning">Sửa</a>
                <a href="${pageContext.request.contextPath}/admin/category/delete?id=${item.id}" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc muốn ẩn/xóa danh mục này?')">Xóa</a>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>
</body>
</html>