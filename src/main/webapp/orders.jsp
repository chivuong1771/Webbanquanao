<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="container" style="padding-top: 40px; padding-bottom: 60px;">
    <h2 class="section-title">Đơn Hàng Của Tôi</h2>
    <p class="section-desc">Theo dõi tiến độ giao hàng và xem lại lịch sử mua sắm của bạn</p>

    <!-- Thông báo -->
    <c:if test="${param.success == 'order_placed'}">
        <div class="form-success">Đặt hàng thành công! Cảm ơn bạn đã lựa chọn mua sắm tại cửa hàng của chúng tôi.</div>
    </c:if>
    <c:if test="${param.success == 'payment_completed'}">
        <div class="form-success">Thanh toán đơn hàng thành công! Đơn hàng của bạn đang được hệ thống xác nhận và xử lý.</div>
    </c:if>
    <c:if test="${param.success == 'cancel_ok'}">
        <div class="form-success">Đã hủy đơn hàng thành công. Tiền và sản phẩm đã được hoàn trả lại.</div>
    </c:if>
    <c:if test="${param.error == 'cancel_failed'}">
        <div class="form-error">Hủy đơn hàng thất bại. Vui lòng liên hệ hỗ trợ.</div>
    </c:if>
    <c:if test="${param.error == 'payos_cancelled'}">
        <div class="form-error">Giao dịch thanh toán PayOS đã bị hủy hoặc chưa hoàn tất. Bạn có thể thanh toán lại sau.</div>
    </c:if>

    <div style="background-color: var(--bg-secondary); border-radius: var(--radius-md); border: 1px solid var(--border-color); padding: 24px; overflow-x: auto;">
        <c:choose>
            <c:when test="${not empty orders}">
                <table class="orders-table" style="width: 100%; border-collapse: collapse; border: none;">
                    <thead>
                        <tr style="border-bottom: 1px solid var(--border-color);">
                            <th style="border: none; padding: 16px; color: var(--text-secondary);">Mã Đơn</th>
                            <th style="border: none; padding: 16px; color: var(--text-secondary);">Ngày Đặt</th>
                            <th style="border: none; padding: 16px; color: var(--text-secondary);">Phương thức</th>
                            <th style="border: none; padding: 16px; color: var(--text-secondary);">Tổng Tiền</th>
                            <th style="border: none; padding: 16px; color: var(--text-secondary);">Trạng Thái Đơn</th>
                            <th style="border: none; padding: 16px; color: var(--text-secondary);">Thanh Toán</th>
                            <th style="border: none; padding: 16px; text-align: center; color: var(--text-secondary);">Hành Động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${orders}">
                            <tr style="border-bottom: 1px solid var(--border-color);">
                                <td style="border: none; padding: 20px 16px; font-weight: 600;">#${order.id}</td>
                                <td style="border: none; padding: 20px 16px;">
                                    <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>
                                <td style="border: none; padding: 20px 16px;">${order.paymentMethod}</td>
                                <td style="border: none; padding: 20px 16px; font-weight: 700; color: var(--accent);">
                                    <fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                </td>
                                <td style="border: none; padding: 20px 16px;">
                                    <span class="badge-status status-${order.orderStatus.toLowerCase()}">
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
                                    <span class="badge-status" style="background-color: ${order.paymentStatus == 'PAID' ? 'rgba(16, 185, 129, 0.15)' : 'rgba(239, 68, 68, 0.15)'}; color: ${order.paymentStatus == 'PAID' ? '#10b981' : '#ef4444'};">
                                        ${order.paymentStatus == 'PAID' ? 'Đã Thanh Toán' : 'Chưa Thanh Toán'}
                                    </span>
                                </td>
                                <td style="border: none; padding: 20px 16px; text-align: center; display: flex; justify-content: center; gap: 8px; align-items: center; min-height: 70px; flex-wrap: wrap;">
                                    <a href="${pageContext.request.contextPath}/orders?id=${order.id}" class="btn btn-secondary" style="padding: 6px 12px; font-size: 0.85rem;">
                                        Xem Chi Tiết
                                    </a>
                                    <c:if test="${'ONLINE'.equalsIgnoreCase(order.paymentMethod) && 'UNPAID'.equalsIgnoreCase(order.paymentStatus) && !'CANCELLED'.equalsIgnoreCase(order.orderStatus)}">
                                        <a href="${pageContext.request.contextPath}/checkout/payment?orderId=${order.id}" class="btn btn-primary" style="padding: 6px 12px; font-size: 0.85rem; background: linear-gradient(135deg, #f59e0b, #d97706); border: none; color: #0b0f19; font-weight: 700;">
                                            Thanh Toán Ngay
                                        </a>
                                    </c:if>
                                    <c:if test="${order.orderStatus == 'PENDING'}">
                                        <a href="${pageContext.request.contextPath}/orders/cancel?id=${order.id}" class="btn" style="padding: 6px 12px; font-size: 0.85rem; background-color: rgba(239, 68, 68, 0.1); border: 1px solid rgba(239, 68, 68, 0.2); color: #ef4444;" onclick="return confirm('Bạn có chắc chắn muốn hủy đơn hàng #${order.id} này?')">
                                            Hủy Đơn
                                        </a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div style="text-align: center; padding: 60px 0;">
                    <i class="fa-solid fa-receipt" style="font-size: 3.5rem; color: var(--text-muted); margin-bottom: 16px;"></i>
                    <h3 style="margin-bottom: 8px;">Bạn chưa có đơn hàng nào</h3>
                    <p style="color: var(--text-secondary); margin-bottom: 24px;">Hãy xem danh mục sản phẩm và chọn cho mình bộ quần áo ưng ý.</p>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">Mua sắm ngay</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
