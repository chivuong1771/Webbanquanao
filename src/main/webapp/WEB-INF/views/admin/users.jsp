<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="container" style="margin-top: 30px; margin-bottom: 80px;">
    <h2 class="section-title" style="margin-bottom: 20px;">LAB 5 - BÀI 2: QUẢN LÝ & TÌM KIẾM PHÂN TRANG NHÂN VIÊN</h2>

    <c:if test="${not empty param.newPass}">
        <div style="background-color: #065f46; color: #34d399; padding: 14px; border-radius: 8px; margin-bottom: 20px;">
            <i class="fa-solid fa-circle-check"></i> Đã cấp lại mật khẩu thành công cho tài khoản <strong>${param.email}</strong>! Mật khẩu mới vừa tạo: <strong style="font-size: 1.2rem; color: #fff; text-decoration: underline;">${param.newPass}</strong> (Đã giả lập gửi tới email nhân viên).
        </div>
    </c:if>

    <!-- Form Tìm kiếm Nhân viên -->
    <form action="${pageContext.request.contextPath}/admin/users" method="GET" style="background-color: var(--bg-secondary); padding: 20px; border-radius: 8px; border: 1px solid var(--border-color); margin-bottom: 30px; display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)) 120px; gap: 15px; align-items: end;">
        <div>
            <label class="form-label">Tên nhân viên</label>
            <input type="text" name="keyword" value="${keyword}" placeholder="Nhập tên nhân viên..." class="form-control">
        </div>
        <div>
            <label class="form-label">Email</label>
            <input type="text" name="email" value="${email}" placeholder="Nhập email..." class="form-control">
        </div>
        <div>
            <label class="form-label">Trạng thái</label>
            <select name="status" class="form-control">
                <option value="">-- Tất cả trạng thái --</option>
                <option value="true" ${status == 'true' ? 'selected' : ''}>Hoạt động</option>
                <option value="false" ${status == 'false' ? 'selected' : ''}>Tạm khóa</option>
            </select>
        </div>
        <div>
            <button type="submit" class="btn btn-primary" style="width: 100%; height: 42px;">
                <i class="fa-solid fa-magnifying-glass"></i> Tìm Kiếm
            </button>
        </div>
    </form>

    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
        <span style="color: var(--text-secondary);">Tổng số nhân viên tìm thấy: <strong>${totalUsers}</strong> (Mỗi trang 10 nhân viên)</span>
    </div>

    <!-- Bảng Danh Sách Nhân Viên -->
    <div style="overflow-x: auto; background-color: var(--bg-secondary); border-radius: 8px; border: 1px solid var(--border-color);">
        <table style="width: 100%; border-collapse: collapse; text-align: left;">
            <thead>
                <tr style="border-bottom: 1px solid var(--border-color); background-color: rgba(255,255,255,0.05);">
                    <th style="padding: 14px;">ID</th>
                    <th style="padding: 14px;">Họ và Tên</th>
                    <th style="padding: 14px;">Email</th>
                    <th style="padding: 14px;">Số Điện Thoại</th>
                    <th style="padding: 14px;">Vai Trò</th>
                    <th style="padding: 14px;">Trạng Thái</th>
                    <th style="padding: 14px; text-align: center;">Thao Tác (Bài 3)</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty users}">
                        <c:forEach var="u" items="${users}">
                            <tr style="border-bottom: 1px solid var(--border-color);">
                                <td style="padding: 14px;">#${u.id}</td>
                                <td style="padding: 14px; font-weight: 600;">${u.fullName}</td>
                                <td style="padding: 14px;">${u.email}</td>
                                <td style="padding: 14px;">${u.phone}</td>
                                <td style="padding: 14px;"><span style="color: var(--accent); font-weight: 700;">${u.roleID.roleName}</span></td>
                                <td style="padding: 14px;">
                                    <c:choose>
                                        <c:when test="${u.status}">
                                            <span style="color: #10b981; font-weight: 600;">● Hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #ef4444; font-weight: 600;">● Tạm khóa</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="padding: 14px; text-align: center;">
                                    <form action="${pageContext.request.contextPath}/admin/users/reset-password" method="POST" style="display: inline;" onsubmit="return confirm('Bạn có chắc chắn muốn cấp lại mật khẩu ngẫu nhiên cho nhân viên ${u.fullName}?');">
                                        <input type="hidden" name="userId" value="${u.id}">
                                        <button type="submit" class="btn" style="background-color: #3b82f6; color: #fff; padding: 6px 12px; font-size: 0.85rem;">
                                            <i class="fa-solid fa-key"></i> Cấp Mật Khẩu Mới
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="7" style="padding: 30px; text-align: center; color: var(--text-secondary);">Không tìm thấy nhân viên nào phù hợp với điều kiện tìm kiếm.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <!-- Phân trang 10 sản phẩm/nhân viên mỗi trang -->
    <c:if test="${totalPages > 1}">
        <div style="display: flex; justify-content: center; gap: 8px; margin-top: 30px;">
            <c:forEach begin="1" end="${totalPages}" var="p">
                <a href="${pageContext.request.contextPath}/admin/users?keyword=${keyword}&email=${email}&status=${status}&page=${p}"
                   class="btn" style="padding: 8px 16px; background-color: ${p == currentPage ? 'var(--accent)' : 'var(--bg-secondary)'}; color: ${p == currentPage ? '#000' : '#fff'}; border: 1px solid var(--border-color);">
                    ${p}
                </a>
            </c:forEach>
        </div>
    </c:if>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
