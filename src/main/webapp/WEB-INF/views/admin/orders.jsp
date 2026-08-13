<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="container" style="margin-top: 30px; margin-bottom: 80px;">
    <h2 class="section-title" style="margin-bottom: 20px;">LAB 6 - BÀI 1: QUẢN LÝ HÓA ĐƠN VÀ ĐƠN HÀNG (PHÍA ADMIN)</h2>

    <c:if test="${param.success == 'cancel_order'}">
        <div style="background-color: #065f46; color: #34d399; padding: 14px; border-radius: 8px; margin-bottom: 20px;">
            <i class="fa-solid fa-circle-check"></i> Đã hủy đơn hàng thành công! Trạng thái đơn đã được cập nhật thành CANCELLED.
        </div>
    </c:if>

    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
        <span style="color: var(--text-secondary);">Tổng số đơn hàng: <strong>${totalOrders}</strong> (Phân trang 10 đơn hàng mỗi trang)</span>
        <a href="${pageContext.request.contextPath}/admin/statistics" class="btn btn-primary" style="padding: 8px 16px;">
            <i class="fa-solid fa-chart-line"></i> Xem Báo Cáo Thống Kê (Bài 2 & 3)
        </a>
    </div>

    <!-- Bảng Danh Sách Đơn Hàng -->
    <div style="overflow-x: auto; background-color: var(--bg-secondary); border-radius: 8px; border: 1px solid var(--border-color);">
        <table style="width: 100%; border-collapse: collapse; text-align: left;">
            <thead>
                <tr style="border-bottom: 1px solid var(--border-color); background-color: rgba(255,255,255,0.05);">
                    <th style="padding: 14px;">Mã Đơn (#)</th>
                    <th style="padding: 14px;">Tên Nhân Viên / Khách Hàng</th>
                    <th style="padding: 14px;">Ngày Tạo Đơn</th>
                    <th style="padding: 14px;">Tổng Tiền</th>
                    <th style="padding: 14px;">Phương Thức</th>
                    <th style="padding: 14px;">Trạng Thái</th>
                    <th style="padding: 14px; text-align: center;">Thao Tác</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty orders}">
                        <c:forEach var="o" items="${orders}">
                            <tr style="border-bottom: 1px solid var(--border-color);">
                                <td style="padding: 14px; font-weight: 700; color: var(--accent);">#${o.id}</td>
                                <td style="padding: 14px; font-weight: 600;">${o.userID.fullName}</td>
                                <td style="padding: 14px;">
                                    <fmt:formatNumber value="${o.id}" pattern="#"/> (${o.orderDate})
                                </td>
                                <td style="padding: 14px; font-weight: 700; color: #ef4444;">
                                    <fmt:formatNumber value="${o.finalAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                </td>
                                <td style="padding: 14px;"><span class="badge">${o.paymentMethod}</span></td>
                                <td style="padding: 14px;">
                                    <c:choose>
                                        <c:when test="${o.orderStatus == 'CONFIRMED' || o.orderStatus == 'PAID'}">
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
                                    <a href="${pageContext.request.contextPath}/admin/orders/detail?id=${o.id}" class="btn" style="background-color: #3b82f6; color: #fff; padding: 6px 12px; font-size: 0.85rem;">
                                        <i class="fa-solid fa-eye"></i> Xem Chi Tiết
                                    </a>

                                    <!-- Hủy đơn hàng -->
                                    <c:if test="${o.orderStatus != 'CANCELLED'}">
                                        <a href="${pageContext.request.contextPath}/admin/orders/cancel?id=${o.id}" class="btn" style="background-color: #ef4444; color: #fff; padding: 6px 12px; font-size: 0.85rem;" onclick="return confirm('Bạn có chắc chắn muốn hủy hóa đơn #${o.id}?');">
                                            <i class="fa-solid fa-ban"></i> Hủy Đơn
                                        </a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="7" style="padding: 30px; text-align: center; color: var(--text-secondary);">Chưa có hóa đơn / đơn hàng nào trong hệ thống.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <!-- Phân trang 10 đơn hàng mỗi trang -->
    <c:if test="${totalPages > 1}">
        <div style="display: flex; justify-content: center; gap: 8px; margin-top: 30px;">
            <c:forEach begin="1" end="${totalPages}" var="p">
                <a href="${pageContext.request.contextPath}/admin/orders?page=${p}"
                   class="btn" style="padding: 8px 16px; background-color: ${p == currentPage ? 'var(--accent)' : 'var(--bg-secondary)'}; color: ${p == currentPage ? '#000' : '#fff'}; border: 1px solid var(--border-color);">
                    ${p}
                </a>
            </c:forEach>
        </div>
    </c:if>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
