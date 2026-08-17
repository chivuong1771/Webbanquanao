<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Mã Giảm Giá - Admin Panel</title>
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
            <a href="${pageContext.request.contextPath}/admin/orders" class="admin-menu-item">
                <i class="fa-solid fa-receipt"></i> Đơn hàng
            </a>
            <a href="${pageContext.request.contextPath}/admin/coupons" class="admin-menu-item active">
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
            <h1 style="font-size: 2rem; font-weight: 800;">Quản Lý Mã Giảm Giá (Coupons)</h1>
            <p style="color: var(--text-secondary);">Tạo và quản lý các chương trình ưu đãi, mã giảm giá cho khách hàng</p>
        </header>

        <div style="display: grid; grid-template-columns: 1fr 2fr; gap: 24px; align-items: start;">
            <!-- Form Thêm/Sửa Coupon -->
            <div style="background: var(--bg-secondary); border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 24px;">
                <h3 style="font-size: 1.2rem; font-weight: 700; margin-bottom: 20px;">
                    ${coupon != null ? 'Cập Nhật Mã Giảm Giá' : 'Tạo Mã Giảm Giá Mới'}
                </h3>
                <form action="${pageContext.request.contextPath}/admin/coupons" method="POST">
                    <input type="hidden" name="id" value="${coupon != null ? coupon.id : ''}">
                    
                    <div class="form-group" style="margin-bottom: 14px;">
                        <label class="form-label">Mã Code (*)</label>
                        <input type="text" name="code" class="form-control" placeholder="VD: SALE20, HE2026" value="${coupon != null ? coupon.code : ''}" required style="text-transform: uppercase; font-weight: 700; letter-spacing: 1px;">
                    </div>

                    <div class="form-group" style="margin-bottom: 14px;">
                        <label class="form-label">Tên Mã Giảm Giá</label>
                        <input type="text" name="couponName" class="form-control" placeholder="Mô tả ưu đãi" value="${coupon != null ? coupon.couponName : ''}">
                    </div>

                    <div class="form-group" style="margin-bottom: 14px;">
                        <label class="form-label">Loại Giảm Giá</label>
                        <select name="discountType" class="form-control">
                            <option value="PERCENT" ${coupon != null && 'PERCENT'.equals(coupon.discountType) ? 'selected' : ''}>Theo Phần Trăm (%)</option>
                            <option value="FIXED" ${coupon != null && 'FIXED'.equals(coupon.discountType) ? 'selected' : ''}>Theo Số Tiền Cố Định (VNĐ)</option>
                        </select>
                    </div>

                    <div class="form-group" style="margin-bottom: 14px;">
                        <label class="form-label">Giá Trị Giảm (*)</label>
                        <input type="number" step="any" name="discountValue" class="form-control" placeholder="VD: 20 (% ) hoặc 50000 (đ)" value="${coupon != null ? coupon.discountValue : ''}" required>
                    </div>

                    <div class="form-group" style="margin-bottom: 14px;">
                        <label class="form-label">Đơn Hàng Tối Thiểu (VNĐ)</label>
                        <input type="number" step="any" name="minimumOrder" class="form-control" placeholder="VD: 200000" value="${coupon != null ? coupon.minimumOrder : '0'}">
                    </div>

                    <div class="form-group" style="margin-bottom: 14px;">
                        <label class="form-label">Số Lượng Lượt Dùng</label>
                        <input type="number" name="quantity" class="form-control" placeholder="VD: 100" value="${coupon != null ? coupon.quantity : '100'}">
                    </div>

                    <div style="margin-bottom: 20px;">
                        <label style="display: flex; align-items: center; gap: 8px; cursor: pointer;">
                            <input type="checkbox" name="status" value="true" ${coupon == null || coupon.status ? 'checked' : ''}>
                            <span>Đang kích hoạt áp dụng</span>
                        </label>
                    </div>

                    <div style="display: flex; gap: 10px;">
                        <button type="submit" class="btn btn-primary" style="flex: 1;">
                            <i class="fa-solid fa-floppy-disk"></i> ${coupon != null ? 'Lưu Cập Nhật' : 'Tạo Mã Giảm'}
                        </button>
                        <c:if test="${coupon != null}">
                            <a href="${pageContext.request.contextPath}/admin/coupons" class="btn" style="background: rgba(255,255,255,0.1); color: #fff;">Hủy</a>
                        </c:if>
                    </div>
                </form>
            </div>

            <!-- Bảng Danh Sách Coupons -->
            <div style="background: var(--bg-secondary); border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 24px;">
                <h3 style="font-size: 1.2rem; font-weight: 700; margin-bottom: 20px;">Danh Sách Mã Giảm Giá</h3>
                <div style="overflow-x: auto;">
                    <table style="width: 100%; border-collapse: collapse; text-align: left;">
                        <thead>
                            <tr style="border-bottom: 1px solid var(--border-color); color: var(--text-secondary);">
                                <th style="padding: 12px;">Mã Code</th>
                                <th style="padding: 12px;">Mức Giảm</th>
                                <th style="padding: 12px;">Đơn Tối Thiểu</th>
                                <th style="padding: 12px;">Số Lượng</th>
                                <th style="padding: 12px;">Trạng Thái</th>
                                <th style="padding: 12px; text-align: center;">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${coupons}">
                                <tr style="border-bottom: 1px solid var(--border-color);">
                                    <td style="padding: 14px; font-weight: 800; color: var(--accent); letter-spacing: 1px;">
                                        <i class="fa-solid fa-ticket"></i> ${item.code}
                                    </td>
                                    <td style="padding: 14px; font-weight: 700; color: #10b981;">
                                        <c:choose>
                                            <c:when test="${item.discountType == 'PERCENT'}">
                                                -${item.discountValue}%
                                            </c:when>
                                            <c:otherwise>
                                                -<fmt:formatNumber value="${item.discountValue}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="padding: 14px; color: var(--text-secondary);">
                                        <fmt:formatNumber value="${item.minimumOrder}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                    </td>
                                    <td style="padding: 14px;">${item.quantity}</td>
                                    <td style="padding: 14px;">
                                        <c:choose>
                                            <c:when test="${item.status}">
                                                <span style="color: #10b981; font-weight: 600;">● Hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #ef4444; font-weight: 600;">● Tạm khóa</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="padding: 14px; text-align: center; display: flex; gap: 8px; justify-content: center;">
                                        <a href="${pageContext.request.contextPath}/admin/coupon/edit?id=${item.id}" class="btn" style="background-color: #3b82f6; color: #fff; padding: 6px 12px; font-size: 0.85rem; text-decoration: none; border-radius: 4px;">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/coupon/delete?id=${item.id}" class="btn" style="background-color: #ef4444; color: #fff; padding: 6px 12px; font-size: 0.85rem; text-decoration: none; border-radius: 4px;" onclick="return confirm('Bạn có chắc muốn xóa mã giảm giá này?');">
                                            <i class="fa-solid fa-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</body>
</html>
