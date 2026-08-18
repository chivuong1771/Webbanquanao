<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="container" style="padding-top: 60px; padding-bottom: 80px; display: flex; justify-content: center; align-items: center;">
    <div style="background-color: var(--bg-secondary); border: 1px solid var(--border-color); border-radius: var(--radius-lg); padding: 40px; width: 100%; max-width: 450px; box-shadow: var(--shadow-md); text-align: center;">

        <!-- Header / Logo -->
        <h2 style="font-size: 2rem; font-weight: 800; color: var(--accent); margin-bottom: 6px; letter-spacing: 0.5px;">
            Fashion Shop
        </h2>
        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--text-primary); margin-bottom: 12px;">
            Xác Thực Mã OTP
        </h3>
        <p style="color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 24px; line-height: 1.5;">
            Mã xác thực đã được gửi đến email:<br>
            <strong style="color: var(--text-primary); font-size: 0.95rem;">${email}</strong>
        </p>

        <!-- Thông báo lỗi -->
        <c:if test="${not empty error}">
            <div class="form-error" style="margin-bottom: 20px; text-align: center; font-size: 0.9rem; padding: 10px 14px; background-color: rgba(239, 68, 68, 0.1); border: 1px solid #ef4444; color: #fca5a5; border-radius: var(--radius-md);">
                ${error}
            </div>
        </c:if>

        <!-- Form xác nhận OTP -->
        <form action="${pageContext.request.contextPath}/verify-otp" method="POST" style="text-align: left;">
            <input type="hidden" name="email" value="${email}">

            <div style="margin-bottom: 20px;">
                <label style="display: block; font-size: 0.85rem; color: var(--text-secondary); margin-bottom: 6px; font-weight: 600;">
                    Mã OTP (6 chữ số)
                </label>
                <input type="text" name="otp" maxlength="6" required autocomplete="off" placeholder="••••••"
                       style="width: 100%; padding: 12px; background-color: var(--bg-primary); border: 1px solid var(--border-color); border-radius: var(--radius-md); color: var(--accent); font-size: 1.5rem; font-weight: bold; text-align: center; letter-spacing: 6px;">
            </div>

            <div style="margin-bottom: 20px;">
                <label style="display: block; font-size: 0.85rem; color: var(--text-secondary); margin-bottom: 6px; font-weight: 600;">
                    Mật Khẩu Mới
                </label>
                <input type="password" name="newPassword" required placeholder="Nhập mật khẩu mới"
                       style="width: 100%; padding: 12px; background-color: var(--bg-primary); border: 1px solid var(--border-color); border-radius: var(--radius-md); color: var(--text-primary); font-size: 0.95rem;">
            </div>

            <div style="margin-bottom: 28px;">
                <label style="display: block; font-size: 0.85rem; color: var(--text-secondary); margin-bottom: 6px; font-weight: 600;">
                    Xác Nhận Mật Khẩu
                </label>
                <input type="password" name="confirmPassword" required placeholder="Nhập lại mật khẩu"
                       style="width: 100%; padding: 12px; background-color: var(--bg-primary); border: 1px solid var(--border-color); border-radius: var(--radius-md); color: var(--text-primary); font-size: 0.95rem;">
            </div>

            <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px; font-size: 1rem; font-weight: 700; border-radius: var(--radius-md);">
                Xác Nhận & Đổi Mật Khẩu
            </button>
        </form>

        <!-- Link gửi lại OTP -->
        <div style="margin-top: 20px; border-top: 1px solid var(--border-color); padding-top: 16px; text-align: center;">
            <a href="${pageContext.request.contextPath}/forgot-password" style="color: var(--accent); font-size: 0.85rem; text-decoration: none; font-weight: 600;">
                <i class="fa-solid fa-rotate-right" style="margin-right: 4px;"></i> Gửi lại mã OTP
            </a>
        </div>

    </div>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>