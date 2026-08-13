<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="java.util.*, poly.java.Entity.*" %>
<%@ include file="/WEB-INF/views/header.jsp" %>

<%
    Product product = (Product) request.getAttribute("product");
    Set<String> colors = new LinkedHashSet<>();
    Set<String> sizes = new LinkedHashSet<>();
    if (product != null && product.getProductVariants() != null) {
        for (ProductVariant d : product.getProductVariants()) {
            if (d.getColorID() != null && d.getColorID().getColorName() != null) {
                colors.add(d.getColorID().getColorName());
            }
            if (d.getSizeID() != null && d.getSizeID().getSizeName() != null) {
                sizes.add(d.getSizeID().getSizeName());
            }
        }
    }
    request.setAttribute("colorsSet", colors);
    request.setAttribute("sizesSet", sizes);
%>

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
            
            <div style="display: flex; gap: 10px; overflow-x: auto;">
                <c:forEach var="img" items="${product.productImages}">
                    <div style="width: 80px; height: 100px; border-radius: var(--radius-sm); overflow: hidden; border: 1px solid var(--border-color); cursor: pointer; flex-shrink: 0;">
                        <img src="${img.imageUrl.startsWith('http') ? img.imageUrl : pageContext.request.contextPath.concat('/').concat(img.imageUrl)}" style="width: 100%; height: 100%; object-fit: cover;">
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Thông Tin Chi Tiết -->
        <div class="detail-info">
            <div>
                <span style="color: var(--accent); font-weight: 700; text-transform: uppercase; letter-spacing: 1px; font-size: 0.9rem;">
                    ${product.brandID.brandName}
                </span>
                <h1 class="detail-title" style="margin-top: 6px; margin-bottom: 12px;">${product.productName}</h1>
                <div style="display: flex; align-items: center; gap: 15px;">
                    <span style="color: #f59e0b; font-size: 1.1rem;">
                        <c:forEach begin="1" end="5" var="i">
                            <i class="${i <= avgRating ? 'fa-solid fa-star' : 'fa-regular fa-star'}"></i>
                        </c:forEach>
                    </span>
                    <span style="color: var(--text-secondary); font-size: 0.9rem;">(${reviews.size()} đánh giá)</span>
                </div>
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

    <!-- Phần Đánh Giá (Reviews) -->
    <section style="margin-top: 60px; border-top: 1px solid var(--border-color); padding-top: 40px; margin-bottom: 80px;">
        <h3 class="section-title">Đánh Giá Từ Khách Hàng</h3>
        <p class="section-desc">Ý kiến phản hồi từ những người đã mua sản phẩm này</p>

        <!-- Form Viết Nhận Xét (Nếu đã đăng nhập) -->
        <c:if test="${sessionScope.currentUser != null}">
            <div style="background-color: var(--bg-secondary); border: 1px solid var(--border-color); padding: 30px; border-radius: var(--radius-md); margin-bottom: 40px;">
                <h4 style="margin-bottom: 16px; font-weight: 700;">Viết nhận xét của bạn</h4>
                
                <form action="${pageContext.request.contextPath}/review/add" method="POST">
                    <input type="hidden" name="productId" value="${product.id}">
                    <div class="form-group" style="margin-bottom: 16px;">
                        <label class="form-label">Chọn số sao đánh giá</label>
                        <select name="rating" class="form-control" style="width: 150px; background-color: var(--bg-primary); border: 1px solid var(--border-color);">
                            <option value="5">5 Sao (Rất tốt)</option>
                            <option value="4">4 Sao (Tốt)</option>
                            <option value="3">3 Sao (Bình thường)</option>
                            <option value="2">2 Sao (Kém)</option>
                            <option value="1">1 Sao (Rất kém)</option>
                        </select>
                    </div>
                    <div class="form-group" style="margin-bottom: 20px;">
                        <label class="form-label">Nội dung nhận xét</label>
                        <textarea name="comment" rows="4" placeholder="Nhập cảm nhận của bạn về sản phẩm (vải, size, màu sắc...)" class="form-control" style="width: 100%; resize: none;" required></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary" style="padding: 10px 24px;">Gửi Đánh Giá</button>
                </form>
            </div>
        </c:if>

        <!-- Danh sách nhận xét -->
        <div style="display: flex; flex-direction: column; gap: 20px;">
            <c:choose>
                <c:when test="${not empty reviews}">
                    <c:forEach var="rev" items="${reviews}">
                        <div class="review-bubble">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                                <span style="font-weight: 600; font-size: 1.05rem;">
                                    <i class="fa-regular fa-user" style="margin-right: 6px;"></i> ${rev.fullname}
                                </span>
                                <span style="color: #f59e0b; font-size: 0.9rem;">
                                    <c:forEach begin="1" end="5" var="i">
                                        <i class="${i <= rev.rating ? 'fa-solid fa-star' : 'fa-regular fa-star'}"></i>
                                    </c:forEach>
                                </span>
                            </div>
                            <p style="color: var(--text-secondary); font-size: 0.95rem; margin-bottom: 6px;">${rev.comment}</p>
                            <span style="color: var(--text-muted); font-size: 0.8rem;">
                                Đăng ngày: <fmt:formatDate value="${rev.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                            </span>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p style="color: var(--text-secondary); font-style: italic;">Chưa có đánh giá nào cho sản phẩm này. Hãy là người đầu tiên đánh giá!</p>
                </c:otherwise>
            </c:choose>
        </div>
    </section>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
