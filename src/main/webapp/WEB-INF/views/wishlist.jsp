<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="container"
     style="padding-top: 40px; padding-bottom: 60px;">

    <h2 class="section-title">
        Sản Phẩm Yêu Thích
    </h2>

    <p class="section-desc">
        Những sản phẩm bạn đã lưu lại
    </p>


    <c:choose>

        <c:when test="${not empty wishlistItems}">

            <div class="product-grid">

                <c:forEach
                        var="item"
                        items="${wishlistItems}">

                    <div class="product-card">

                        <div class="product-image">

                            <c:choose>

                                <c:when
                                        test="${not empty item.product.imageUrl}">

                                    <img
                                            src="${item.product.imageUrl.startsWith('http')
                                                ? item.product.imageUrl
                                                : pageContext.request.contextPath.concat('/').concat(item.product.imageUrl)}"
                                            alt="${item.product.productName}">

                                </c:when>

                                <c:otherwise>

                                    <img
                                            src="${pageContext.request.contextPath}/assets/images/placeholder.jpg"
                                            alt="${item.product.productName}">

                                </c:otherwise>

                            </c:choose>

                        </div>


                        <div class="product-info">

                            <h3>
                                    ${item.product.productName}
                            </h3>

                            <div class="product-price">

                                <fmt:formatNumber
                                        value="${item.product.price}"
                                        type="currency"
                                        currencySymbol="đ"
                                        maxFractionDigits="0"/>

                            </div>


                            <div style="
                                display: flex;
                                gap: 10px;
                                margin-top: 15px;
                            ">

                                <a
                                        href="${pageContext.request.contextPath}/product-detail?id=${item.product.productId}"
                                        class="btn btn-primary">

                                    Xem sản phẩm

                                </a>


                                <a
                                        href="${pageContext.request.contextPath}/wishlist/remove?id=${item.wishlistId}"
                                        class="btn btn-secondary"
                                        onclick="return confirm('Bạn có chắc muốn xóa sản phẩm này?')">

                                    <i class="fa-solid fa-trash"></i>

                                </a>

                            </div>

                        </div>

                    </div>

                </c:forEach>

            </div>

        </c:when>


        <c:otherwise>

            <div style="
                text-align: center;
                padding: 80px 0;
                background-color: var(--bg-secondary);
                border-radius: var(--radius-md);
                border: 1px solid var(--border-color);
                max-width: 600px;
                margin: 0 auto;
            ">

                <i
                        class="fa-regular fa-heart"
                        style="
                            font-size: 4rem;
                            color: var(--text-muted);
                            margin-bottom: 20px;
                        ">
                </i>

                <h3>
                    Danh sách yêu thích đang trống
                </h3>

                <p style="
                    color: var(--text-secondary);
                    margin-bottom: 30px;
                ">

                    Hãy thêm những sản phẩm bạn yêu thích
                    vào danh sách để xem lại sau.

                </p>

                <a
                        href="${pageContext.request.contextPath}/products"
                        class="btn btn-primary">

                    Mua Sắm Ngay

                </a>

            </div>

        </c:otherwise>

    </c:choose>

</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>