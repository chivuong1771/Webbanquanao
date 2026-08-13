<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cổng Giả Lập Hệ Thống Ngân Hàng - Fashion Shop</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bg-primary: #0b0f19;
            --bg-secondary: #111827;
            --bg-tertiary: #1f2937;
            --accent: #f59e0b;
            --accent-hover: #d97706;
            --text-primary: #f3f4f6;
            --text-secondary: #9ca3af;
            --border-color: #374151;
            --radius-md: 8px;
            --radius-lg: 12px;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Outfit', sans-serif;
        }

        body {
            background-color: var(--bg-primary);
            color: var(--text-primary);
            min-height: 100vh;
            padding: 40px 20px;
        }

        .container {
            max-width: 1000px;
            margin: 0 auto;
        }

        .header {
            text-align: center;
            margin-bottom: 40px;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 24px;
        }

        .header i {
            font-size: 3.5rem;
            color: var(--accent);
            margin-bottom: 16px;
        }

        .header h1 {
            font-size: 2.2rem;
            font-weight: 800;
            margin-bottom: 8px;
            letter-spacing: -0.5px;
        }

        .header p {
            color: var(--text-secondary);
            font-size: 1rem;
        }

        .alert-success {
            background-color: rgba(16, 185, 129, 0.15);
            border: 1px solid rgba(16, 185, 129, 0.3);
            color: #10b981;
            padding: 16px;
            border-radius: var(--radius-md);
            margin-bottom: 24px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-error {
            background-color: rgba(239, 68, 68, 0.15);
            border: 1px solid rgba(239, 68, 68, 0.3);
            color: #ef4444;
            padding: 16px;
            border-radius: var(--radius-md);
            margin-bottom: 24px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .card {
            background-color: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            padding: 32px;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.3);
        }

        .card-title {
            font-size: 1.3rem;
            font-weight: 700;
            margin-bottom: 24px;
            color: var(--accent);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .table-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        th {
            color: var(--text-secondary);
            font-weight: 600;
            padding: 16px;
            border-bottom: 2px solid var(--border-color);
            font-size: 0.9rem;
            text-transform: uppercase;
        }

        td {
            padding: 20px 16px;
            border-bottom: 1px solid var(--border-color);
            font-size: 0.95rem;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 18px;
            border-radius: var(--radius-md);
            font-weight: 700;
            font-size: 0.85rem;
            text-decoration: none;
            cursor: pointer;
            border: none;
            transition: all 0.3s ease;
        }

        .btn-success {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            box-shadow: 0 4px 6px -1px rgba(16, 185, 129, 0.2);
        }

        .btn-success:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 12px -1px rgba(16, 185, 129, 0.3);
        }

        .code-highlight {
            font-family: monospace;
            background-color: var(--bg-tertiary);
            padding: 4px 8px;
            border-radius: 4px;
            color: var(--accent);
            font-weight: 700;
            font-size: 0.95rem;
        }

        .empty-state {
            text-align: center;
            padding: 60px 0;
            color: var(--text-secondary);
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 16px;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <i class="fa-solid fa-university"></i>
        <h1>Cổng Giả Lập Hệ Thống Ngân Hàng</h1>
        <p>Kiểm thử hệ thống Webhook tự động cập nhật trạng thái đơn hàng khi nhận được tiền</p>
    </div>

    <!-- Thông báo kết quả giả lập -->
    <c:if test="${param.success == '1'}">
        <div class="alert-success">
            <i class="fa-solid fa-circle-check"></i> Đã kích hoạt chuyển tiền thành công! Webhook đã cập nhật trạng thái đơn hàng sang ĐÃ THANH TOÁN (PAID).
        </div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="alert-error">
            <i class="fa-solid fa-circle-xmark"></i> Lỗi xử lý giao dịch. Vui lòng kiểm tra lại ID đơn hàng!
        </div>
    </c:if>

    <div class="card">
        <div class="card-title">
            <i class="fa-solid fa-list-check"></i> Danh sách đơn hàng đang chờ chuyển khoản trực tuyến
        </div>

        <div class="table-container">
            <c:choose>
                <c:when test="${not empty unpaidOrders}">
                    <table>
                        <thead>
                            <tr>
                                <th>Mã Đơn</th>
                                <th>Khách Hàng</th>
                                <th>Tổng Tiền</th>
                                <th>Nội Dung Chuyển Khoản Yêu Cầu</th>
                                <th style="text-align: center;">Hành Động Giả Lập</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${unpaidOrders}">
                                <tr>
                                    <td style="font-weight: 700;">#${order.id}</td>
                                    <td>
                                        <div style="font-weight: 600;">${order.fullname}</div>
                                        <div style="font-size: 0.8rem; color: var(--text-secondary);">${order.phone}</div>
                                    </td>
                                    <td style="font-weight: 700; color: #10b981;">
                                        <fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                    </td>
                                    <td>
                                        <span class="code-highlight">FASHIONSHOP ${order.id}</span>
                                    </td>
                                    <td style="text-align: center;">
                                        <form action="${pageContext.request.contextPath}/checkout/payment/bank-simulator/trigger" method="POST" style="display: inline;">
                                            <input type="hidden" name="orderId" value="${order.id}">
                                            <button type="submit" class="btn btn-success">
                                                <i class="fa-solid fa-paper-plane"></i> Giả lập khách chuyển tiền
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fa-solid fa-circle-check" style="color: #10b981;"></i>
                        <h3>Hiện tại không có đơn hàng nào chờ thanh toán!</h3>
                        <p style="margin-top: 8px;">Vui lòng thực hiện đặt đơn hàng trực tuyến mới ngoài cửa hàng để hiển thị tại đây.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

</body>
</html>
