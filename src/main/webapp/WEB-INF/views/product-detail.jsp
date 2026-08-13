<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, poly.java.Entity.*" %>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="container" style="padding-top: 20px;">
    <!-- Thông báo lỗi hoặc thành công -->
    <c:if test="${param.error == 'variant_not_found'}">
        <div class="form-error">Biến thể với màu sắc và kích cỡ đã chọn hiện không tồn tại. Vui lòng chọn lại.</div>
    </c:if>
    <c:if test="${param.error == 'out_of_stock'}">
        <div class="form-error">Sản phẩm này hiện đang hết hàng hoặc số lượng trong kho không đủ.</div>
    </c:if>
    <c:if test="${param.error == 'add_failed'}">
        <div class="form-error">Không thể thêm vào giỏ hàng. Vui lòng thử lại.</div>
    </c:if>

    <div class="detail-container">
        <!-- Gallery Hình Ảnh -->
        <div class="detail-gallery">
            <div class="main-image">
                <c:choose>
                    <c:when test="${not empty product.thumbnail}">
                        <img src="${product.thumbnail.startsWith('http') ? product.thumbnail : pageContext.request.contextPath.concat('/').concat(product.thumbnail)}" alt="${product.productName}">
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/assets/images/placeholder.jpg" alt="${product.productName}">
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Thông Tin Chi Tiết -->
        <div class="detail-info">
            <div>
                <span style="color: var(--accent); font-weight: 700; text-transform: uppercase; letter-spacing: 1px; font-size: 0.9rem;">
                    ${product.brandID.brandName}
                </span>
                <h1 class="detail-title" style="margin-top: 6px; margin-bottom: 12px;">${product.productName}</h1>
            </div>

            <div class="detail-price-box">
                <c:choose>
                    <c:when test="${product.discountPrice != null && product.discountPrice > 0}">
                        <div style="font-size: 2.2rem; font-weight: 800; color: #ef4444;">
                            <fmt:formatNumber value="${product.discountPrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                        </div>
                        <div style="color: var(--text-muted); text-decoration: line-through; font-size: 1.1rem; margin-top: 4px;">
                            Giá gốc: <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="font-size: 2.2rem; font-weight: 800; color: var(--text-primary);">
                            <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <p style="color: var(--text-secondary); border-bottom: 1px solid var(--border-color); padding-bottom: 24px;">
                ${product.description}
            </p>

            <!-- Form Thêm Vào Giỏ Hàng -->
            <form action="${pageContext.request.contextPath}/cart/add" method="POST" style="display: flex; flex-direction: column; gap: 20px;">
                <input type="hidden" name="productId" value="${product.id}">
                
                <!-- Chọn Màu Sắc -->
                <div class="options-group">
                    <span class="options-title">Màu Sắc</span>
                    <div class="options-selector">
                        <c:forEach var="col" items="${colorsSet}" varStatus="loop">
                            <input type="radio" id="col_${col}" name="color" value="${col}" class="option-radio" ${loop.first ? 'checked' : ''} required>
                            <label for="col_${col}" class="option-label">${col}</label>
                        </c:forEach>
                    </div>
                </div>

                <!-- Chọn Size -->
                <div class="options-group">
                    <span class="options-title">Kích thước (Size)</span>
                    <div class="options-selector">
                        <c:forEach var="sz" items="${sizesSet}" varStatus="loop">
                            <input type="radio" id="sz_${sz}" name="size" value="${sz}" class="option-radio" ${loop.first ? 'checked' : ''} required>
                            <label for="sz_${sz}" class="option-label">${sz}</label>
                        </c:forEach>
                    </div>
                </div>

                <!-- Chọn Số Lượng -->
                <div class="options-group">
                    <span class="options-title">Số Lượng</span>
                    <div style="display: flex; gap: 15px; align-items: center;">
                        <input type="number" name="quantity" value="1" min="1" max="10" class="form-control" style="width: 80px; text-align: center;">
                        
                        <c:choose>
                            <c:when test="${sessionScope.currentUser != null}">
                                <button type="submit" class="btn btn-primary" style="flex: 1; padding: 14px;">
                                    <i class="fa-solid fa-cart-plus" style="margin-right: 8px;"></i> THÊM VÀO GIỎ HÀNG
                                </button>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary" style="flex: 1; padding: 14px; text-align: center;">
                                    ĐĂNG NHẬP ĐỂ MUA HÀNG
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
