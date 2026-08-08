<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="container">
    <div class="form-card">
        <h2 class="form-title">Đăng Nhập</h2>
        <p class="form-desc">Chào mừng bạn quay trở lại với ANTIGRAVITY</p>

        <!-- Thông báo lỗi đăng nhập -->
        <c:if test="${not empty error}">
            <div class="form-error">
                <i class="fa-solid fa-triangle-exclamation"></i> ${error}
            </div>
        </c:if>

        <!-- Thông báo từ Servlet (Đăng ký thành công, v.v.) -->
        <c:if test="${not empty message}">
            <div class="form-success" style="color: #10b981; background: #ecfdf5; padding: 10px; border-radius: 6px; margin-bottom: 15px; text-align: center;">
                <i class="fa-solid fa-circle-check"></i> ${message}
            </div>
        </c:if>

        <!-- Thông báo đăng ký thành công qua Param URL -->
        <c:if test="${param.success == 'register_ok'}">
            <div class="form-success" style="color: #10b981; background: #ecfdf5; padding: 10px; border-radius: 6px; margin-bottom: 15px; text-align: center;">
                <i class="fa-solid fa-circle-check"></i> Đăng ký thành công! Vui lòng đăng nhập bằng tài khoản mới.
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="POST">
            <%-- SỬA LỖI: Đổi name="username" -> name="email" cho khớp với UserDAO.login --%>
            <div class="form-group">
                <label for="email" class="form-label">Email (*)</label>
                <input type="email" id="email" name="email" class="form-control" placeholder="Nhập địa chỉ email" value="${email}" required autocomplete="email">
            </div>

            <div class="form-group" style="margin-bottom: 24px;">
                <label for="password" class="form-label">Mật khẩu (*)</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="Nhập mật khẩu" required autocomplete="current-password">
            </div>

            <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px; margin-bottom: 20px;">
                Đăng Nhập
            </button>

            <p style="text-align: center; font-size: 0.9rem; color: var(--text-secondary);">
                Bạn chưa có tài khoản?
                <a href="${pageContext.request.contextPath}/register" style="color: var(--accent); font-weight: 600;">Đăng ký ngay</a>
            </p>
        </form>
    </div>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>