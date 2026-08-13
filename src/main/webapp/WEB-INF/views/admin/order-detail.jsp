<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="container" style="margin-top: 30px; margin-bottom: 80px;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
        <h2 class="section-title">CHI TIẾT HÓA ĐƠN #${order.id}</h2>
        <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-primary">
            <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách đơn hàng
        </a>
    </div>

    <!-- Thông tin tổng quan đơn hàng -->
    <div style="background-color: var(--bg-secondary); border: 1px solid var(--border-color); padding: 24px; border-radius: 8px; margin-bottom: 30px; display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px;">
        <div>
            <span style="color: var(--text-secondary); font-size: 0.9rem;">Mã Hóa Đơn:</span>
            <div style="font-size: 1.2rem; font-weight: 700; color: var(--accent);">#${order.id}</div>
        </div>
        <div>
            <span style="color: var(--text-secondary); font-size: 0.9rem;">Tên Nhân Viên / Khách Hàng Tạo Đơn:</span>
            <div style="font-size: 1.1rem; font-weight: 600;">${order.userID.fullName} (${order.userID.email})</div>
        </div>
        <div>
            <span style="color: var(--text-secondary); font-size: 0.9rem;">Ngày Tạo Đơn:</span>
            <div style="font-size: 1rem;">${order.orderDate}</div>
        </div>
        <div>
            <span style="color: var(--text-secondary); font-size: 0.9rem;">Trạng Thái Hóa Đơn:</span>
            <div>
                <c:choose>
                    <c:when test="${order.orderStatus == 'CANCELLED'}">
                        <span style="color: #ef4444; font-weight: 700;">● HỦY ĐƠN (CANCELLED)</span>
                    </c:when>
                    <c:otherwise>
                        <span style="color: #10b981; font-weight: 700;">● ${order.orderStatus}</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Danh sách sản phẩm trong hóa đơn -->
    <h3 style="font-size: 1.2rem; margin-bottom: 15px; font-weight: 700;">Danh Sách Sản Phẩm Trong Hóa Đơn</h3>
    <div style="overflow-x: auto; background-color: var(--bg-secondary); border-radius: 8px; border: 1px solid var(--border-color); margin-bottom: 30px;">
        <table style="width: 100%; border-collapse: collapse; text-align: left;">
            <thead>
                <tr style="border-bottom: 1px solid var(--border-color); background-color: rgba(255,255,255,0.05);">
                    <th style="padding: 14px;">Hình Ảnh</th>
                    <th style="padding: 14px;">Tên Sản Phẩm</th>
                    <th style="padding: 14px;">Màu Sắc</th>
                    <th style="padding: 14px;">Kích Thước (Size)</th>
                    <th style="padding: 14px;">Đơn Giá</th>
                    <th style="padding: 14px;">Số Lượng</th>
                    <th style="padding: 14px; text-align: right;">Thành Tiền</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${orderDetails}">
                    <tr style="border-bottom: 1px solid var(--border-color);">
                        <td style="padding: 14px;">
                            <c:choose>
                                <c:when test="${not empty item.variantID.productID.thumbnail}">
                                    <img src="${item.variantID.productID.thumbnail.startsWith('http') ? item.variantID.productID.thumbnail : pageContext.request.contextPath.concat('/').concat(item.variantID.productID.thumbnail)}" style="width: 50px; height: 60px; object-fit: cover; border-radius: 4px;">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/assets/images/placeholder.jpg" style="width: 50px; height: 60px; object-fit: cover; border-radius: 4px;">
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td style="padding: 14px; font-weight: 600;">${item.variantID.productID.productName}</td>
                        <td style="padding: 14px;">${item.variantID.colorID.colorName}</td>
                        <td style="padding: 14px;">${item.variantID.sizeID.sizeName}</td>
                        <td style="padding: 14px;">
                            <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                        </td>
                        <td style="padding: 14px; font-weight: 700;">x${item.quantity}</td>
                        <td style="padding: 14px; text-align: right; font-weight: 700; color: #ef4444;">
                            <fmt:formatNumber value="${item.total}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Tổng cộng thanh toán -->
    <div style="background-color: var(--bg-secondary); border: 1px solid var(--border-color); padding: 20px; border-radius: 8px; text-align: right;">
        <div style="font-size: 1.1rem; color: var(--text-secondary); margin-bottom: 8px;">TỔNG TIỀN HÓA ĐƠN:</div>
        <div style="font-size: 2.2rem; font-weight: 800; color: var(--accent);">
            <fmt:formatNumber value="${order.finalAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
