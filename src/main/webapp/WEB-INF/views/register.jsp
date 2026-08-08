<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký Tài Khoản - E-Clothing Store</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-light d-flex align-items-center justify-content-center" style="min-height: 100vh;">

<div class="card shadow-sm p-4" style="width: 100%; max-width: 450px; border-radius: 12px;">
    <div class="text-center mb-4">
        <h3 class="fw-bold">ĐĂNG KÝ TÀI KHOẢN</h3>
        <p class="text-muted">Tạo tài khoản để trải nghiệm mua sắm ngay</p>
    </div>

    <!-- Báo lỗi nếu có -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger py-2" role="alert">
            <i class="fa-solid fa-triangle-exclamation me-2"></i>${error}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/register" method="post">
        <div class="mb-3">
            <label class="form-label fw-semibold">Họ và Tên (*)</label>
            <input type="text" name="fullName" class="form-control" value="${fullName}" required placeholder="Nguyễn Văn A">
        </div>

        <div class="mb-3">
            <label class="form-label fw-semibold">Email (*)</label>
            <input type="email" name="email" class="form-control" value="${email}" required placeholder="example@gmail.com">
        </div>

        <div class="mb-3">
            <label class="form-label fw-semibold">Số điện thoại</label>
            <input type="tel" name="phone" class="form-control" value="${phone}" placeholder="0901234567">
        </div>

        <div class="mb-3">
            <label class="form-label fw-semibold">Mật khẩu (*)</label>
            <input type="password" name="password" class="form-control" required placeholder="••••••••">
        </div>

        <div class="mb-3">
            <label class="form-label fw-semibold">Xác nhận mật khẩu (*)</label>
            <input type="password" name="confirmPassword" class="form-control" required placeholder="••••••••">
        </div>

        <button type="submit" class="btn btn-dark w-100 py-2 fw-bold mt-2">ĐĂNG KÝ</button>
    </form>

    <div class="text-center mt-4">
        <span class="text-muted">Đã có tài khoản?</span>
        <a href="${pageContext.request.contextPath}/login" class="text-dark fw-bold text-decoration-none ms-1">Đăng nhập ngay</a>
    </div>
</div>

</body>
</html>