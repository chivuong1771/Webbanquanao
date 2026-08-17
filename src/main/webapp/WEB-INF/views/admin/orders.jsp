<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Đơn Hàng - Admin Panel</title>
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
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-menu-item">
                <i class="fa-solid fa-chart-pie"></i> Tổng quan
            </a>
            <a href="${pageContext.request.contextPath}/admin/products" class="admin-menu-item">
                <i class="fa-solid fa-shirt"></i> Sản phẩm
            </a>
            <a href="${pageContext.request.contextPath}/admin/categories" class="admin-menu-item">
                <i class="fa-solid fa-list"></i> Danh mục
            </a>
            <a href="${pageContext.request.contextPath}/admin/orders" class="admin-menu-item active">
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
        <header style="background: transparent; border: none; padding: 0; margin-bottom: 30px; position: static;">
            <div style="display: flex; justify-content: space-between; align-items: center;">
                <div>
                    <h1 style="font-size: 2rem; font-weight: 800;">Quản Lý Hóa Đơn & Đơn Hàng</h1>
                    <p style="color: var(--text-secondary);">Theo dõi tình trạng đơn đặt hàng và xử lý vận chuyển</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/statistics" class="btn btn-primary">
                        <i class="fa-solid fa-chart-line"></i> Báo Cáo Doanh Thu
                    </a>
                </div>
            </div>
        </header>

        <c:if test="${param.success == 'cancel_order'}">
            <div style="background-color: #065f46; color: #34d399; padding: 14px; border-radius: var(--radius-sm); margin-bottom: 20px; border: 1px solid #059669;">
                <i class="fa-solid fa-circle-check"></i> Đã hủy đơn hàng thành công và cập nhật trạng thái đơn thành CANCELLED!
            </div>
        </c:if>

        <!-- Bảng Danh Sách Đơn Hàng -->
        <div style="background-color: var(--bg-secondary); border-radius: var(--radius-md); border: 1px solid var(--border-color); padding: 20px; overflow-x: auto;">
            <table style="width: 100%; border-collapse: collapse; text-align: left;">
                <thead>
                    <tr style="border-bottom: 1px solid var(--border-color); color: var(--text-secondary);">
                        <th style="padding: 12px;">Mã Đơn (#)</th>
                        <th style="padding: 12px;">Khách Hàng / Nhân Viên</th>
                        <th style="padding: 12px;">Ngày Tạo</th>
                        <th style="padding: 12px;">Tổng Tiền</th>
                        <th style="padding: 12px;">Phương Thức</th>
                        <th style="padding: 12px;">Trạng Thái</th>
                        <th style="padding: 12px; text-align: center;">Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty orders}">
                            <c:forEach var="o" items="${orders}">
                                <tr style="border-bottom: 1px solid var(--border-color);">
                                    <td style="padding: 14px; font-weight: 700; color: var(--accent);">#${o.id}</td>
                                    <td style="padding: 14px; font-weight: 600;">
                                        ${o.userID != null ? o.userID.fullName : (o.fullname != null ? o.fullname : 'Khách hàng')}
                                    </td>
                                    <td style="padding: 14px; color: var(--text-secondary);">${o.orderDate}</td>
                                    <td style="padding: 14px; font-weight: 700; color: #ef4444;">
                                        <fmt:formatNumber value="${o.finalAmount != null ? o.finalAmount : o.totalPrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                    </td>
                                    <td style="padding: 14px;">
                                        <span class="badge" style="background: rgba(255,255,255,0.08); padding: 4px 8px; border-radius: 4px; font-size: 0.8rem;">${o.paymentMethod}</span>
                                    </td>
                                    <td style="padding: 14px;">
                                        <c:choose>
                                            <c:when test="${o.orderStatus == 'CONFIRMED' || o.orderStatus == 'PAID' || o.orderStatus == 'DELIVERED'}">
                                                <span style="color: #10b981; font-weight: 600;">● ${o.orderStatus}</span>
                                            </c:when>
                                            <c:when test="${o.orderStatus == 'CANCELLED'}">
                                                <span style="color: #ef4444; font-weight: 600;">● Đã hủy (CANCELLED)</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #f59e0b; font-weight: 600;">● ${o.orderStatus}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="padding: 14px; text-align: center; display: flex; gap: 8px; justify-content: center;">
                                        <!-- Xem chi tiết đơn hàng -->
                                        <a href="${pageContext.request.contextPath}/admin/orders/detail?id=${o.id}" class="btn" style="background-color: #3b82f6; color: #fff; padding: 6px 12px; font-size: 0.85rem; text-decoration: none; border-radius: 4px;">
                                            <i class="fa-solid fa-eye"></i> Chi Tiết
                                        </a>

                                        <!-- Hủy đơn hàng -->
                                        <c:if test="${o.orderStatus != 'CANCELLED'}">
                                            <a href="${pageContext.request.contextPath}/admin/orders/cancel?id=${o.id}" class="btn" style="background-color: #ef4444; color: #fff; padding: 6px 12px; font-size: 0.85rem; text-decoration: none; border-radius: 4px;" onclick="return confirm('Bạn có chắc chắn muốn hủy hóa đơn #${o.id}?');">
                                                <i class="fa-solid fa-ban"></i> Hủy
                                            </a>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7" style="text-align: center; padding: 30px; color: var(--text-secondary);">Chưa có đơn hàng nào.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </main>
</body>
</html>
