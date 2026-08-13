<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="container" style="margin-top: 30px; margin-bottom: 80px;">
    <h2 class="section-title" style="margin-bottom: 20px;">LAB 6 - BÁO CÁO THỐNG KÊ THỨC UỐNG & DOANH THU</h2>

    <!-- Form Chọn Khoảng Thời Gian (Bài 2 & Bài 3) -->
    <form action="${pageContext.request.contextPath}/admin/statistics" method="GET" style="background-color: var(--bg-secondary); padding: 20px; border-radius: 8px; border: 1px solid var(--border-color); margin-bottom: 30px; display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)) 140px; gap: 15px; align-items: end;">
        <div>
            <label class="form-label">Từ ngày (Start Date)</label>
            <input type="date" name="startDate" value="${startDate}" class="form-control" style="color-scheme: dark;">
        </div>
        <div>
            <label class="form-label">Đến ngày (End Date)</label>
            <input type="date" name="endDate" value="${endDate}" class="form-control" style="color-scheme: dark;">
        </div>
        <div>
            <button type="submit" class="btn btn-primary" style="width: 100%; height: 42px;">
                <i class="fa-solid fa-filter"></i> Lọc Thống Kê
            </button>
        </div>
    </form>

    <!-- Thẻ Tổng Quan Thống Kê (Bài 4) -->
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-bottom: 40px;">
        <div style="background-color: var(--bg-secondary); padding: 24px; border-radius: 8px; border-left: 5px solid var(--accent);">
            <span style="color: var(--text-secondary); font-size: 0.9rem;">Tổng Doanh Thu (Khoảng thời gian):</span>
            <div style="font-size: 1.8rem; font-weight: 800; color: var(--accent); margin-top: 4px;">
                <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
            </div>
        </div>
        <div style="background-color: var(--bg-secondary); padding: 24px; border-radius: 8px; border-left: 5px solid #3b82f6;">
            <span style="color: var(--text-secondary); font-size: 0.9rem;">Tổng Hóa Đơn:</span>
            <div style="font-size: 1.8rem; font-weight: 800; color: #3b82f6; margin-top: 4px;">${totalOrders} đơn</div>
        </div>
        <div style="background-color: var(--bg-secondary); padding: 24px; border-radius: 8px; border-left: 5px solid #10b981;">
            <span style="color: var(--text-secondary); font-size: 0.9rem;">Tổng Sản Phẩm Kinh Doanh:</span>
            <div style="font-size: 1.8rem; font-weight: 800; color: #10b981; margin-top: 4px;">${totalProducts} sản phẩm</div>
        </div>
    </div>

    <!-- BÀI 2: THỐNG KÊ 5 THỨC UỐNG / SẢN PHẨM BÁN CHẠY NHẤT -->
    <section style="margin-bottom: 50px;">
        <h3 class="section-title" style="font-size: 1.25rem; margin-bottom: 15px;">
            BÀI 2 (2 ĐIỂM): TOP 5 THỨC UỐNG / SẢN PHẨM BÁN CHẠY NHẤT
        </h3>

        <div style="overflow-x: auto; background-color: var(--bg-secondary); border-radius: 8px; border: 1px solid var(--border-color);">
            <table style="width: 100%; border-collapse: collapse; text-align: left;">
                <thead>
                    <tr style="border-bottom: 1px solid var(--border-color); background-color: rgba(255,255,255,0.05);">
                        <th style="padding: 14px;">Hạng</th>
                        <th style="padding: 14px;">Tên Sản Phẩm / Thức Uống</th>
                        <th style="padding: 14px;">Danh Mục</th>
                        <th style="padding: 14px;">Số Lượng Đã Bán</th>
                        <th style="padding: 14px; text-align: right;">Tổng Doanh Thu Mang Về</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty top5Selling}">
                            <c:forEach var="item" items="${top5Selling}" varStatus="loop">
                                <tr style="border-bottom: 1px solid var(--border-color);">
                                    <td style="padding: 14px; font-weight: 800; color: var(--accent);">#${loop.index + 1}</td>
                                    <td style="padding: 14px; font-weight: 600;">${item[0].productName}</td>
                                    <td style="padding: 14px;">${item[0].categoryID.categoryName}</td>
                                    <td style="padding: 14px; font-weight: 700; color: #10b981;">${item[1]} sản phẩm</td>
                                    <td style="padding: 14px; text-align: right; font-weight: 700; color: #ef4444;">
                                        <fmt:formatNumber value="${item[2]}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="5" style="padding: 30px; text-align: center; color: var(--text-secondary);">Không có dữ liệu thức uống bán chạy trong khoảng thời gian này.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </section>

    <!-- BÀI 3: THỐNG KÊ DOANH THU & GIẢI THUẬT BIỂU ĐỒ -->
    <section>
        <h3 class="section-title" style="font-size: 1.25rem; margin-bottom: 15px;">
            BÀI 3 (3 ĐIỂM): BIỂU ĐỒ THỐNG KÊ DOANH THU
        </h3>

        <!-- Giao diện Biểu Đồ Thống Kê Doanh Thu bằng HTML5 Canvas & Chart.js -->
        <div style="background-color: var(--bg-secondary); padding: 24px; border-radius: 8px; border: 1px solid var(--border-color);">
            <canvas id="revenueChart" style="max-height: 380px; width: 100%;"></canvas>
        </div>
    </section>
</div>

<!-- Tích hợp Thư viện Biểu đồ Chart.js -->
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
                labels: labels.length > 0 ? labels : ['Không có dữ liệu'],
                datasets: [{
                    label: 'Doanh Thu (VNĐ)',
                    data: dataValues.length > 0 ? dataValues : [0],
                    backgroundColor: 'rgba(217, 119, 6, 0.7)',
                    borderColor: 'rgba(217, 119, 6, 1)',
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

<%@ include file="/WEB-INF/views/footer.jsp" %>
