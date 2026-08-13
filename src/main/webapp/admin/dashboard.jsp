<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Fashion Shop</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=2">
</head>
<body class="admin-layout">

    <!-- Sidebar Admin -->
    <aside class="admin-sidebar">
        <div class="logo" style="margin-bottom: 30px;">
            PANEL ADMIN
        </div>
        <div style="color: var(--text-muted); font-size: 0.8rem; text-transform: uppercase; font-weight: 700; letter-spacing: 1px;">
            QUẢN LÝ HỆ THỐNG
        </div>
        <nav class="admin-menu">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-menu-item active">
                <i class="fa-solid fa-chart-pie"></i> Tổng quan
            </a>
            <a href="${pageContext.request.contextPath}/admin/products" class="admin-menu-item">
                <i class="fa-solid fa-shirt"></i> Sản phẩm
            </a>
            <a href="${pageContext.request.contextPath}/admin/orders" class="admin-menu-item">
                <i class="fa-solid fa-receipt"></i> Đơn hàng
            </a>
            <a href="${pageContext.request.contextPath}/" class="admin-menu-item" style="margin-top: 40px; border-top: 1px solid var(--border-color); padding-top: 20px; color: var(--accent);">
                <i class="fa-solid fa-store"></i> Về Cửa Hàng
            </a>
        </nav>
    </aside>

    <!-- Main Content -->
    <main class="admin-main">
        <header style="background: transparent; border: none; padding: 0; margin-bottom: 40px; position: static;">
            <div style="display: flex; justify-content: space-between; align-items: center;">
                <div>
                    <h1 style="font-size: 2rem; font-weight: 800;">Trang Tổng Quan Báo Cáo</h1>
                    <p style="color: var(--text-secondary);">Thống kê hiệu quả hoạt động kinh doanh của cửa hàng</p>
                </div>
                <div class="username-display" style="font-size: 1.1rem;">
                    Chào, <strong>${sessionScope.currentUser.fullname}</strong> (Quản trị viên)
                </div>
            </div>
        </header>

        <!-- Thẻ Thống Kê (Stat Cards) -->
        <section class="stat-grid">
            <div class="stat-card">
                <div class="stat-title">Doanh thu đã giao</div>
                <div class="stat-value revenue">
                    <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-title">Tổng số đơn hàng</div>
                <div class="stat-value">${totalOrders} đơn</div>
            </div>

            <div class="stat-card">
                <div class="stat-title">Đơn chờ xử lý</div>
                <div class="stat-value" style="color: #f59e0b;">${pendingOrders} đơn</div>
            </div>

            <div class="stat-card">
                <div class="stat-title">Đơn đã hoàn thành</div>
                <div class="stat-value" style="color: #10b981;">${completedOrders} đơn</div>
            </div>

            <div class="stat-card">
                <div class="stat-title">Sản phẩm trong kho</div>
                <div class="stat-value">${totalProducts} mẫu</div>
            </div>

            <div class="stat-card">
                <div class="stat-title">Khách hàng đăng ký</div>
                <div class="stat-value">${totalUsers} thành viên</div>
            </div>
        </section>

        <!-- Giao diện hiển thị thêm thông tin (nếu cần) -->
        <section style="background-color: var(--bg-secondary); border: 1px solid var(--border-color); padding: 30px; border-radius: var(--radius-md);">
            <h3 style="font-size: 1.3rem; font-weight: 700; margin-bottom: 16px;">
                <i class="fa-solid fa-circle-info" style="color: var(--accent); margin-right: 8px;"></i> Hướng dẫn Quản trị viên
            </h3>
            <p style="color: var(--text-secondary); font-size: 0.95rem; margin-bottom: 12px; line-height: 1.6;">
                Chào mừng bạn đến với trang quản trị cửa hàng thời trang. Tại đây, bạn có thể thực hiện kiểm tra và quản lý:
            </p>
            <ul style="color: var(--text-secondary); font-size: 0.95rem; display: flex; flex-direction: column; gap: 8px; list-style-type: disc; padding-left: 20px;">
                <li>Xem và cập nhật trạng thái đơn hàng của khách hàng (Xác nhận, Giao hàng, Đã giao, Hủy đơn).</li>
                <li>Theo dõi tồn kho của các biến thể sản phẩm (Kích cỡ, màu sắc).</li>
                <li>Xem thông tin doanh số thu về thực tế từ các hóa đơn đã hoàn thành giao hàng thành công.</li>
            </ul>
        </section>
    </main>

</body>
</html>
