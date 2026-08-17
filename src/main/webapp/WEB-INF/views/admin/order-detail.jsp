<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Hóa Đơn #${order.id} - Admin Panel</title>
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
                    <h1 style="font-size: 2rem; font-weight: 800;">Chi Tiết Hóa Đơn #${order.id}</h1>
                    <p style="color: var(--text-secondary);">Xem các mặt hàng, thông tin giao nhận và thanh toán</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/orders" class="btn" style="background: rgba(255,255,255,0.1); color: #fff;">
                    <i class="fa-solid fa-arrow-left"></i> Quay Lại Danh Sách
                </a>
            </div>
        </header>

        <!-- Thẻ Thông Tin Đơn Hàng -->
        <div style="background-color: var(--bg-secondary); border: 1px solid var(--border-color); padding: 24px; border-radius: var(--radius-md); margin-bottom: 30px; display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px;">
            <div>
                <span style="color: var(--text-secondary); font-size: 0.85rem;">Mã Đơn Hàng:</span>
                <div style="font-size: 1.3rem; font-weight: 800; color: var(--accent); margin-top: 4px;">#${order.id}</div>
            </div>
            <div>
                <span style="color: var(--text-secondary); font-size: 0.85rem;">Khách Hàng / Nhân Viên:</span>
                <div style="font-size: 1.1rem; font-weight: 600; margin-top: 4px;">${order.userID.fullName}</div>
                <div style="font-size: 0.85rem; color: var(--text-secondary);">${order.userID.email}</div>
            </div>
            <div>
                <span style="color: var(--text-secondary); font-size: 0.85rem;">Ngày Tạo Đơn:</span>
                <div style="font-size: 1rem; font-weight: 600; margin-top: 4px;">${order.orderDate}</div>
            </div>
            <div>
                <span style="color: var(--text-secondary); font-size: 0.85rem;">Trạng Thái Hóa Đơn:</span>
                <div style="margin-top: 4px;">
                    <c:choose>
                        <c:when test="${order.orderStatus == 'CANCELLED'}">
                            <span style="color: #ef4444; font-weight: 800;">● ĐÃ HỦY ĐƠN (CANCELLED)</span>
                        </c:when>
                        <c:otherwise>
                            <span style="color: #10b981; font-weight: 800;">● ${order.orderStatus}</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Bảng Sản Phẩm Trong Đơn Hàng -->
        <div style="background-color: var(--bg-secondary); border-radius: var(--radius-md); border: 1px solid var(--border-color); padding: 24px; margin-bottom: 30px; overflow-x: auto;">
            <h3 style="font-size: 1.2rem; font-weight: 700; margin-bottom: 18px;">Danh Sách Mặt Hàng Trong Hóa Đơn</h3>
            <table style="width: 100%; border-collapse: collapse; text-align: left;">
                <thead>
                    <tr style="border-bottom: 1px solid var(--border-color); color: var(--text-secondary);">
                        <th style="padding: 12px; width: 70px;">Hình Ảnh</th>
                        <th style="padding: 12px;">Tên Sản Phẩm</th>
                        <th style="padding: 12px;">Màu Sắc</th>
                        <th style="padding: 12px;">Kích Thước</th>
                        <th style="padding: 12px;">Đơn Giá</th>
                        <th style="padding: 12px;">Số Lượng</th>
                        <th style="padding: 12px; text-align: right;">Thành Tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${orderDetails}">
                        <tr style="border-bottom: 1px solid var(--border-color);">
                            <td style="padding: 12px;">
                                <c:choose>
                                    <c:when test="${not empty item.variantID.productID.thumbnail}">
                                        <img src="${item.variantID.productID.thumbnail.startsWith('http') ? item.variantID.productID.thumbnail : pageContext.request.contextPath.concat('/').concat(item.variantID.productID.thumbnail)}" style="width: 48px; height: 58px; object-fit: cover; border-radius: 4px;">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/assets/images/placeholder.jpg" style="width: 48px; height: 58px; object-fit: cover; border-radius: 4px;">
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="padding: 12px; font-weight: 600;">${item.variantID.productID.productName}</td>
                            <td style="padding: 12px; color: var(--text-secondary);">${item.variantID.colorID.colorName}</td>
                            <td style="padding: 12px; color: var(--text-secondary);">${item.variantID.sizeID.sizeName}</td>
                            <td style="padding: 12px; font-weight: 600;">
                                <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                            </td>
                            <td style="padding: 12px; font-weight: 700; color: #3b82f6;">x${item.quantity}</td>
                            <td style="padding: 12px; text-align: right; font-weight: 700; color: #ef4444;">
                                <fmt:formatNumber value="${item.total}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Tổng Cộng Thanh Toán -->
        <div style="background-color: var(--bg-secondary); border: 1px solid var(--border-color); padding: 24px; border-radius: var(--radius-md); text-align: right;">
            <div style="font-size: 1rem; color: var(--text-secondary); margin-bottom: 6px;">TỔNG TIỀN THANH TOÁN:</div>
            <div style="font-size: 2.2rem; font-weight: 800; color: var(--accent);">
                <fmt:formatNumber value="${order.finalAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
            </div>
        </div>
    </main>
</body>
</html>
