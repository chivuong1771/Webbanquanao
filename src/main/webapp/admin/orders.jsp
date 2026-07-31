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
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-menu-item">
                <i class="fa-solid fa-chart-pie"></i> Tổng quan
            </a>
            <a href="${pageContext.request.contextPath}/admin/products" class="admin-menu-item">
                <i class="fa-solid fa-shirt"></i> Sản phẩm
            </a>
            <a href="${pageContext.request.contextPath}/admin/orders" class="admin-menu-item active">
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
            <div>
                <h1 style="font-size: 2rem; font-weight: 800;">Quản Lý Đơn Hàng</h1>
                <p style="color: var(--text-secondary);">Xem danh sách đơn đặt hàng và cập nhật trạng thái vận chuyển, thanh toán</p>
            </div>
        </header>

        <c:if test="${param.success == 'status_updated'}">
            <div class="form-success">Cập nhật thông tin trạng thái đơn hàng thành công!</div>
        </c:if>

        <div style="background-color: var(--bg-secondary); border-radius: var(--radius-md); border: 1px solid var(--border-color); padding: 24px; overflow-x: auto;">
            <table class="orders-table" style="width: 100%; border-collapse: collapse; border: none;">
                <thead>
                    <tr style="border-bottom: 1px solid var(--border-color);">
                        <th style="border: none; padding: 16px; color: var(--text-secondary);">Mã Đơn</th>
                        <th style="border: none; padding: 16px; color: var(--text-secondary);">Khách Hàng</th>
                        <th style="border: none; padding: 16px; color: var(--text-secondary);">Thông Tin Nhận Hàng</th>
                        <th style="border: none; padding: 16px; color: var(--text-secondary);">Ngày Đặt</th>
                        <th style="border: none; padding: 16px; color: var(--text-secondary);">Tổng Tiền</th>
                        <th style="border: none; padding: 16px; color: var(--text-secondary);">Trạng Thái Đơn</th>
                        <th style="border: none; padding: 16px; color: var(--text-secondary);">Thanh Toán</th>
                        <th style="border: none; padding: 16px; text-align: center; color: var(--text-secondary);">Cập Nhật Trạng Thái</th>
                        <th style="border: none; padding: 16px; text-align: center; color: var(--text-secondary); width: 80px;">Xóa</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="order" items="${orders}">
                        <tr style="border-bottom: 1px solid var(--border-color); font-size: 0.95rem;">
                            <td style="border: none; padding: 20px 16px; font-weight: 600;">#${order.id}</td>
                            <td style="border: none; padding: 20px 16px;">
                                <div><strong>${order.fullname}</strong></div>
                                <div style="color: var(--text-muted); font-size: 0.8rem;">User: @${order.username}</div>
                            </td>
                            <td style="border: none; padding: 20px 16px; max-width: 250px;">
                                <div>SĐT: ${order.phone}</div>
                                <div style="color: var(--text-secondary); font-size: 0.85rem; text-overflow: ellipsis; overflow: hidden; white-space: nowrap;" title="${order.address}">ĐC: ${order.address}</div>
                            </td>
                            <td style="border: none; padding: 20px 16px;">
                                <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                            </td>
                            <td style="border: none; padding: 20px 16px; font-weight: 700; color: var(--accent);">
                                <fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                            </td>
                            <td style="border: none; padding: 20px 16px;">
                                <span class="badge-status status-${order.orderStatus.toLowerCase()}" style="font-size: 0.75rem;">
                                    <c:choose>
                                        <c:when test="${order.orderStatus == 'PENDING'}">Chờ xác nhận</c:when>
                                        <c:when test="${order.orderStatus == 'CONFIRMED'}">Đã xác nhận</c:when>
                                        <c:when test="${order.orderStatus == 'SHIPPING'}">Đang giao</c:when>
                                        <c:when test="${order.orderStatus == 'DELIVERED'}">Đã giao hàng</c:when>
                                        <c:when test="${order.orderStatus == 'CANCELLED'}">Đã hủy đơn</c:when>
                                        <c:otherwise>${order.orderStatus}</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td style="border: none; padding: 20px 16px;">
                                <span class="badge-status" style="font-size: 0.75rem; background-color: ${order.paymentStatus == 'PAID' ? 'rgba(16, 185, 129, 0.15)' : 'rgba(239, 68, 68, 0.15)'}; color: ${order.paymentStatus == 'PAID' ? '#10b981' : '#ef4444'};">
                                    ${order.paymentStatus == 'PAID' ? 'Đã Thanh Toán' : 'Chưa Thanh Toán'}
                                </span>
                            </td>
                            <td style="border: none; padding: 20px 16px; text-align: center;">
                                <!-- Form Cập Nhật Trạng Thái trực tiếp -->
                                <form action="${pageContext.request.contextPath}/admin/orders/status" method="POST" style="display: flex; flex-direction: column; gap: 6px; align-items: center;">
                                    <input type="hidden" name="orderId" value="${order.id}">
                                    
                                    <select name="status" style="padding: 4px 8px; font-size: 0.85rem; background-color: var(--bg-primary); border: 1px solid var(--border-color); border-radius: var(--radius-sm); width: 140px;">
                                        <option value="PENDING" ${'PENDING'.equalsIgnoreCase(order.orderStatus) ? 'selected' : ''}>Chờ xác nhận</option>
                                        <option value="CONFIRMED" ${'CONFIRMED'.equalsIgnoreCase(order.orderStatus) ? 'selected' : ''}>Xác nhận đơn</option>
                                        <option value="SHIPPING" ${'SHIPPING'.equalsIgnoreCase(order.orderStatus) ? 'selected' : ''}>Giao hàng</option>
                                        <option value="DELIVERED" ${'DELIVERED'.equalsIgnoreCase(order.orderStatus) ? 'selected' : ''}>Đã giao hàng</option>
                                        <option value="CANCELLED" ${'CANCELLED'.equalsIgnoreCase(order.orderStatus) ? 'selected' : ''}>Hủy đơn hàng</option>
                                    </select>

                                    <select name="paymentStatus" style="padding: 4px 8px; font-size: 0.85rem; background-color: var(--bg-primary); border: 1px solid var(--border-color); border-radius: var(--radius-sm); width: 140px;">
                                        <option value="UNPAID" ${'UNPAID'.equalsIgnoreCase(order.paymentStatus) ? 'selected' : ''}>Chưa thanh toán</option>
                                        <option value="PAID" ${'PAID'.equalsIgnoreCase(order.paymentStatus) ? 'selected' : ''}>Đã thanh toán</option>
                                    </select>
                                    
                                    <button type="submit" class="btn btn-primary" style="padding: 4px 12px; font-size: 0.8rem; border-radius: var(--radius-sm); width: 140px;">
                                        Cập Nhật
                                    </button>
                                </form>
                            </td>
                            <td style="border: none; padding: 20px 16px; text-align: center;">
                                <a href="${pageContext.request.contextPath}/admin/orders/delete?id=${order.id}" onclick="return confirm('Bạn có chắc chắn muốn xóa đơn hàng này?')" style="color: #ef4444; font-size: 1.1rem;" title="Xóa đơn hàng">
                                    <i class="fa-solid fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </main>

</body>
</html>
