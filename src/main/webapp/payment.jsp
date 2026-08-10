<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="container" style="padding-top: 40px; padding-bottom: 60px;">
    <div style="text-align: center; margin-bottom: 36px;">
        <h2 style="font-size: 2.2rem; font-weight: 800; margin-bottom: 8px;">Cổng Thanh Toán Trực Tuyến</h2>
        <p style="color: var(--text-secondary); max-width: 500px; margin: 0 auto;">Vui lòng thực hiện chuyển khoản hoặc quét mã QR dưới đây để hoàn tất đơn đặt hàng.</p>
    </div>

    <!-- Banner báo lỗi chuyển khoản thất bại -->
    <div id="local-error-banner" class="form-error" style="display: none; margin-bottom: 30px; text-align: left; padding: 16px 20px; font-weight: 600;">
        <i class="fa-solid fa-circle-xmark" style="margin-right: 8px;"></i> Giao dịch chưa hoàn thành! Hệ thống chưa nhận được khoản thanh toán của bạn từ ngân hàng/ví điện tử. Vui lòng quét lại mã QR và hoàn tất chuyển khoản!
    </div>

    <div class="cart-layout" style="grid-template-columns: 1.8fr 1.2fr; gap: 30px; align-items: start;">
        
        <!-- Cột Bên Trái: Giao diện thanh toán -->
        <div style="background-color: var(--bg-secondary); border: 1px solid var(--border-color); border-radius: var(--radius-lg); padding: 32px; box-shadow: var(--shadow-md);">
            
            <!-- Bộ đếm ngược thời gian -->
            <div style="display: flex; align-items: center; justify-content: space-between; background-color: rgba(245, 158, 11, 0.08); border: 1px solid rgba(245, 158, 11, 0.2); border-radius: var(--radius-md); padding: 14px 20px; margin-bottom: 28px;">
                <div style="display: flex; align-items: center; gap: 8px; color: #f59e0b; font-weight: 600;">
                    <i class="fa-regular fa-clock fa-spin"></i> Thời gian thanh toán còn lại:
                </div>
                <div id="countdown" style="font-family: monospace; font-size: 1.3rem; font-weight: 700; color: #f59e0b;">10:00</div>
            </div>

            <!-- Tabs lựa chọn phương thức trực tuyến -->
            <div style="display: flex; border-bottom: 1px solid var(--border-color); margin-bottom: 24px; gap: 12px;">
                <button onclick="switchTab('bank-tab')" id="bank-btn" class="tab-btn active" style="flex: 1; padding: 14px; background: none; border: none; font-weight: 700; font-size: 1rem; color: var(--text-secondary); cursor: pointer; border-bottom: 2px solid transparent; transition: all 0.3s;">
                    <i class="fa-solid fa-building-columns" style="margin-right: 6px;"></i> Ngân Hàng (VietQR)
                </button>
                <button onclick="switchTab('momo-tab')" id="momo-btn" class="tab-btn" style="flex: 1; padding: 14px; background: none; border: none; font-weight: 700; font-size: 1rem; color: var(--text-secondary); cursor: pointer; border-bottom: 2px solid transparent; transition: all 0.3s;">
                    <i class="fa-solid fa-wallet" style="margin-right: 6px;"></i> Ví Momo
                </button>
                <button onclick="switchTab('zalopay-tab')" id="zalopay-btn" class="tab-btn" style="flex: 1; padding: 14px; background: none; border: none; font-weight: 700; font-size: 1rem; color: var(--text-secondary); cursor: pointer; border-bottom: 2px solid transparent; transition: all 0.3s;">
                    <i class="fa-solid fa-qrcode" style="margin-right: 6px;"></i> Ví ZaloPay
                </button>
            </div>

            <!-- NỘI DUNG TAB 1: NGÂN HÀNG (VietQR) -->
            <div id="bank-tab" class="tab-content" style="display: block;">
                <div style="display: grid; grid-template-columns: 1.2fr 1fr; gap: 24px; align-items: center;">
                    <div>
                        <h4 style="font-size: 1.1rem; font-weight: 700; margin-bottom: 16px; color: var(--accent);">Thông Tin Chuyển Khoản</h4>
                        
                        <div style="display: flex; flex-direction: column; gap: 12px;">
                            <div style="background-color: var(--bg-tertiary); border: 1px solid var(--border-color); border-radius: var(--radius-sm); padding: 12px 16px; position: relative;">
                                <div style="font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase;">Ngân Hàng</div>
                                <div style="font-weight: 700; font-size: 1rem;">MB Bank (Ngân hàng Quân Đội)</div>
                            </div>

                            <div style="background-color: var(--bg-tertiary); border: 1px solid var(--border-color); border-radius: var(--radius-sm); padding: 12px 16px; position: relative;">
                                <div style="font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase;">Số Tài Khoản</div>
                                <div style="font-weight: 700; font-size: 1.1rem; color: var(--accent); display: flex; justify-content: space-between; align-items: center;">
                                    <span id="bank-acc">0346835547</span>
                                    <button onclick="copyText('bank-acc')" style="background: none; border: none; color: var(--text-secondary); cursor: pointer; font-size: 0.95rem;" title="Copy"><i class="fa-regular fa-copy"></i></button>
                                </div>
                            </div>

                            <div style="background-color: var(--bg-tertiary); border: 1px solid var(--border-color); border-radius: var(--radius-sm); padding: 12px 16px;">
                                <div style="font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase;">Chủ Tài Khoản</div>
                                <div style="font-weight: 700; font-size: 1rem;">HUYNH NGOC ANH HUY</div>
                            </div>

                            <div style="background-color: var(--bg-tertiary); border: 1px solid var(--border-color); border-radius: var(--radius-sm); padding: 12px 16px; position: relative;">
                                <div style="font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase;">Số Tiền</div>
                                <div style="font-weight: 700; font-size: 1.1rem; color: var(--accent); display: flex; justify-content: space-between; align-items: center;">
                                    <span><fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                                </div>
                            </div>

                            <div style="background-color: var(--bg-tertiary); border: 1px solid var(--border-color); border-radius: var(--radius-sm); padding: 12px 16px; position: relative;">
                                <div style="font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase;">Nội Dung Chuyển Khoản</div>
                                <div style="font-weight: 700; font-size: 1.1rem; color: var(--accent); display: flex; justify-content: space-between; align-items: center;">
                                    <span id="bank-msg">FASHIONSHOP ${order.id}</span>
                                    <button onclick="copyText('bank-msg')" style="background: none; border: none; color: var(--text-secondary); cursor: pointer; font-size: 0.95rem;" title="Copy"><i class="fa-regular fa-copy"></i></button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Ảnh QR Code VietQR động -->
                    <div style="text-align: center;">
                        <div style="background: #fff; padding: 14px; border-radius: var(--radius-md); display: inline-block; box-shadow: var(--shadow-sm); border: 1px solid var(--border-color);">
                            <img src="https://img.vietqr.io/image/MB-0346835547-compact2.png?amount=${order.totalPrice.intValue()}&addInfo=FASHIONSHOP%20${order.id}&accountName=HUYNH%20NGOC%20ANH%20HUY" style="width: 180px; height: 180px; display: block;" alt="VietQR MB Bank">
                        </div>
                        <p style="font-size: 0.8rem; color: var(--text-secondary); margin-top: 10px; font-style: italic;">Sử dụng App Ngân hàng để quét mã QR</p>
                    </div>
                </div>
            </div>

            <!-- NỘI DUNG TAB 2: VÍ MOMO -->
            <div id="momo-tab" class="tab-content" style="display: none;">
                <div style="display: grid; grid-template-columns: 1.2fr 1fr; gap: 24px; align-items: center;">
                    <div>
                        <h4 style="font-size: 1.1rem; font-weight: 700; margin-bottom: 16px; color: #a50064;">Thanh Toán Qua Ví Momo</h4>
                        
                        <div style="display: flex; flex-direction: column; gap: 12px;">
                            <div style="background-color: var(--bg-tertiary); border: 1px solid var(--border-color); border-radius: var(--radius-sm); padding: 12px 16px;">
                                <div style="font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase;">Số Điện Thoại Nhận</div>
                                <div style="font-weight: 700; font-size: 1.1rem; display: flex; justify-content: space-between; align-items: center;">
                                    <span id="momo-phone">0346835547</span>
                                    <button onclick="copyText('momo-phone')" style="background: none; border: none; color: var(--text-secondary); cursor: pointer;" title="Copy"><i class="fa-regular fa-copy"></i></button>
                                </div>
                            </div>
                            <div style="background-color: var(--bg-tertiary); border: 1px solid var(--border-color); border-radius: var(--radius-sm); padding: 12px 16px;">
                                <div style="font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase;">Tên Người Nhận</div>
                                <div style="font-weight: 700;">HUYNH NGOC ANH HUY</div>
                            </div>
                            <div style="background-color: var(--bg-tertiary); border: 1px solid var(--border-color); border-radius: var(--radius-sm); padding: 12px 16px;">
                                <div style="font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase;">Lời nhắn chuyển tiền</div>
                                <div style="font-weight: 700; color: var(--accent); display: flex; justify-content: space-between; align-items: center;">
                                    <span id="momo-msg">MOMO FASHIONSHOP ${order.id}</span>
                                    <button onclick="copyText('momo-msg')" style="background: none; border: none; color: var(--text-secondary); cursor: pointer;" title="Copy"><i class="fa-regular fa-copy"></i></button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Quét Momo QR -->
                    <div style="text-align: center;">
                        <div style="background: #fff; padding: 14px; border-radius: var(--radius-md); display: inline-block; border: 1px solid var(--border-color);">
                            <!-- Mock QR Momo -->
                            <img src="https://api.qrserver.com/v1/create-qr-code/?size=180x180&data=Momo-Payment-FashionShop-Order-${order.id}" style="width: 180px; height: 180px; display: block;" alt="Momo QR Code">
                        </div>
                        <p style="font-size: 0.8rem; color: var(--text-secondary); margin-top: 10px; font-style: italic;">Quét mã bằng ứng dụng Momo</p>
                    </div>
                </div>
            </div>

            <!-- NỘI DUNG TAB 3: VÍ ZALOPAY -->
            <div id="zalopay-tab" class="tab-content" style="display: none;">
                <div style="display: grid; grid-template-columns: 1.2fr 1fr; gap: 24px; align-items: center;">
                    <div>
                        <h4 style="font-size: 1.1rem; font-weight: 700; margin-bottom: 16px; color: #008fe5;">Thanh Toán Qua Ví ZaloPay</h4>
                        
                        <div style="display: flex; flex-direction: column; gap: 12px;">
                            <div style="background-color: var(--bg-tertiary); border: 1px solid var(--border-color); border-radius: var(--radius-sm); padding: 12px 16px;">
                                <div style="font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase;">Tài Khoản ZaloPay</div>
                                <div style="font-weight: 700; font-size: 1.1rem; display: flex; justify-content: space-between; align-items: center;">
                                    <span id="zalo-acc">0346835547</span>
                                    <button onclick="copyText('zalo-acc')" style="background: none; border: none; color: var(--text-secondary); cursor: pointer;" title="Copy"><i class="fa-regular fa-copy"></i></button>
                                </div>
                            </div>
                            <div style="background-color: var(--bg-tertiary); border: 1px solid var(--border-color); border-radius: var(--radius-sm); padding: 12px 16px;">
                                <div style="font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase;">Lời nhắn chuyển tiền</div>
                                <div style="font-weight: 700; color: var(--accent); display: flex; justify-content: space-between; align-items: center;">
                                    <span id="zalo-msg">ZALOPAY FASHIONSHOP ${order.id}</span>
                                    <button onclick="copyText('zalo-msg')" style="background: none; border: none; color: var(--text-secondary); cursor: pointer;" title="Copy"><i class="fa-regular fa-copy"></i></button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Quét ZaloPay QR -->
                    <div style="text-align: center;">
                        <div style="background: #fff; padding: 14px; border-radius: var(--radius-md); display: inline-block; border: 1px solid var(--border-color);">
                            <!-- Mock QR Zalo -->
                            <img src="https://api.qrserver.com/v1/create-qr-code/?size=180x180&data=ZaloPay-Payment-FashionShop-Order-${order.id}" style="width: 180px; height: 180px; display: block;" alt="ZaloPay QR Code">
                        </div>
                        <p style="font-size: 0.8rem; color: var(--text-secondary); margin-top: 10px; font-style: italic;">Quét mã bằng ứng dụng ZaloPay</p>
                    </div>
                </div>
            </div>

            <!-- Thông báo hướng dẫn chờ hệ thống xác nhận thanh toán tự động -->
            <div style="margin-top: 36px; text-align: center; border-top: 1px solid var(--border-color); padding-top: 24px;">
                <div style="display: flex; align-items: center; justify-content: center; gap: 10px; color: var(--accent); font-weight: 700; margin-bottom: 14px; font-size: 1.05rem;">
                    <i class="fa-solid fa-circle-notch fa-spin" style="font-size: 1.25rem;"></i> Hệ thống đang chờ bạn quét mã chuyển tiền...
                </div>
                <p style="font-size: 0.85rem; color: var(--text-secondary); line-height: 1.6; margin-bottom: 24px; max-width: 460px; margin-left: auto; margin-right: auto;">
                    Sau khi bạn chuyển khoản thành công, hệ thống sẽ tự động ghi nhận giao dịch từ ngân hàng/ví điện tử và chuyển bạn về trang quản lý đơn hàng. Vui lòng không đóng trang này!
                </p>
                <div>
                    <a href="${pageContext.request.contextPath}/orders" style="color: var(--text-secondary); font-size: 0.9rem; text-decoration: none;">
                        <i class="fa-solid fa-arrow-left" style="margin-right: 6px;"></i> Quay lại xem lịch sử đơn hàng
                    </a>
                </div>
            </div>

        </div>

        <!-- Cột Bên Phải: Tóm tắt đơn hàng -->
        <div class="summary-card" style="padding: 24px; position: sticky; top: 20px;">
            <h3 style="font-weight: 700; border-bottom: 1px solid var(--border-color); padding-bottom: 12px; margin-bottom: 20px;">
                Tóm tắt đơn hàng
            </h3>
            
            <div style="display: flex; flex-direction: column; gap: 16px; margin-bottom: 20px;">
                <div style="display: flex; justify-content: space-between;">
                    <span style="color: var(--text-secondary);">Mã đơn hàng:</span>
                    <strong style="color: var(--accent);">#${order.id}</strong>
                </div>
                <div style="display: flex; justify-content: space-between;">
                    <span style="color: var(--text-secondary);">Khách hàng:</span>
                    <strong>${order.fullname}</strong>
                </div>
                <div style="display: flex; justify-content: space-between;">
                    <span style="color: var(--text-secondary);">Số điện thoại:</span>
                    <strong>${order.phone}</strong>
                </div>
                <div style="display: flex; flex-direction: column; gap: 4px;">
                    <span style="color: var(--text-secondary);">Địa chỉ nhận hàng:</span>
                    <span style="font-size: 0.9rem; color: var(--text-secondary);">${order.address}</span>
                </div>
            </div>

            <!-- Tổng tiền cần thanh toán -->
            <div style="border-top: 1px dashed var(--border-color); padding-top: 20px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                <span style="font-size: 1.05rem; font-weight: 600;">Tổng thanh toán:</span>
                <strong style="color: var(--accent); font-size: 1.6rem;">
                    <fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                </strong>
            </div>
            
            <div style="color: var(--text-muted); font-size: 0.8rem; text-align: center; margin-top: 12px;">
                <i class="fa-solid fa-lock" style="margin-right: 4px;"></i> Thông tin thanh toán được bảo mật an toàn.
            </div>
        </div>

    </div>
