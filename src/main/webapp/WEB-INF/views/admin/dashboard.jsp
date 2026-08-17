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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=3">
</head>
<body class="admin-layout">

    <!-- Sidebar Admin -->
    <aside class="admin-sidebar">
        <div class="logo" style="margin-bottom: 30px;">
            <i class="fa-solid fa-crown" style="color: var(--accent);"></i> PANEL ADMIN
        </div>
        <div style="color: var(--text-muted); font-size: 0.8rem; text-transform: uppercase; font-weight: 700; letter-spacing: 1px; margin-bottom: 12px;">
            QUẢN LÝ HỆ THỐNG
        </div>
        <nav class="admin-menu">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-menu-item active">
                <i class="fa-solid fa-chart-pie"></i> Tổng quan
            </a>
            <a href="${pageContext.request.contextPath}/admin/products" class="admin-menu-item">
                <i class="fa-solid fa-shirt"></i> Sản phẩm
            </a>
            <a href="${pageContext.request.contextPath}/admin/categories" class="admin-menu-item">
                <i class="fa-solid fa-list"></i> Danh mục
            </a>
            <a href="${pageContext.request.contextPath}/admin/orders" class="admin-menu-item">
                <i class="fa-solid fa-receipt"></i> Đơn hàng
            </a>
            <a href="${pageContext.request.contextPath}/admin/coupons" class="admin-menu-item">
                <i class="fa-solid fa-ticket"></i> Mã giảm giá
            </a>
            <a href="${pageContext.request.contextPath}/admin/users" class="admin-menu-item">
                <i class="fa-solid fa-users"></i> Người dùng
            </a>
            <a href="${pageContext.request.contextPath}/admin/statistics" class="admin-menu-item">
                <i class="fa-solid fa-chart-line"></i> Báo cáo thống kê
            </a>
            <a href="${pageContext.request.contextPath}/" class="admin-menu-item" style="margin-top: 30px; border-top: 1px solid var(--border-color); padding-top: 20px; color: var(--accent);">
                <i class="fa-solid fa-store"></i> Về Cửa Hàng
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="admin-menu-item" style="color: #ef4444;">
                <i class="fa-solid fa-right-from-bracket"></i> Đăng Xuất
            </a>
        </nav>
    </aside>

    <!-- Main Content -->
    <main class="admin-main">
        <header style="background: transparent; border: none; padding: 0; margin-bottom: 35px; position: static;">
            <div style="display: flex; justify-content: space-between; align-items: center;">
                <div>
                    <h1 style="font-size: 2rem; font-weight: 800;">Trang Tổng Quan Báo Cáo</h1>
                    <p style="color: var(--text-secondary);">Thống kê hiệu quả hoạt động kinh doanh của hệ thống</p>
                </div>
                <div class="username-display" style="font-size: 1.05rem;">
                    Xin chào, <strong>${sessionScope.currentUser.fullName != null ? sessionScope.currentUser.fullName : sessionScope.currentUser.fullname}</strong>
                </div>
            </div>
        </header>

        <!-- Thẻ Thống Kê Tổng Quan -->
        <div class="stat-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-bottom: 35px;">
            <div class="stat-card" style="background: var(--bg-secondary); border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 24px; border-left: 4px solid var(--accent);">
                <span class="stat-title" style="color: var(--text-secondary); font-size: 0.9rem;">Doanh Thu (30 Ngày)</span>
                <div class="stat-value" style="font-size: 1.8rem; font-weight: 800; color: var(--accent); margin-top: 8px;">
                    <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                </div>
            </div>
            <div class="stat-card" style="background: var(--bg-secondary); border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 24px; border-left: 4px solid #3b82f6;">
                <span class="stat-title" style="color: var(--text-secondary); font-size: 0.9rem;">Tổng Đơn Hàng</span>
                <div class="stat-value" style="font-size: 1.8rem; font-weight: 800; color: #3b82f6; margin-top: 8px;">
                    ${totalOrders} đơn
                </div>
            </div>
            <div class="stat-card" style="background: var(--bg-secondary); border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 24px; border-left: 4px solid #10b981;">
                <span class="stat-title" style="color: var(--text-secondary); font-size: 0.9rem;">Sản Phẩm Đang Bán</span>
                <div class="stat-value" style="font-size: 1.8rem; font-weight: 800; color: #10b981; margin-top: 8px;">
                    ${totalProducts} SP
                </div>
            </div>
            <div class="stat-card" style="background: var(--bg-secondary); border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 24px; border-left: 4px solid #a855f7;">
                <span class="stat-title" style="color: var(--text-secondary); font-size: 0.9rem;">Khách Hàng / Tài Khoản</span>
                <div class="stat-value" style="font-size: 1.8rem; font-weight: 800; color: #a855f7; margin-top: 8px;">
                    ${totalUsers} TV
                </div>
            </div>
        </div>

        <!-- Các Phím Tắt Quản Lý Nhanh -->
        <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 16px;">Lối Tắt Quản Trị Nhanh</h3>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; margin-bottom: 35px;">
            <a href="${pageContext.request.contextPath}/admin/products" style="background: var(--bg-secondary); border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 20px; text-decoration: none; color: inherit; display: flex; align-items: center; gap: 14px; transition: transform 0.2s;" onmouseover="this.style.transform='translateY(-3px)'" onmouseout="this.style.transform='none'">
                <div style="width: 44px; height: 44px; border-radius: 8px; background: rgba(59, 130, 246, 0.15); color: #3b82f6; display: flex; align-items: center; justify-content: center; font-size: 1.2rem;">
                    <i class="fa-solid fa-shirt"></i>
                </div>
                <div>
                    <div style="font-weight: 700;">Sản Phẩm</div>
                    <div style="font-size: 0.8rem; color: var(--text-secondary);">Thêm, sửa, kho hàng</div>
                </div>
            </a>
            <a href="${pageContext.request.contextPath}/admin/categories" style="background: var(--bg-secondary); border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 20px; text-decoration: none; color: inherit; display: flex; align-items: center; gap: 14px; transition: transform 0.2s;" onmouseover="this.style.transform='translateY(-3px)'" onmouseout="this.style.transform='none'">
                <div style="width: 44px; height: 44px; border-radius: 8px; background: rgba(16, 185, 129, 0.15); color: #10b981; display: flex; align-items: center; justify-content: center; font-size: 1.2rem;">
                    <i class="fa-solid fa-list"></i>
                </div>
                <div>
                    <div style="font-weight: 700;">Danh Mục</div>
                    <div style="font-size: 0.8rem; color: var(--text-secondary);">${totalCategories} danh mục</div>
                </div>
            </a>
            <a href="${pageContext.request.contextPath}/admin/orders" style="background: var(--bg-secondary); border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 20px; text-decoration: none; color: inherit; display: flex; align-items: center; gap: 14px; transition: transform 0.2s;" onmouseover="this.style.transform='translateY(-3px)'" onmouseout="this.style.transform='none'">
                <div style="width: 44px; height: 44px; border-radius: 8px; background: rgba(212, 175, 55, 0.15); color: var(--accent); display: flex; align-items: center; justify-content: center; font-size: 1.2rem;">
                    <i class="fa-solid fa-receipt"></i>
                </div>
                <div>
                    <div style="font-weight: 700;">Đơn Hàng</div>
                    <div style="font-size: 0.8rem; color: var(--text-secondary);">Xử lý và chi tiết đơn</div>
                </div>
            </a>
            <a href="${pageContext.request.contextPath}/admin/coupons" style="background: var(--bg-secondary); border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 20px; text-decoration: none; color: inherit; display: flex; align-items: center; gap: 14px; transition: transform 0.2s;" onmouseover="this.style.transform='translateY(-3px)'" onmouseout="this.style.transform='none'">
                <div style="width: 44px; height: 44px; border-radius: 8px; background: rgba(239, 68, 68, 0.15); color: #ef4444; display: flex; align-items: center; justify-content: center; font-size: 1.2rem;">
                    <i class="fa-solid fa-ticket"></i>
                </div>
                <div>
                    <div style="font-weight: 700;">Mã Giảm Giá</div>
                    <div style="font-size: 0.8rem; color: var(--text-secondary);">${totalCoupons} mã giảm</div>
                </div>
            </a>
            <a href="${pageContext.request.contextPath}/admin/statistics" style="background: var(--bg-secondary); border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 20px; text-decoration: none; color: inherit; display: flex; align-items: center; gap: 14px; transition: transform 0.2s;" onmouseover="this.style.transform='translateY(-3px)'" onmouseout="this.style.transform='none'">
                <div style="width: 44px; height: 44px; border-radius: 8px; background: rgba(168, 85, 247, 0.15); color: #a855f7; display: flex; align-items: center; justify-content: center; font-size: 1.2rem;">
                    <i class="fa-solid fa-chart-line"></i>
                </div>
                <div>
                    <div style="font-weight: 700;">Báo Cáo Biểu Đồ</div>
                    <div style="font-size: 0.8rem; color: var(--text-secondary);">Thống kê & Chart.js</div>
                </div>
            </a>
        </div>

        <!-- Đơn Hàng Gần Đây -->
        <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 16px;">Đơn Hàng Gần Đây</h3>
        <div style="background-color: var(--bg-secondary); border-radius: var(--radius-md); border: 1px solid var(--border-color); padding: 20px; overflow-x: auto;">
            <table style="width: 100%; border-collapse: collapse; text-align: left;">
                <thead>
                    <tr style="border-bottom: 1px solid var(--border-color); color: var(--text-secondary);">
                        <th style="padding: 12px;">Mã Đơn</th>
                        <th style="padding: 12px;">Khách Hàng</th>
                        <th style="padding: 12px;">Ngày Tạo</th>
                        <th style="padding: 12px;">Tổng Tiền</th>
                        <th style="padding: 12px;">Phương Thức</th>
                        <th style="padding: 12px;">Trạng Thái</th>
                        <th style="padding: 12px; text-align: center;">Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty recentOrders}">
                            <c:forEach var="o" items="${recentOrders}">
                                <tr style="border-bottom: 1px solid var(--border-color);">
                                    <td style="padding: 14px; font-weight: 700; color: var(--accent);">#${o.id}</td>
                                    <td style="padding: 14px; font-weight: 600;">${o.userID.fullName}</td>
                                    <td style="padding: 14px; color: var(--text-secondary);">${o.orderDate}</td>
                                    <td style="padding: 14px; font-weight: 700; color: #ef4444;">
                                        <fmt:formatNumber value="${o.finalAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                    </td>
                                    <td style="padding: 14px;"><span class="badge" style="background: rgba(255,255,255,0.08); padding: 4px 8px; border-radius: 4px; font-size: 0.8rem;">${o.paymentMethod}</span></td>
                                    <td style="padding: 14px;">
                                        <c:choose>
                                            <c:when test="${o.orderStatus == 'CONFIRMED' || o.orderStatus == 'PAID' || o.orderStatus == 'DELIVERED'}">
                                                <span style="color: #10b981; font-weight: 600;">● ${o.orderStatus}</span>
                                            </c:when>
                                            <c:when test="${o.orderStatus == 'CANCELLED'}">
                                                <span style="color: #ef4444; font-weight: 600;">● Đã hủy</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #f59e0b; font-weight: 600;">● ${o.orderStatus}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="padding: 14px; text-align: center;">
                                        <a href="${pageContext.request.contextPath}/admin/orders/detail?id=${o.id}" class="btn" style="background-color: #3b82f6; color: #fff; padding: 6px 12px; font-size: 0.85rem; text-decoration: none; border-radius: 4px;">
                                            <i class="fa-solid fa-eye"></i> Xem
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7" style="text-align: center; padding: 30px; color: var(--text-secondary);">Chưa có đơn hàng nào trong hệ thống.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </main>
</body>
</html>