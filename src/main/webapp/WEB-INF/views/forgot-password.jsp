<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="container">
    <div class="form-card">
        <h2 class="form-title">Quên Mật Khẩu</h2>
        <p class="form-desc">Nhập email liên kết với tài khoản của bạn để nhận hướng dẫn khôi phục.</p>

        <!-- Thông báo lỗi -->
        <c:if test="${not empty error}">
            <div class="form-error">
                <i class="fa-solid fa-triangle-exclamation"></i> ${error}
            </div>
        </c:if>

        <!-- Thông báo thành công -->
        <c:if test="${not empty message}">
            <div class="form-success" style="color: #10b981; background: #ecfdf5; padding: 10px; border-radius: 6px; margin-bottom: 15px; text-align: center;">
                <i class="fa-solid fa-circle-check"></i> ${message}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/forgot-password" method="POST">
            <div class="form-group" style="margin-bottom: 24px;">
                <label for="email" class="form-label">Email tài khoản (*)</label>
                <input type="email" id="email" name="email" class="form-control" placeholder="Nhập email của bạn" value="${email}" required autocomplete="email">
            </div>

            <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px; margin-bottom: 20px;">
                Gửi Yêu Cầu
            </button>

            <p style="text-align: center; font-size: 0.9rem; color: var(--text-secondary);">
                Quay lại <a href="${pageContext.request.contextPath}/login" style="color: var(--accent); font-weight: 600;">Đăng nhập</a>
            </p>
        </form>
    </div>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>