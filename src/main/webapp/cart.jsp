<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="container" style="padding-top: 40px; padding-bottom: 60px;">
    <h2 class="section-title">Giỏ Hàng Của Bạn</h2>
    <p class="section-desc">Kiểm tra lại danh sách quần áo trước khi đặt hàng</p>

    <!-- Thống báo lỗi hoặc thành công -->
    <c:if test="${param.error == 'out_of_stock'}">
        <div class="form-error">Số lượng mặt hàng trong kho không đủ đáp ứng yêu cầu.</div>
    </c:if>
    <c:if test="${param.success == 'update_success'}">
        <div class="form-success">Cập nhật số lượng giỏ hàng thành công!</div>
    </c:if>
    <c:if test="${param.success == 'remove_success'}">
        <div class="form-success">Đã xóa sản phẩm khỏi giỏ hàng.</div>
    </c:if>

    <c:choose>
        <c:when test="${not empty cartItems}">
            <div class="cart-layout">
                <!-- Danh sách sản phẩm bên trái -->
                <div style="overflow-x: auto; background-color: var(--bg-secondary); border-radius: var(--radius-md); border: 1px solid var(--border-color); padding: 20px; height: fit-content;">
                    <table class="cart-table">
                        <thead>
                            <tr>
                                <th style="width: 45%;">Sản phẩm</th>
                                <th style="width: 15%;">Đơn giá</th>
                                <th style="width: 20%;">Số lượng</th>
                                <th style="width: 15%;">Thành tiền</th>
                                <th style="width: 5%;"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${cartItems}">
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
                                                <div class="cart-item-name">
                                                    <a href="${pageContext.request.contextPath}/product-detail?id=${item.productId}">${item.productName}</a>
                                                </div>
                                                <div class="cart-item-variant">
                                                    Phân loại: ${item.color} / Size ${item.size}
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <span style="font-weight: 500;">
                                            <fmt:formatNumber value="${item.actualPrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                        </span>
                                    </td>
                                    <td>
                                        <!-- Form cập nhật số lượng -->
                                        <form action="${pageContext.request.contextPath}/cart/update" method="POST" style="display: inline;">
                                            <input type="hidden" name="cartItemId" value="${item.id}">
                                            <div class="quantity-control">
                                                <input type="number" name="quantity" value="${item.quantity}" min="1" max="10" class="qty-input form-control" style="border: none; padding: 4px;" onchange="this.form.submit()">
                                            </div>
                                        </form>
                                    </td>
                                    <td>
                                        <span style="font-weight: 700; color: var(--accent);">
                                            <fmt:formatNumber value="${item.totalAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                        </span>
                                    </td>
                                    <td>
                                        <!-- Nút xóa mặt hàng -->
                                        <a href="${pageContext.request.contextPath}/cart/remove?id=${item.id}" style="color: var(--text-muted); font-size: 1.1rem;" onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng?')">
                                            <i class="fa-solid fa-trash-can"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Tóm tắt đơn hàng bên phải -->
                <div class="summary-card">
                    <h3 style="font-size: 1.3rem; font-weight: 700; border-bottom: 1px solid var(--border-color); padding-bottom: 16px; margin-bottom: 20px;">
                        Tóm tắt đơn hàng
                    </h3>
                    
                    <div class="summary-row">
                        <span style="color: var(--text-secondary);">Tạm tính:</span>
                        <span style="font-weight: 600;">
                            <fmt:formatNumber value="${subTotal}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                        </span>
                    </div>
                    
                    <div class="summary-row">
                        <span style="color: var(--text-secondary);">Phí vận chuyển:</span>
                        <span style="font-weight: 600; color: #10b981;">Miễn phí</span>
                    </div>

                    <div class="summary-row total">
                        <span>Tổng tiền:</span>
                        <span>
                            <fmt:formatNumber value="${subTotal}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                        </span>
                    </div>

                    <div style="margin-top: 30px; display: flex; flex-direction: column; gap: 12px;">
                        <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary" style="width: 100%; padding: 14px; text-align: center;">
                            TIẾN HÀNH THANH TOÁN
                        </a>
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-secondary" style="width: 100%; text-align: center; padding: 14px;">
                            TIẾP TỤC MUA SẮM
                        </a>
                    </div>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <!-- Giỏ hàng trống -->
            <div style="text-align: center; padding: 80px 0; background-color: var(--bg-secondary); border-radius: var(--radius-md); border: 1px solid var(--border-color); max-width: 600px; margin: 0 auto;">
                <i class="fa-solid fa-cart-shopping" style="font-size: 4rem; color: var(--text-muted); margin-bottom: 20px;"></i>
                <h3 style="margin-bottom: 10px;">Giỏ hàng của bạn đang trống</h3>
                <p style="color: var(--text-secondary); margin-bottom: 30px;">Hãy lấp đầy giỏ hàng của bạn bằng những bộ quần áo thời thượng nhất.</p>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">Mua Sắm Ngay</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
