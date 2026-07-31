<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Sản Phẩm</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container-fluid py-4 px-4">
<h2 class="mb-4">${product != null ? "Cập Nhật Sản Phẩm" : "Thêm Sản Phẩm Mới"}</h2>

<!-- Form Sản Phẩm -->
<div class="card mb-4">
    <div class="card-body">
        <form action="${pageContext.request.contextPath}/admin/products" method="post">
            <input type="hidden" name="id" value="${product.id}">

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Tên Sản Phẩm (*)</label>
                    <input type="text" name="productName" class="form-control" value="${product.productName}" required>
                </div>

                <div class="col-md-3 mb-3">
                    <label class="form-label">Loại Sản Phẩm (*)</label>
                    <select name="categoryId" class="form-select" required>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.id}" ${product != null && product.categoryID.id == cat.id ? 'selected' : ''}>
                                    ${cat.categoryName}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-3 mb-3">
                    <label class="form-label">Thương Hiệu (Brand ID) (*)</label>
                    <input type="number" name="brandId" class="form-control" value="${product != null ? product.brandID.id : 1}" required>
                </div>
            </div>

            <div class="row">
                <div class="col-md-3 mb-3">
                    <label class="form-label">Giá Bán VNĐ (*)</label>
                    <input type="number" step="0.01" name="price" class="form-control" value="${product.price}" required>
                </div>

                <div class="col-md-3 mb-3">
                    <label class="form-label">Giá Khuyến Mãi VNĐ</label>
                    <input type="number" step="0.01" name="discountPrice" class="form-control" value="${product.discountPrice}">
                </div>

                <div class="col-md-3 mb-3">
                    <label class="form-label">Chất Liệu</label>
                    <input type="text" name="material" class="form-control" value="${product.material}">
                </div>

                <div class="col-md-3 mb-3">
                    <label class="form-label">Đường dẫn Ảnh (URL Thumbnail)</label>
                    <input type="text" name="thumbnail" class="form-control" value="${product.thumbnail}">
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">Mô Tả Chi Tiết</label>
                <textarea name="description" class="form-control" rows="3">${product.description}</textarea>
            </div>

            <div class="form-check mb-3">
                <input class="form-check-input" type="checkbox" name="status" id="pStatus" ${product == null || product.status ? 'checked' : ''}>
                <label class="form-check-label" for="pStatus">Đang Kinh Doanh (Hiển thị)</label>
            </div>

            <button type="submit" class="btn btn-primary">${product != null ? "Cập Nhật" : "Thêm Mới"}</button>
            <c:if test="${product != null}">
                <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-secondary">Hủy</a>
            </c:if>
        </form>
    </div>
</div>

<!-- Bảng Danh Sách Sản Phẩm -->
<h3>Danh Sách Sản Phẩm</h3>
<table class="table table-bordered table-hover align-middle">
    <thead class="table-dark">
    <tr>
        <th>Ảnh</th>
        <th>Tên Sản Phẩm</th>
        <th>Loại</th>
        <th>Giá Gốc</th>
        <th>Giá Bán</th>
        <th>Đã Bán</th>
        <th>Lượt Xem</th>
        <th>Trạng Thái</th>
        <th>Hành Động</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="p" items="${products}">
        <tr>
            <td class="text-center">
                <img src="${p.thumbnail}" alt="Thumbnail" style="width: 50px; height: 50px; object-fit: cover;" onerror="this.src='https://via.placeholder.com/50'">
            </td>
            <td><strong>${p.productName}</strong></td>
            <td><span class="badge bg-info text-dark">${p.categoryID.categoryName}</span></td>
            <td><fmt:formatNumber value="${p.price}" type="currency" currencySymbol="đ"/></td>
            <td>
                <c:choose>
                    <c:when test="${not empty p.discountPrice}">
                        <strong class="text-danger"><fmt:formatNumber value="${p.discountPrice}" type="currency" currencySymbol="đ"/></strong>
                    </c:when>
                    <c:otherwise>
                        <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="đ"/>
                    </c:otherwise>
                </c:choose>
            </td>
            <td>${p.soldQuantity}</td>
            <td>${p.viewCount}</td>
            <td>
                        <span class="badge ${p.status ? 'bg-success' : 'bg-secondary'}">
                                ${p.status ? 'Kinh doanh' : 'Ngừng bán'}
                        </span>
            </td>
            <td>
                <a href="${pageContext.request.contextPath}/admin/product/edit?id=${p.id}" class="btn btn-sm btn-warning">Sửa</a>
                <a href="${pageContext.request.contextPath}/admin/product/delete?id=${p.id}" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc muốn chuyển trạng thái sản phẩm này?')">Ẩn/Xóa</a>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>
</body>
</html>