</div>

<style>
    .tab-btn {
        border-bottom: 2px solid transparent !important;
    }
    .tab-btn:hover {
        color: var(--accent) !important;
    }
    .tab-btn.active {
        color: var(--accent) !important;
        border-bottom-color: var(--accent) !important;
    }
</style>

<script>
    function switchTab(tabId) {
        document.querySelectorAll('.tab-content').forEach(function(content) {
            content.style.display = 'none';
        });
        document.querySelectorAll('.tab-btn').forEach(function(btn) {
            btn.classList.remove('active');
        });

        document.getElementById(tabId).style.display = 'block';
        if (tabId === 'bank-tab') {
            document.getElementById('bank-btn').classList.add('active');
        } else if (tabId === 'momo-tab') {
            document.getElementById('momo-btn').classList.add('active');
        } else if (tabId === 'zalopay-tab') {
            document.getElementById('zalopay-btn').classList.add('active');
        }
    }

    function copyText(elementId) {
        var text = document.getElementById(elementId).innerText;
        navigator.clipboard.writeText(text).then(function() {
            alert('Đã copy: ' + text);
        }).catch(function() {
            var input = document.createElement('input');
            input.value = text;
            document.body.appendChild(input);
            input.select();
            document.execCommand('copy');
            document.body.removeChild(input);
            alert('Đã copy: ' + text);
        });
    }

    var timeRemaining = 10 * 60;
    var countdownEl = document.getElementById('countdown');

    var timer = setInterval(function() {
        var minutes = Math.floor(timeRemaining / 60);
        var seconds = timeRemaining % 60;

        minutes = minutes < 10 ? '0' + minutes : minutes;
        seconds = seconds < 10 ? '0' + seconds : seconds;

        countdownEl.innerText = minutes + ':' + seconds;

        if (timeRemaining <= 0) {
            clearInterval(timer);
            countdownEl.innerText = "Hết hạn";
            alert("Đã hết thời gian thực hiện giao dịch thanh toán. Vui lòng thử lại!");
            window.location.href = "${pageContext.request.contextPath}/orders";
        }

        timeRemaining--;
    }, 1000);

    var orderId = ${order.id};
    var contextPath = '${pageContext.request.contextPath}';

    // Chạy ngầm kiểm tra trạng thái thanh toán từ server mỗi 3 giây
    var paymentPollInterval = setInterval(function() {
        checkStatusAndRedirect();
    }, 3000);

    function checkStatusAndRedirect() {
        fetch(contextPath + '/checkout/payment/status?orderId=' + orderId)
            .then(function(response) { return response.json(); })
            .then(function(data) {
                if (data.status === 'PAID') {
                    clearInterval(paymentPollInterval);
                    alert("Thanh toán thành công! Hệ thống đang tự động chuyển hướng...");
                    window.location.href = contextPath + "/orders?success=payment_completed";
                }
            })
            .catch(function(err) {
                console.error("Lỗi kiểm tra trạng thái thanh toán:", err);
            });
    }
</script>


<%@ include file="/WEB-INF/views/footer.jsp" %>
