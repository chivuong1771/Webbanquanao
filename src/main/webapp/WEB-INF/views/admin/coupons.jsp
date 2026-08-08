<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Mã Giảm Giá - Admin Panel</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=2">
</head>
<body class="admin-layout">

    <aside class="admin-sidebar">
        <div class="logo" style="margin-bottom: 30px;">PANEL ADMIN</div>
        <div style="color: var(--text-muted); font-size: 0.8rem; text-transform: uppercase; font-weight: 700;">QUẢN LÝ HỆ THỐNG</div>
        <nav class="admin-menu">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-menu-item"><i class="fa-solid fa-chart-pie"></i> Tổng quan</a>
            <a href="${pageContext.request.contextPath}/admin/products" class="admin-menu-item"><i class="fa-solid fa-shirt"></i> Sản phẩm</a>
            <a href="${pageContext.request.contextPath}/admin/categories" class="admin-menu-item"><i class="fa-solid fa-list"></i> Danh mục</a>
            <a href="${pageContext.request.contextPath}/admin/orders" class="admin-menu-item"><i class="fa-solid fa-receipt"></i> Đơn hàng</a>
            <a href="${pageContext.request.contextPath}/admin/coupons" class="admin-menu-item active"><i class="fa-solid fa-ticket"></i> Mã giảm giá</a>
            <a href="${pageContext.request.contextPath}/" class="admin-menu-item" style="margin-top: 40px; color: var(--accent);"><i class="fa-solid fa-store"></i> Về Cửa Hàng</a>
        </nav>
    </aside>

    <main class="admin-main">
        <header style="margin-bottom: 30px;">
            <h1 style="font-size: 2rem; font-weight: 800;">Quản Lý Mã Giảm Giá (Coupons)</h1>
        </header>

        <div style="display: grid; grid-template-columns: 1fr 2fr; gap: 24px;">
            <!-- Form Thêm/Sửa Coupon -->
            <div style="background: var(--bg-secondary); border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 24px;">
                <h3 style="font-size: 1.2rem; font-weight: 700; margin-bottom: 20px;">
                    ${coupon != null ? 'Cập Nhật Mã' : 'Tạo Mã Giảm Giá Mới'}
                </h3>
                <form action="${pageContext.request.contextPath}/admin/coupons" method="POST">
                    <input type="hidden" name="id" value="${coupon != null ? coupon.id : ''}">
                    
                    <div class="form-group" style="margin-bottom: 14px;">
                        <label class="form-label">Mã Code (*)</label>
                        <input type="text" name="code" class="form-control" placeholder="VD: SALE20" value="${coupon != null ? coupon.code : ''}" required style="text-transform: uppercase;">
                    </div>

                    <div class="form-group" style="margin-bottom: 14px;">
                        <label class="form-label">Tên Mã Giảm Giá</label>
                        <input type="text" name="couponName" class="form-control" placeholder="Mô tả mã" value="${coupon != null ? coupon.couponName : ''}">
                    </div>

                    <div class="form-group" style="margin-bottom: 14px;">
                        <label class="form-label">Loại Giảm</label>
                        <select name="discountType" class="form-control">
                            <option value="PERCENT" ${coupon != null && 'PERCENT'.equals(coupon.discountType) ? 'selected' : ''}>Theo Phần Trăm (%)</option>
                            <option value="FIXED" ${coupon != null && 'FIXED'.equals(coupon.discountType) ? 'selected' : ''}>Theo Tiền Cố Định (VNĐ)</option>
                        </select>
                    </div>

                    <div class="form-group" style="margin-bottom: 14px;">
                        <label class="form-label">Giá Trị Giảm (*)</label>
                        <input type="number" step="0.01" name="discountValue" class="form-control" value="${coupon != null ? coupon.discountValue : ''}" required>
                    </div>

                    <div class="form-group" style="margin-bottom: 14px;">
                        <label class="form-label">Đơn Hàng Tối Thiểu</label>
                        <input type="number" step="0.01" name="minimumOrder" class="form-control" value="${coupon != null ? coupon.minimumOrder : ''}">
                    </div>

                    <div class="form-group" style="margin-bottom: 14px;">
                        <label class="form-label">Số Lượng</label>
                        <input type="number" name="quantity" class="form-control" value="${coupon != null ? coupon.quantity : ''}">
                    </div>

                    <div class="form-group" style="margin-bottom: 20px; display: flex; align-items: center; gap: 8px;">
                        <input type="checkbox" id="status" name="status" ${coupon == null || coupon.status ? 'checked' : ''}>
                        <label for="status">Kích hoạt mã</label>
                    </div>

                    <button type="submit" class="btn btn-primary" style="width: 100%;">
                        ${coupon != null ? 'LƯU CẬP NHẬT' : 'TẠO MÃ MỚI'}
                    </button>
                </form>
            </div>

            <!-- Bảng danh sách Coupons -->
            <div style="background: var(--bg-secondary); border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 24px;">
                <h3 style="font-size: 1.2rem; font-weight: 700; margin-bottom: 20px;">Danh Sách Mã Giảm Giá</h3>
                <table style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr style="border-bottom: 1px solid var(--border-color); color: var(--text-secondary);">
                            <th style="padding: 12px;">ID</th>
                            <th style="padding: 12px;">Mã Code</th>
                            <th style="padding: 12px;">Loại / Giá Trị</th>
                            <th style="padding: 12px;">Đơn Tối Thiểu</th>
                            <th style="padding: 12px;">Trạng Thái</th>
                            <th style="padding: 12px; text-align: center;">Hành Động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${coupons}">
                            <tr style="border-bottom: 1px solid var(--border-color);">
                                <td style="padding: 12px;">#${c.id}</td>
                                <td style="padding: 12px; font-weight: 700; color: var(--accent);">${c.code}</td>
                                <td style="padding: 12px;">
                                    <c:choose>
                                        <c:when test="${'PERCENT'.equalsIgnoreCase(c.discountType)}">${c.discountValue}%</c:when>
                                        <c:otherwise><fmt:formatNumber value="${c.discountValue}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="padding: 12px;">
                                    <fmt:formatNumber value="${c.minimumOrder}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                </td>
                                <td style="padding: 12px;">
                                    <span style="color: ${c.status ? '#10b981' : '#ef4444'}; font-weight: 600;">
                                        ${c.status ? 'Hoạt động' : 'Tắt'}
                                    </span>
                                </td>
                                <td style="padding: 12px; text-align: center;">
                                    <a href="${pageContext.request.contextPath}/admin/coupon/edit?id=${c.id}" style="color: var(--accent); margin-right: 10px;"><i class="fa-solid fa-pen"></i></a>
                                    <a href="${pageContext.request.contextPath}/admin/coupon/delete?id=${c.id}" onclick="return confirm('Bạn có chắc chắn muốn xóa mã này?')" style="color: #ef4444;"><i class="fa-solid fa-trash"></i></a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

</body>
</html>
