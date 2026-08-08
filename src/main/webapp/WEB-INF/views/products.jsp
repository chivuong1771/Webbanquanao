<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="container" style="margin-top: 30px; margin-bottom: 80px;">
    <div style="display: flex; gap: 30px;">

        <!-- Sidebar Lọc Danh Mục -->
        <aside style="width: 250px; flex-shrink: 0;">
            <h3 class="section-title" style="font-size: 1.2rem; margin-bottom: 15px;">Danh Mục</h3>
            <ul style="list-style: none; padding: 0;">
                <li style="margin-bottom: 10px;">
                    <a href="${pageContext.request.contextPath}/products"
                       style="text-decoration: none; color: ${empty selectedCategoryId ? 'var(--accent)' : 'var(--text-primary)'}; font-weight: ${empty selectedCategoryId ? '700' : 'normal'};">
                        Tất cả sản phẩm
                    </a>
                </li>
                <c:forEach var="cat" items="${categories}">
                    <li style="margin-bottom: 10px;">
                        <a href="${pageContext.request.contextPath}/products?categoryId=${cat.id}"
                           style="text-decoration: none; color: ${selectedCategoryId == cat.id ? 'var(--accent)' : 'var(--text-primary)'}; font-weight: ${selectedCategoryId == cat.id ? '700' : 'normal'};">
                                ${cat.categoryName}
                        </a>
                    </li>
                </c:forEach>
            </ul>
        </aside>

        <!-- Danh sách sản phẩm -->
        <main style="flex: 1;">
            <h2 class="section-title" style="margin-bottom: 20px;">Sản Phẩm</h2>

            <c:choose>
                <c:when test="${not empty products}">
                    <div class="grid-products">
                        <c:forEach var="prod" items="${products}">
                            <a href="${pageContext.request.contextPath}/product-detail?id=${prod.id}" class="product-card" style="text-decoration: none; color: inherit; display: block; cursor: pointer;">
                                <c:if test="${prod.discountPrice != null && prod.discountPrice > 0}">
                                    <span class="product-badge">SALE</span>
                                </c:if>
                                <div class="product-image-wrapper">
                                    <c:choose>
                                        <c:when test="${not empty prod.thumbnail}">
                                            <img src="${prod.thumbnail.startsWith('http') ? prod.thumbnail : pageContext.request.contextPath.concat('/').concat(prod.thumbnail)}" alt="${prod.productName}">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/assets/images/placeholder.jpg" alt="${prod.productName}">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="product-info">
                                    <div class="product-brand">${prod.brandID.brandName}</div>
                                    <h4 class="product-name" style="margin: 0;">${prod.productName}</h4>
                                    <div class="product-price-wrapper">
                                        <c:choose>
                                            <c:when test="${prod.discountPrice != null && prod.discountPrice > 0}">
                                                <span class="product-price discounted">
                                                    <fmt:formatNumber value="${prod.discountPrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                </span>
                                                <span class="product-old-price">
                                                    <fmt:formatNumber value="${prod.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="product-price">
                                                    <fmt:formatNumber value="${prod.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </a>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <p style="text-align: center; color: var(--text-secondary); margin-top: 50px;">Không tìm thấy sản phẩm nào trong danh mục này.</p>
                </c:otherwise>
            </c:choose>
        </main>

    </div>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>