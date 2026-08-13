<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="container" style="margin-top: 30px; margin-bottom: 80px;">
    <h2 class="section-title" style="margin-bottom: 20px;">LAB 5 - BÀI 1: TÌM KIẾM KẾT HỢP PHÂN TRANG THỨC UỐNG / SẢN PHẨM</h2>

    <!-- Form Tìm kiếm Sản phẩm -->
    <form action="${pageContext.request.contextPath}/admin/products" method="GET" style="background-color: var(--bg-secondary); padding: 20px; border-radius: 8px; border: 1px solid var(--border-color); margin-bottom: 30px; display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)) 120px; gap: 15px; align-items: end;">
        <div>
            <label class="form-label">Tên sản phẩm / thức uống</label>
            <input type="text" name="keyword" value="${keyword}" placeholder="Nhập tên sản phẩm..." class="form-control">
        </div>
        <div>
            <label class="form-label">Loại đồ uống / Danh mục</label>
            <select name="categoryId" class="form-control">
                <option value="">-- Tất cả danh mục --</option>
                <c:forEach var="cat" items="${categories}">
                    <option value="${cat.id}" ${categoryId == cat.id ? 'selected' : ''}>${cat.categoryName}</option>
                </c:forEach>
            </select>
        </div>
        <div>
            <label class="form-label">Trạng thái</label>
            <select name="status" class="form-control">
                <option value="">-- Tất cả trạng thái --</option>
                <option value="true" ${status == 'true' ? 'selected' : ''}>Đang kinh doanh</option>
                <option value="false" ${status == 'false' ? 'selected' : ''}>Ngừng kinh doanh</option>
            </select>
        </div>
        <div>
            <button type="submit" class="btn btn-primary" style="width: 100%; height: 42px;">
                <i class="fa-solid fa-magnifying-glass"></i> Tìm Kiếm
            </button>
        </div>
    </form>

    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
        <span style="color: var(--text-secondary);">Tổng số sản phẩm tìm thấy: <strong>${totalProducts}</strong> (Mỗi trang 10 sản phẩm)</span>
    </div>

    <!-- Bảng Danh Sách Sản Phẩm -->
    <div style="overflow-x: auto; background-color: var(--bg-secondary); border-radius: 8px; border: 1px solid var(--border-color);">
        <table style="width: 100%; border-collapse: collapse; text-align: left;">
            <thead>
                <tr style="border-bottom: 1px solid var(--border-color); background-color: rgba(255,255,255,0.05);">
                    <th style="padding: 14px;">ID</th>
                    <th style="padding: 14px;">Hình Ảnh</th>
                    <th style="padding: 14px;">Tên Sản Phẩm</th>
                    <th style="padding: 14px;">Danh Mục</th>
                    <th style="padding: 14px;">Thương Hiệu</th>
                    <th style="padding: 14px;">Giá Bán</th>
                    <th style="padding: 14px;">Trạng Thái</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty products}">
                        <c:forEach var="p" items="${products}">
                            <tr style="border-bottom: 1px solid var(--border-color);">
                                <td style="padding: 14px;">#${p.id}</td>
                                <td style="padding: 14px;">
                                    <c:choose>
                                        <c:when test="${not empty p.thumbnail}">
                                            <img src="${p.thumbnail.startsWith('http') ? p.thumbnail : pageContext.request.contextPath.concat('/').concat(p.thumbnail)}" style="width: 50px; height: 60px; object-fit: cover; border-radius: 4px;">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/assets/images/placeholder.jpg" style="width: 50px; height: 60px; object-fit: cover; border-radius: 4px;">
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="padding: 14px; font-weight: 600;">${p.productName}</td>
                                <td style="padding: 14px;">${p.categoryID.categoryName}</td>
                                <td style="padding: 14px;"><span style="color: var(--accent); font-weight: 700;">${p.brandID.brandName}</span></td>
                                <td style="padding: 14px; font-weight: 700; color: #ef4444;">
                                    <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                </td>
                                <td style="padding: 14px;">
                                    <c:choose>
                                        <c:when test="${p.status}">
                                            <span style="color: #10b981; font-weight: 600;">● Đang kinh doanh</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #ef4444; font-weight: 600;">● Tạm ngưng</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="7" style="padding: 30px; text-align: center; color: var(--text-secondary);">Không tìm thấy sản phẩm nào phù hợp với điều kiện tìm kiếm.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <!-- Phân trang 10 sản phẩm mỗi trang -->
    <c:if test="${totalPages > 1}">
        <div style="display: flex; justify-content: center; gap: 8px; margin-top: 30px;">
            <c:forEach begin="1" end="${totalPages}" var="p">
                <a href="${pageContext.request.contextPath}/admin/products?keyword=${keyword}&categoryId=${categoryId}&status=${status}&page=${p}"
                   class="btn" style="padding: 8px 16px; background-color: ${p == currentPage ? 'var(--accent)' : 'var(--bg-secondary)'}; color: ${p == currentPage ? '#000' : '#fff'}; border: 1px solid var(--border-color);">
                    ${p}
                </a>
            </c:forEach>
        </div>
    </c:if>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>