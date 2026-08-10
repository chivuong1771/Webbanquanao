<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="container" style="padding-top: 40px; padding-bottom: 60px;">
    <h2 class="section-title">Thanh Toán Đơn Hàng</h2>
    <p class="section-desc">Vui lòng điền địa chỉ giao hàng và lựa chọn phương thức thanh toán</p>

    <!-- Thông báo lỗi -->
    <c:if test="${param.error == 'missing_info'}">
        <div class="form-error">Vui lòng nhập đầy đủ họ tên, số điện thoại và địa chỉ giao hàng.</div>
    </c:if>
    <c:if test="${param.error == 'checkout_failed'}">
        <div class="form-error">Quá trình đặt hàng thất bại do lỗi hệ thống hoặc biến thể đã hết hàng. Vui lòng thử lại.</div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="form-error">${errorMessage}</div>
    </c:if>

    <div class="cart-layout">
        <!-- Form điền thông tin bên trái -->
        <div style="background-color: var(--bg-secondary); border-radius: var(--radius-md); border: 1px solid var(--border-color); padding: 30px;">
            <h3 style="font-size: 1.3rem; font-weight: 700; border-bottom: 1px solid var(--border-color); padding-bottom: 12px; margin-bottom: 24px;">
                Thông tin giao hàng
            </h3>
            
            <form id="checkoutForm" action="${pageContext.request.contextPath}/checkout/submit" method="POST">
                <!-- Giữ mã giảm giá ẩn nếu có áp dụng -->
                <input type="hidden" name="discountCode" value="${discountCode != null ? discountCode.code : ''}">

                <div class="form-group">
                    <label class="form-label">Họ và tên người nhận (*)</label>
                    <input type="text" name="fullname" class="form-control" placeholder="Nhập tên người nhận hàng" value="${sessionScope.currentUser.fullname}" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Số điện thoại (*)</label>
                    <input type="text" name="phone" class="form-control" placeholder="Nhập số điện thoại liên hệ" value="${sessionScope.currentUser.phone}" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Địa chỉ nhận hàng (*)</label>
                    <textarea name="address" rows="3" class="form-control" placeholder="Số nhà, tên đường, phường/xã, quận/huyện, tỉnh/thành phố..." style="resize: none;" required>${sessionScope.currentUser.address}</textarea>
                </div>

                <div class="form-group">
                    <label class="form-label">Ghi chú đơn hàng (Tùy chọn)</label>
                    <textarea name="note" rows="2" class="form-control" placeholder="Ví dụ: Giao hàng giờ hành chính..." style="resize: none;"></textarea>
                </div>

                <h3 style="font-size: 1.3rem; font-weight: 700; border-bottom: 1px solid var(--border-color); padding-bottom: 12px; margin-top: 40px; margin-bottom: 24px;">
                    Phương thức thanh toán
                </h3>

                <div style="display: flex; flex-direction: column; gap: 12px;">
                    <div style="display: flex; align-items: center; gap: 12px; padding: 16px; background-color: var(--bg-primary); border: 2px solid #10b981; border-radius: var(--radius-sm); cursor: pointer;">
                        <input type="radio" id="pay_payos" name="paymentMethod" value="PAYOS" checked style="cursor: pointer;">
                        <label for="pay_payos" style="cursor: pointer; font-weight: 700; color: #10b981;">
                            <i class="fa-solid fa-qrcode" style="margin-right: 8px; color: #10b981;"></i> Thanh toán qua PayOS (Quét mã QR MB Bank tự động gạch nợ)
                        </label>
                    </div>

                    <div style="display: flex; align-items: center; gap: 12px; padding: 16px; background-color: var(--bg-primary); border: 1px solid var(--border-color); border-radius: var(--radius-sm); cursor: pointer;">
                        <input type="radio" id="pay_cod" name="paymentMethod" value="COD" style="cursor: pointer;">
                        <label for="pay_cod" style="cursor: pointer; font-weight: 500;">
                            <i class="fa-solid fa-truck-ramp-box" style="margin-right: 8px; color: var(--accent);"></i> Thanh toán khi nhận hàng (COD)
                        </label>
                    </div>

                    <div style="display: flex; align-items: center; gap: 12px; padding: 16px; background-color: var(--bg-primary); border: 1px solid var(--border-color); border-radius: var(--radius-sm); cursor: pointer;">
                        <input type="radio" id="pay_online" name="paymentMethod" value="ONLINE" style="cursor: pointer;">
                        <label for="pay_online" style="cursor: pointer; font-weight: 500;">
                            <i class="fa-solid fa-credit-card" style="margin-right: 8px; color: var(--accent);"></i> Thanh toán trực tuyến (Chuyển khoản Ngân Hàng / Ví điện tử khác)
                        </label>
                    </div>
                </div>
            </form>
        </div>

        <!-- Tóm tắt đơn & Áp mã giảm giá bên phải -->
        <div>
            <!-- Bảng mã giảm giá -->
            <div style="background-color: var(--bg-secondary); border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 24px; margin-bottom: 24px;">
                <h4 style="font-weight: 700; margin-bottom: 12px;">Mã Giảm Giá</h4>
                
                <form action="${pageContext.request.contextPath}/checkout" method="GET" style="display: flex; gap: 10px;">
                    <input type="text" name="code" placeholder="Nhập mã giảm giá..." class="form-control" style="flex: 1; padding: 8px 12px; text-transform: uppercase;" value="${discountCode != null ? discountCode.code : ''}">
                    <button type="submit" class="btn btn-secondary" style="padding: 8px 16px; font-size: 0.9rem;">Áp Dụng</button>
                </form>
                
                <c:if test="${discountCode != null}">
                    <div style="margin-top: 12px; color: #10b981; font-size: 0.9rem; font-weight: 500;">
                        <i class="fa-solid fa-circle-check"></i> Đã áp dụng mã <strong>${discountCode.code}</strong> (${discountCode.description})
                    </div>
                </c:if>
            </div>

            <!-- Tóm tắt sản phẩm & Tổng tiền -->
            <div class="summary-card">
                <h3 style="font-size: 1.2rem; font-weight: 700; border-bottom: 1px solid var(--border-color); padding-bottom: 16px; margin-bottom: 20px;">
                    Đơn hàng của bạn
                </h3>
                
                <!-- Danh sách sản phẩm mua -->
                <div style="max-height: 240px; overflow-y: auto; margin-bottom: 20px; display: flex; flex-direction: column; gap: 12px; padding-right: 8px;">
                    <c:forEach var="item" items="${cartItems}">
                        <div style="display: flex; justify-content: space-between; align-items: center; font-size: 0.95rem; border-bottom: 1px solid rgba(255,255,255,0.03); padding-bottom: 8px;">
                            <span style="max-width: 70%; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                                <strong>${item.quantity}x</strong> ${item.productName} (${item.color}/${item.size})
                            </span>
                            <span style="font-weight: 500;">
                                <fmt:formatNumber value="${item.totalAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                            </span>
                        </div>
                    </c:forEach>
                </div>

                <div class="summary-row">
                    <span style="color: var(--text-secondary);">Tạm tính:</span>
                    <span style="font-weight: 600;">
                        <fmt:formatNumber value="${subTotal}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                    </span>
                </div>

                <c:if test="${discountAmount > 0}">
                    <div class="summary-row">
                        <span style="color: var(--text-secondary);">Giảm giá:</span>
                        <span style="font-weight: 600; color: #ef4444;">
                            -<fmt:formatNumber value="${discountAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                        </span>
                    </div>
                </c:if>

                <div class="summary-row">
                    <span style="color: var(--text-secondary);">Phí vận chuyển:</span>
                    <span style="font-weight: 600; color: #10b981;">Miễn phí</span>
                </div>

                <div class="summary-row total">
                    <span>Tổng thanh toán:</span>
                    <span>
                        <fmt:formatNumber value="${grandTotal}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                    </span>
                </div>

                <button type="submit" form="checkoutForm" class="btn btn-primary" style="width: 100%; padding: 14px; margin-top: 30px; font-size: 1.05rem;">
                    XÁC NHẬN ĐẶT HÀNG
                </button>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
