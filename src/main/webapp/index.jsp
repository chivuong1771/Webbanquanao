<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="/WEB-INF/views/header.jsp" %>

<!-- Banner Slider / Hero Section -->
<section class="container">
    <div class="hero-slider">
        <c:choose>
            <c:when test="${not empty banners}">
                <c:forEach var="banner" items="${banners}" varStatus="status">
                    <div class="slide ${status.first ? 'active' : ''}">
                        <div class="slide-content">
                            <span class="slide-tag">ƯU ĐÃI ĐỘC QUYỀN</span>
                            <h2 class="slide-title">${banner.title}</h2>
                            <a href="${pageContext.request.contextPath}/${banner.link}" class="btn-banner-pill">
                                MUA NGAY <i class="fa-solid fa-arrow-right" style="margin-left: 8px;"></i>
                            </a>
                        </div>
                        <div class="slide-graphic">
                            <svg width="340" height="340" viewBox="0 0 340 340" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <circle cx="170" cy="170" r="150" stroke="#d4af37" stroke-width="1.5" stroke-dasharray="4 4"/>
                                <circle cx="170" cy="170" r="120" stroke="rgba(255,255,255,0.12)" stroke-width="1"/>
                                <polygon points="170,50 66,230 274,230" stroke="rgba(255,255,255,0.18)" stroke-width="1" fill="none"/>
                                <circle cx="318" cy="150" r="4" fill="#d4af37"/>
                                <circle cx="90" cy="270" r="4" fill="#3b82f6"/>
                            </svg>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <!-- Fallback slide matching exact screenshot -->
                <div class="slide active">
                    <div class="slide-content">
                        <span class="slide-tag">ƯU ĐÃI ĐỘC QUYỀN</span>
                        <h2 class="slide-title">Bộ Sưu Tập Mùa Hè<br>2026</h2>
                        <a href="${pageContext.request.contextPath}/products" class="btn-banner-pill">
                            MUA NGAY <i class="fa-solid fa-arrow-right" style="margin-left: 8px;"></i>
                        </a>
                    </div>
                    <div class="slide-graphic">
                        <svg width="340" height="340" viewBox="0 0 340 340" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <circle cx="170" cy="170" r="150" stroke="#d4af37" stroke-width="1.5" stroke-dasharray="4 4"/>
                            <circle cx="170" cy="170" r="120" stroke="rgba(255,255,255,0.12)" stroke-width="1"/>
                            <polygon points="170,50 66,230 274,230" stroke="rgba(255,255,255,0.18)" stroke-width="1" fill="none"/>
                            <circle cx="318" cy="150" r="4" fill="#d4af37"/>
                            <circle cx="90" cy="270" r="4" fill="#3b82f6"/>
                        </svg>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<!-- Category Grid Section -->
<section class="container" style="margin-bottom: 60px;">
    <h3 class="section-title">Danh Mục Nổi Bật</h3>
    <p class="section-desc">Khám phá các dòng sản phẩm thời trang cao cấp phù hợp với phong cách của bạn</p>

    <div class="grid-categories">
        <c:forEach var="cat" items="${applicationScope.categories}">
            <a href="${pageContext.request.contextPath}/products?categoryId=${cat.id}" class="category-card">
                <div class="category-icon">
                    <c:choose>
                        <c:when test="${cat.categoryName.contains('Áo Nam') || cat.categoryName.contains('Áo Nữ') || cat.categoryName.contains('Áo')}">
                            <i class="fa-solid fa-shirt"></i>
                        </c:when>
                        <c:when test="${cat.categoryName.contains('Quần')}">
                            <i class="fa-solid fa-socks"></i>
                        </c:when>
                        <c:when test="${cat.categoryName.contains('Phụ Kiện') || cat.categoryName.contains('Phụ kiện')}">
                            <i class="fa-solid fa-glasses"></i>
                        </c:when>
                        <c:otherwise>
                            <i class="fa-solid fa-gem"></i>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="category-title">${cat.categoryName}</div>
            </a>
        </c:forEach>
    </div>
</section>

<!-- Discount Products Section -->
<c:if test="${not empty discountProducts}">
    <section class="container">
        <h3 class="section-title">Khuyến Mãi Đặc Biệt</h3>
        <p class="section-desc">Cơ hội mua sắm thời trang hàng hiệu giá tốt nhất trong tuần</p>

        <div class="grid-products">
            <c:forEach var="prod" items="${discountProducts}">
                <a href="${pageContext.request.contextPath}/product-detail?id=${prod.id}" class="product-card" style="text-decoration: none; color: inherit; display: block; cursor: pointer;">
                    <span class="product-badge">SALE</span>
                    <div class="product-image-wrapper">
                        <img src="${prod.imageUrl}" onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=500&auto=format&fit=crop';" alt="${prod.productName}">
                    </div>
                    <div class="product-info">
                        <div class="product-brand">${prod.brandID.brandName}</div>
                        <h4 class="product-name" style="margin: 0;">${prod.productName}</h4>
                        <div class="product-price-wrapper">
                            <span class="product-price discounted">
                                <fmt:formatNumber value="${prod.discountPrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                            </span>
                            <span class="product-old-price">
                                <fmt:formatNumber value="${prod.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                            </span>
                        </div>
                    </div>
                </a>
            </c:forEach>
        </div>
    </section>
</c:if>

<!-- New Arrivals Section -->
<section class="container">
    <h3 class="section-title">Hàng Mới Về</h3>
    <p class="section-desc">Bộ sưu tập thời trang độc quyền vừa ra mắt của thương hiệu</p>

    <div class="grid-products">
        <c:forEach var="prod" items="${newArrivals}">
            <a href="${pageContext.request.contextPath}/product-detail?id=${prod.id}" class="product-card" style="text-decoration: none; color: inherit; display: block; cursor: pointer;">
                <span class="product-badge" style="background-color: #3b82f6; color: #fff;">NEW</span>
                <div class="product-image-wrapper">
                    <img src="${prod.imageUrl}" onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=500&auto=format&fit=crop';" alt="${prod.productName}">
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
</section>

<!-- Best Sellers Section -->
<section class="container" style="margin-bottom: 80px;">
    <h3 class="section-title">Bán Chạy Nhất</h3>
    <p class="section-desc">Những thiết kế được yêu thích và lựa chọn nhiều nhất bởi khách hàng</p>

    <div class="grid-products">
        <c:forEach var="prod" items="${bestSellers}">
            <a href="${pageContext.request.contextPath}/product-detail?id=${prod.id}" class="product-card" style="text-decoration: none; color: inherit; display: block; cursor: pointer;">
                <span class="product-badge" style="background-color: var(--accent); color: #0b0f19;">HOT</span>
                <div class="product-image-wrapper">
                    <img src="${prod.imageUrl}" onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=500&auto=format&fit=crop';" alt="${prod.productName}">
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
</section>

<!-- Slider Script -->
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const slides = document.querySelectorAll(".hero-slider .slide");
        if (slides.length > 0) {
            slides[0].classList.add("active");
            if (slides.length > 1) {
                let currentSlide = 0;
                setInterval(() => {
                    slides[currentSlide].classList.remove("active");
                    currentSlide = (currentSlide + 1) % slides.length;
                    slides[currentSlide].classList.add("active");
                }, 5000);
            }
        }
    });
</script>

<%@ include file="/WEB-INF/views/footer.jsp" %>