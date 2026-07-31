<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang Quản Trị - Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="container-fluid">
    <div class="row min-vh-100">
        <!-- Sidebar Navigation (Menu Quản Trị) -->
        <div class="col-md-2 bg-dark text-white p-3">
            <h4 class="text-center py-2 border-bottom">ADMIN PANEL</h4>
            <div class="nav flex-column nav-pills mt-3">
                <a class="nav-link active text-white" href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="fa-solid fa-chart-line me-2"></i> Tổng Quan
                </a>
                <a class="nav-link text-white-50" href="${pageContext.request.contextPath}/admin/categories">
                    <i class="fa-solid fa-list me-2"></i> Quản Lý Loại SP
                </a>
                <a class="nav-link text-white-50" href="${pageContext.request.contextPath}/admin/products">
                    <i class="fa-solid fa-shirt me-2"></i> Quản Lý Sản Phẩm
                </a>
                <hr>
                <a class="nav-link text-white-50" href="${pageContext.request.contextPath}/home">
                    <i class="fa-solid fa-house me-2"></i> Về Trang Chủ
                </a>
                <a class="nav-link text-danger" href="${pageContext.request.contextPath}/logout">
                    <i class="fa-solid fa-right-from-bracket me-2"></i> Đăng Xuất
                </a>
            </div>
        </div>

        <!-- Main Content Container -->
        <div class="col-md-10 p-4">
            <h2>Chào mừng Admin, ${sessionScope.currentUser.fullName}!</h2>
            <p class="text-muted">Hệ thống quản lý cửa hàng E-Clothing Store</p>
            <hr>

            <!-- Cards Thống Kê Nhanh -->
            <div class="row g-3">
                <div class="col-md-4">
                    <div class="card text-white bg-primary p-3">
                        <h5>Quản Lý Loại SP</h5>
                        <p>Thêm, sửa, ẩn danh mục sản phẩm</p>
                        <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-light btn-sm text-primary fw-bold">Đi tới quản lý</a>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card text-white bg-success p-3">
                        <h5>Quản Lý Sản Phẩm</h5>
                        <p>Cập nhật kho, giá bán, thumbnail</p>
                        <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-light btn-sm text-success fw-bold">Đi tới quản lý</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>