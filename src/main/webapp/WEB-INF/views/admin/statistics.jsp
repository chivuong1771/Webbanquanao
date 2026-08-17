<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo Cáo Thống Kê & Doanh Thu - Admin Panel</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=3">
</head>
<body class="admin-layout">

    <!-- Sidebar Admin -->
    <aside class="admin-sidebar">
        <div class="logo" style="margin-bottom: 30px;">
            <i class="fa-solid fa-crown" style="color: var(--accent);"></i> PANEL ADMIN
        </div>
        <div style="color: var(--text-muted); font-size: 0.8rem; text-transform: uppercase; font-weight: 700; letter-spacing: 1px; margin-bottom: 12px;">
            QUẢN LÝ HỆ THỐNG
        </div>
        <nav class="admin-menu">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-menu-item">
                <i class="fa-solid fa-chart-pie"></i> Tổng quan
            </a>
            <a href="${pageContext.request.contextPath}/admin/products" class="admin-menu-item">
                <i class="fa-solid fa-shirt"></i> Sản phẩm
            </a>
            <a href="${pageContext.request.contextPath}/admin/categories" class="admin-menu-item">
                <i class="fa-solid fa-list"></i> Danh mục
            </a>
            <a href="${pageContext.request.contextPath}/admin/orders" class="admin-menu-item">
                <i class="fa-solid fa-receipt"></i> Đơn hàng
            </a>
            <a href="${pageContext.request.contextPath}/admin/coupons" class="admin-menu-item">
                <i class="fa-solid fa-ticket"></i> Mã giảm giá
            </a>
            <a href="${pageContext.request.contextPath}/admin/users" class="admin-menu-item">
                <i class="fa-solid fa-users"></i> Người dùng
            </a>
            <a href="${pageContext.request.contextPath}/admin/statistics" class="admin-menu-item active">
                <i class="fa-solid fa-chart-line"></i> Báo cáo thống kê
            </a>
            <a href="${pageContext.request.contextPath}/" class="admin-menu-item" style="margin-top: 30px; border-top: 1px solid var(--border-color); padding-top: 20px; color: var(--accent);">
                <i class="fa-solid fa-store"></i> Về Cửa Hàng
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="admin-menu-item" style="color: #ef4444;">
                <i class="fa-solid fa-right-from-bracket"></i> Đăng Xuất
            </a>
        </nav>
    </aside>

    <!-- Main Content -->
    <main class="admin-main">
        <header style="background: transparent; border: none; padding: 0; margin-bottom: 30px; position: static;">
            <h1 style="font-size: 2rem; font-weight: 800;">Báo Cáo Thống Kê & Doanh Thu</h1>
            <p style="color: var(--text-secondary);">Thống kê hiệu quả bán hàng, các sản phẩm bán chạy và biểu đồ doanh thu</p>
        </header>

        <!-- Form Lọc Theo Ngày -->
        <form action="${pageContext.request.contextPath}/admin/statistics" method="GET" style="background: var(--bg-secondary); border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 20px; margin-bottom: 30px; display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)) 140px; gap: 16px; align-items: end;">
            <div>
                <label class="form-label" style="font-size: 0.85rem;">Từ ngày (Start Date)</label>
                <input type="date" name="startDate" value="${startDate}" class="form-control" style="color-scheme: dark;">
            </div>
            <div>
                <label class="form-label" style="font-size: 0.85rem;">Đến ngày (End Date)</label>
                <input type="date" name="endDate" value="${endDate}" class="form-control" style="color-scheme: dark;">
            </div>
            <div>
                <button type="submit" class="btn btn-primary" style="width: 100%; height: 42px;">
                    <i class="fa-solid fa-filter"></i> Lọc Dữ Liệu
                </button>
            </div>
        </form>

        <!-- Thẻ Tổng Quan Doanh Thu -->
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-bottom: 35px;">
            <div style="background-color: var(--bg-secondary); padding: 24px; border-radius: var(--radius-md); border: 1px solid var(--border-color); border-left: 4px solid var(--accent);">
                <span style="color: var(--text-secondary); font-size: 0.85rem;">Tổng Doanh Thu (Kỳ Lọc):</span>
                <div style="font-size: 1.8rem; font-weight: 800; color: var(--accent); margin-top: 6px;">
                    <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                </div>
            </div>
            <div style="background-color: var(--bg-secondary); padding: 24px; border-radius: var(--radius-md); border: 1px solid var(--border-color); border-left: 4px solid #3b82f6;">
                <span style="color: var(--text-secondary); font-size: 0.85rem;">Tổng Số Hóa Đơn:</span>
                <div style="font-size: 1.8rem; font-weight: 800; color: #3b82f6; margin-top: 6px;">${totalOrders} đơn</div>
            </div>
            <div style="background-color: var(--bg-secondary); padding: 24px; border-radius: var(--radius-md); border: 1px solid var(--border-color); border-left: 4px solid #10b981;">
                <span style="color: var(--text-secondary); font-size: 0.85rem;">Tổng Sản Phẩm Đang Bán:</span>
                <div style="font-size: 1.8rem; font-weight: 800; color: #10b981; margin-top: 6px;">${totalProducts} SP</div>
            </div>
        </div>

        <!-- TOP 5 SẢN PHẨM BÁN CHẠY NHẤT -->
        <section style="margin-bottom: 40px;">
            <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 16px;">
                <i class="fa-solid fa-fire" style="color: #ef4444; margin-right: 6px;"></i> Top 5 Sản Phẩm Bán Chạy Nhất
            </h3>
            <div style="background-color: var(--bg-secondary); border-radius: var(--radius-md); border: 1px solid var(--border-color); padding: 20px; overflow-x: auto;">
                <table style="width: 100%; border-collapse: collapse; text-align: left;">
                    <thead>
                        <tr style="border-bottom: 1px solid var(--border-color); color: var(--text-secondary);">
                            <th style="padding: 12px; width: 80px;">Hạng</th>
                            <th style="padding: 12px;">Tên Sản Phẩm</th>
                            <th style="padding: 12px;">Danh Mục</th>
                            <th style="padding: 12px;">Số Lượng Đã Bán</th>
                            <th style="padding: 12px; text-align: right;">Doanh Thu Mang Về</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty top5Selling}">
                                <c:forEach var="item" items="${top5Selling}" varStatus="loop">
                                    <tr style="border-bottom: 1px solid var(--border-color);">
                                        <td style="padding: 14px; font-weight: 800; color: var(--accent);">#${loop.index + 1}</td>
                                        <td style="padding: 14px; font-weight: 600;">${item[0].productName}</td>
                                        <td style="padding: 14px; color: var(--text-secondary);">${item[0].categoryID != null ? item[0].categoryID.categoryName : 'Thời trang'}</td>
                                        <td style="padding: 14px; font-weight: 700; color: #10b981;">${item[1]} sản phẩm</td>
                                        <td style="padding: 14px; text-align: right; font-weight: 700; color: #ef4444;">
                                            <fmt:formatNumber value="${item[2]}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" style="padding: 30px; text-align: center; color: var(--text-secondary);">Không có dữ liệu sản phẩm bán chạy trong khoảng thời gian này.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </section>

        <!-- BIỂU ĐỒ DOANH THU -->
        <section>
            <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 16px;">
                <i class="fa-solid fa-chart-column" style="color: var(--accent); margin-right: 6px;"></i> Biểu Đồ Thống Kê Doanh Thu Theo Ngày
            </h3>
            <div style="background-color: var(--bg-secondary); border-radius: var(--radius-md); border: 1px solid var(--border-color); padding: 24px;">
                <canvas id="revenueChart" style="max-height: 380px; width: 100%;"></canvas>
            </div>
        </section>
    </main>

    <!-- Tích hợp Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const labels = [
                <c:forEach var="row" items="${dailyRevenue}" varStatus="loop">
                    "${row[0]}"${!loop.last ? ',' : ''}
                </c:forEach>
            ];

            const dataValues = [
                <c:forEach var="row" items="${dailyRevenue}" varStatus="loop">
                    ${row[1]}${!loop.last ? ',' : ''}
                </c:forEach>
            ];

            const ctx = document.getElementById('revenueChart').getContext('2d');
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labels.length > 0 ? labels : ['Chưa có dữ liệu'],
                    datasets: [{
                        label: 'Doanh Thu (VNĐ)',
                        data: dataValues.length > 0 ? dataValues : [0],
                        backgroundColor: 'rgba(212, 175, 55, 0.7)',
                        borderColor: 'rgba(212, 175, 55, 1)',
                        borderWidth: 2,
                        borderRadius: 6
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: { labels: { color: '#e2e8f0', font: { size: 14 } } }
                    },
                    scales: {
                        x: { ticks: { color: '#94a3b8' }, grid: { color: 'rgba(255,255,255,0.05)' } },
                        y: { ticks: { color: '#94a3b8' }, grid: { color: 'rgba(255,255,255,0.05)' } }
                    }
                }
            });
        });
    </script>
</body>
</html>
