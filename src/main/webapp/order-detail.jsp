<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="container" style="padding-top: 40px; padding-bottom: 60px;">
    <div style="display: flex; align-items: center; gap: 15px; margin-bottom: 12px;">
        <a href="${pageContext.request.contextPath}/orders" class="btn btn-secondary" style="padding: 8px 16px; font-size: 0.9rem;">
            <i class="fa-solid fa-arrow-left" style="margin-right: 6px;"></i> Quay lại
        </a>
        <h2 style="font-size: 1.8rem; font-weight: 800; margin: 0;">Chi Tiết Đơn Hàng #${order.id}</h2>
    </div>
    
    <p class="section-desc" style="margin-bottom: 30px;">
        Đặt ngày <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
    </p>

    <div class="cart-layout" style="grid-template-columns: 2fr 1fr;">
        <!-- Danh sách sản phẩm đã mua -->
        <div style="background-color: var(--bg-secondary); border-radius: var(--radius-md); border: 1px solid var(--border-color); padding: 24px; height: fit-content;">
            <h3 style="font-size: 1.25rem; font-weight: 700; border-bottom: 1px solid var(--border-color); padding-bottom: 12px; margin-bottom: 20px;">
                Danh sách sản phẩm mua
            </h3>
            
            <table class="cart-table" style="width: 100%;">
                <thead>
                    <tr>
                        <th>Sản phẩm</th>
                        <th style="text-align: right;">Đơn giá</th>
                        <th style="text-align: center;">Số lượng</th>
                        <th style="text-align: right;">Thành tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${order.orderDetails}">
                        <tr>
                            <td>
                                <div class="cart-item-info">
                                     <div class="cart-item-image">
                                         <c:choose>
                                             <c:when test="${not empty item.imageUrl}">
                                                 <img src="${item.imageUrl.startsWith('http') ? item.imageUrl : pageContext.request.contextPath.concat('/').concat(item.imageUrl)}" alt="${item.productName}">
                                             </c:when>
                                             <c:otherwise>
                                                 <img src="${pageContext.request.contextPath}/assets/images/placeholder.jpg" alt="${item.productName}">
                                             </c:otherwise>
                                         </c:choose>
                                     </div>
                                    <div>
                                        <div class="cart-item-name">${item.productName}</div>
                                        <div class="cart-item-variant">Phân loại: ${item.color} / Size ${item.size}</div>
                                    </div>
                                </div>
                            </td>
                            <td style="text-align: right; font-weight: 500;">
                                <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                            </td>
                            <td style="text-align: center;">${item.quantity}</td>
                            <td style="text-align: right; font-weight: 700; color: var(--accent);">
                                <fmt:formatNumber value="${item.amount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <!-- Dòng tổng tiền -->
            <div style="display: flex; justify-content: flex-end; margin-top: 24px; border-top: 1px solid var(--border-color); padding-top: 20px; font-size: 1.2rem;">
                <div>
                    <span>Tổng tiền thanh toán: </span>
                    <strong style="color: var(--accent); font-size: 1.5rem; margin-left: 12px;">
                        <fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                    </strong>
                </div>
            </div>
        </div>

        <!-- Thông tin giao hàng & Trạng thái -->
        <div style="display: flex; flex-direction: column; gap: 24px;">
            <!-- Trạng thái đơn -->
            <div class="summary-card" style="padding: 24px;">
                <h4 style="font-weight: 700; border-bottom: 1px solid var(--border-color); padding-bottom: 12px; margin-bottom: 16px;">
                    Trạng thái đơn hàng
                </h4>
                
                <div style="margin-bottom: 16px;">
                    <div style="color: var(--text-secondary); font-size: 0.85rem; margin-bottom: 6px;">Trạng thái vận chuyển:</div>
                    <span class="badge-status status-${order.orderStatus.toLowerCase()}" style="font-size: 0.9rem;">
                        <c:choose>
                            <c:when test="${order.orderStatus == 'PENDING'}">Chờ xác nhận</c:when>
                            <c:when test="${order.orderStatus == 'CONFIRMED'}">Đã xác nhận</c:when>
                            <c:when test="${order.orderStatus == 'SHIPPING'}">Đang giao</c:when>
                            <c:when test="${order.orderStatus == 'DELIVERED'}">Đã giao hàng</c:when>
                            <c:when test="${order.orderStatus == 'CANCELLED'}">Đã hủy đơn</c:when>
                            <c:otherwise>${order.orderStatus}</c:otherwise>
                        </c:choose>
                    </span>
                </div>

                <div>
                    <div style="color: var(--text-secondary); font-size: 0.85rem; margin-bottom: 6px;">Trạng thái thanh toán:</div>
                    <div style="display: flex; flex-direction: column; gap: 8px; align-items: flex-start;">
                        <span class="badge-status" style="font-size: 0.9rem; background-color: ${order.paymentStatus == 'PAID' ? 'rgba(16, 185, 129, 0.15)' : 'rgba(239, 68, 68, 0.15)'}; color: ${order.paymentStatus == 'PAID' ? '#10b981' : '#ef4444'};">
                            ${order.paymentStatus == 'PAID' ? 'Đã Thanh Toán' : 'Chưa Thanh Toán'}
                        </span>
                        <c:if test="${'ONLINE'.equalsIgnoreCase(order.paymentMethod) && 'UNPAID'.equalsIgnoreCase(order.paymentStatus) && !'CANCELLED'.equalsIgnoreCase(order.orderStatus)}">
                            <a href="${pageContext.request.contextPath}/checkout/payment?orderId=${order.id}" class="btn btn-primary" style="padding: 8px 16px; font-size: 0.85rem; background: linear-gradient(135deg, #f59e0b, #d97706); border: none; color: #0b0f19; font-weight: 700; width: 100%; text-align: center; margin-top: 6px; text-decoration: none;">
                                <i class="fa-solid fa-credit-card" style="margin-right: 6px;"></i> Thanh Toán Ngay
                            </a>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Địa chỉ giao hàng -->
            <div class="summary-card" style="padding: 24px;">
                <h4 style="font-weight: 700; border-bottom: 1px solid var(--border-color); padding-bottom: 12px; margin-bottom: 16px;">
                    Thông tin giao hàng
                </h4>
                
                <div style="display: flex; flex-direction: column; gap: 12px; font-size: 0.95rem;">
                    <div>
                        <strong style="color: var(--text-secondary);">Họ tên nhận:</strong>
                        <div style="margin-top: 4px;">${order.fullname}</div>
                    </div>
                    
                    <div>
                        <strong style="color: var(--text-secondary);">Số điện thoại:</strong>
                        <div style="margin-top: 4px;">${order.phone}</div>
                    </div>
                    
                    <div>
                        <strong style="color: var(--text-secondary);">Địa chỉ nhận:</strong>
                        <div style="margin-top: 4px;">${order.address}</div>
                    </div>

                    <c:if test="${not empty order.note}">
                        <div>
                            <strong style="color: var(--text-secondary);">Ghi chú:</strong>
                            <div style="margin-top: 4px; font-style: italic;">"${order.note}"</div>
                        </div>
                    </c:if>

                    <div>
                        <strong style="color: var(--text-secondary);">Hình thức thanh toán:</strong>
                        <div style="margin-top: 4px;">
                            ${'COD'.equalsIgnoreCase(order.paymentMethod) ? 'Thanh toán COD khi nhận hàng' : 'Thanh toán trực tuyến'}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
