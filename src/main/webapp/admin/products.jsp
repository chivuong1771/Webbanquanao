<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Sản Phẩm - Admin Panel</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=2">
</head>
<body class="admin-layout">

    <!-- Sidebar Admin -->
    <aside class="admin-sidebar">
        <div class="logo" style="margin-bottom: 30px;">
            PANEL ADMIN
        </div>
        <div style="color: var(--text-muted); font-size: 0.8rem; text-transform: uppercase; font-weight: 700; letter-spacing: 1px;">
            QUẢN LÝ HỆ THỐNG
        </div>
        <nav class="admin-menu">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-menu-item">
                <i class="fa-solid fa-chart-pie"></i> Tổng quan
            </a>
            <a href="${pageContext.request.contextPath}/admin/products" class="admin-menu-item active">
                <i class="fa-solid fa-shirt"></i> Sản phẩm
            </a>
            <a href="${pageContext.request.contextPath}/admin/orders" class="admin-menu-item">
                <i class="fa-solid fa-receipt"></i> Đơn hàng
            </a>
            <a href="${pageContext.request.contextPath}/" class="admin-menu-item" style="margin-top: 40px; border-top: 1px solid var(--border-color); padding-top: 20px; color: var(--accent);">
                <i class="fa-solid fa-store"></i> Về Cửa Hàng
            </a>
        </nav>
    </aside>

    <!-- Main Content -->
    <main class="admin-main">
        <header style="background: transparent; border: none; padding: 0; margin-bottom: 40px; position: static;">
            <div style="display: flex; justify-content: space-between; align-items: center;">
                <div>
                    <h1 style="font-size: 2rem; font-weight: 800;">Quản Lý Sản Phẩm</h1>
                    <p style="color: var(--text-secondary);">Xem danh sách sản phẩm thời trang và cập nhật trạng thái kho hàng</p>
                </div>
                <div>
                    <button class="btn btn-primary" onclick="openAddModal()" style="padding: 10px 20px; font-size: 0.9rem;">
                        <i class="fa-solid fa-plus" style="margin-right: 6px;"></i> Thêm Sản Phẩm Mới
                    </button>
                </div>
            </div>
        </header>

        <div style="background-color: var(--bg-secondary); border-radius: var(--radius-md); border: 1px solid var(--border-color); padding: 24px; overflow-x: auto;">
            <table class="orders-table" style="width: 100%; border-collapse: collapse; border: none;">
                <thead>
                    <tr style="border-bottom: 1px solid var(--border-color);">
                        <th style="border: none; padding: 16px; color: var(--text-secondary); width: 80px;">Hình ảnh</th>
                        <th style="border: none; padding: 16px; color: var(--text-secondary);">Mã SP</th>
                        <th style="border: none; padding: 16px; color: var(--text-secondary);">Tên Sản Phẩm</th>
                        <th style="border: none; padding: 16px; color: var(--text-secondary);">Phân Loại</th>
                        <th style="border: none; padding: 16px; color: var(--text-secondary);">Đơn Giá</th>
                        <th style="border: none; padding: 16px; color: var(--text-secondary);">Giá Giảm</th>
                        <th style="border: none; padding: 16px; color: var(--text-secondary);">Nhãn</th>
                        <th style="border: none; padding: 16px; color: var(--text-secondary);">Trạng Thái</th>
                        <th style="border: none; padding: 16px; color: var(--text-secondary); text-align: center; width: 120px;">Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="prod" items="${products}">
                        <tr style="border-bottom: 1px solid var(--border-color); font-size: 0.95rem;">
                            <td style="border: none; padding: 12px 16px;">
                                <div style="width: 50px; height: 60px; border-radius: var(--radius-sm); overflow: hidden; background-color: var(--bg-tertiary);">
                                    <img src="${prod.imageUrl}" onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=500&auto=format&fit=crop';" style="width: 100%; height: 100%; object-fit: cover;">
                                </div>
                            </td>
                            <td style="border: none; padding: 20px 16px; font-weight: 600;">#${prod.id}</td>
                            <td style="border: none; padding: 20px 16px;">
                                <div style="font-weight: 600;">${prod.name}</div>
                                <div style="color: var(--text-muted); font-size: 0.8rem;">Thương hiệu: ${prod.brandName}</div>
                            </td>
                            <td style="border: none; padding: 20px 16px;">${prod.categoryName}</td>
                            <td style="border: none; padding: 20px 16px; font-weight: 600;">
                                <fmt:formatNumber value="${prod.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                            </td>
                            <td style="border: none; padding: 20px 16px; font-weight: 600; color: #ef4444;">
                                <c:choose>
                                    <c:when test="${prod.discountPrice != null && prod.discountPrice > 0}">
                                        <fmt:formatNumber value="${prod.discountPrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: var(--text-muted); font-weight: 400; font-size: 0.85rem;">Không có</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="border: none; padding: 20px 16px; display: flex; gap: 6px; flex-wrap: wrap; border: none; min-height: 60px; align-items: center;">
                                <c:if test="${prod.isNew}">
                                    <span style="font-size: 0.7rem; font-weight: 700; background-color: rgba(59, 130, 246, 0.15); color: #3b82f6; padding: 2px 6px; border-radius: 4px;">NEW</span>
                                </c:if>
                                <c:if test="${prod.isBestSeller}">
                                    <span style="font-size: 0.7rem; font-weight: 700; background-color: rgba(245, 158, 11, 0.15); color: #f59e0b; padding: 2px 6px; border-radius: 4px;">HOT</span>
                                </c:if>
                            </td>
                            <td style="border: none; padding: 20px 16px;">
                                <span class="badge-status" style="font-size: 0.75rem; background-color: ${'ACTIVE'.equalsIgnoreCase(prod.status) ? 'rgba(16, 185, 129, 0.15)' : 'rgba(239, 68, 68, 0.15)'}; color: ${'ACTIVE'.equalsIgnoreCase(prod.status) ? '#10b981' : '#ef4444'};">
                                    ${'ACTIVE'.equalsIgnoreCase(prod.status) ? 'Đang bán' : 'Ngừng bán'}
                                </span>
                            </td>
                            <td style="border: none; padding: 20px 16px; text-align: center;">
                                <div style="display: flex; gap: 12px; justify-content: center; align-items: center;">
                                    <button onclick="openEditModal({
                                        id: '${prod.id}',
                                        name: '${prod.name.replace("'", "\\'")}',
                                        description: '${prod.description.replace("'", "\\'")}',
                                        price: '${prod.price}',
                                        discountPrice: '${prod.discountPrice != null ? prod.discountPrice : ""}',
                                        brandId: '${prod.brandId}',
                                        categoryId: '${prod.categoryId}',
                                        isNew: ${prod.isNew},
                                        isBestSeller: ${prod.isBestSeller},
                                        status: '${prod.status}',
                                        imageUrl: '${prod.primaryImage != null ? prod.primaryImage : ""}'
                                    })" style="background: none; border: none; color: var(--accent); cursor: pointer; font-size: 1.1rem; padding: 4px;" title="Sửa">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                    </button>
                                    <a href="${pageContext.request.contextPath}/admin/products/delete?id=${prod.id}" onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này?')" style="color: #ef4444; font-size: 1.1rem; padding: 4px;" title="Xóa">
                                        <i class="fa-solid fa-trash"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </main>

<!-- Modal Popup Form (Add/Edit Product) -->
<div id="productModal" class="modal-overlay" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.85); backdrop-filter: blur(8px); -webkit-backdrop-filter: blur(8px); z-index: 2000; justify-content: center; align-items: center;">
    <div style="background-color: var(--bg-secondary); border: 1px solid var(--border-color); border-radius: var(--radius-lg); width: 100%; max-width: 560px; padding: 36px; box-shadow: var(--shadow-lg); position: relative; animation: slideUp 0.4s cubic-bezier(0.16, 1, 0.3, 1);">
        <button onclick="closeModal()" style="position: absolute; top: 20px; right: 20px; color: var(--text-secondary); font-size: 1.5rem; cursor: pointer; background: none; border: none;">&times;</button>
        
        <h2 id="modalTitle" style="font-size: 1.8rem; font-weight: 800; margin-bottom: 24px; color: var(--accent);">Thêm Sản Phẩm Mới</h2>
        
        <form id="productForm" method="POST" action="" enctype="multipart/form-data">
            <input type="hidden" id="prodId" name="id" value="">
            
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                <div class="form-group" style="grid-column: span 2; margin-bottom: 0;">
                    <label class="form-label">Tên sản phẩm *</label>
                    <input type="text" id="prodName" name="name" class="form-control" style="width: 100%;" required>
                </div>
                
                <div class="form-group" style="margin-bottom: 0;">
                    <label class="form-label">Danh mục *</label>
                    <select id="prodCategory" name="categoryId" class="form-control" style="width: 100%; background: var(--bg-primary);" required>
                        <c:forEach var="cat" items="${applicationScope.categories}">
                            <option value="${cat.id}">${cat.name}</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="form-group" style="margin-bottom: 0;">
                    <label class="form-label">Thương hiệu *</label>
                    <select id="prodBrand" name="brandId" class="form-control" style="width: 100%; background: var(--bg-primary);" required>
                        <c:forEach var="br" items="${applicationScope.brands}">
                            <option value="${br.id}">${br.name}</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="form-group" style="margin-bottom: 0;">
                    <label class="form-label">Đơn giá (đ) *</label>
                    <input type="number" id="prodPrice" name="price" class="form-control" style="width: 100%;" min="0" step="1000" required>
                </div>
                
                <div class="form-group" style="margin-bottom: 0;">
                    <label class="form-label">Giá khuyến mãi (đ)</label>
                    <input type="number" id="prodDiscountPrice" name="discountPrice" class="form-control" style="width: 100%;" min="0" step="1000">
                </div>
                
                <div class="form-group" style="grid-column: span 2; margin-bottom: 0;">
                    <label class="form-label">Mô tả sản phẩm</label>
                    <textarea id="prodDescription" name="description" class="form-control" style="width: 100%; height: 80px; resize: none;"></textarea>
                </div>

                <div class="form-group" style="grid-column: span 2; margin-bottom: 0;">
                    <label class="form-label" style="font-weight: 700; color: var(--text-primary);">Hình Ảnh Sản Phẩm</label>
                    <div style="display: flex; gap: 10px; margin-bottom: 10px;">
                        <button type="button" id="btnTabUrl" onclick="toggleImgSource('url')" style="padding: 6px 14px; font-size: 0.85rem; border-radius: 6px; border: 1px solid var(--accent); background: var(--accent); color: #000; font-weight: 700; cursor: pointer;">Dán Link URL</button>
                        <button type="button" id="btnTabFile" onclick="toggleImgSource('file')" style="padding: 6px 14px; font-size: 0.85rem; border-radius: 6px; border: 1px solid var(--border-color); background: var(--bg-tertiary); color: var(--text-primary); font-weight: 600; cursor: pointer;">Tải Ảnh Từ Máy Tính</button>
                    </div>

                    <div id="boxUrlInput">
                        <input type="text" id="prodImageUrl" name="imageUrl" class="form-control" style="width: 100%;" placeholder="Dán link ảnh (https://...)" oninput="updatePreview(this.value)">
                    </div>

                    <div id="boxFileInput" style="display: none;">
                        <input type="file" id="prodImageFile" name="imageFile" accept="image/*" class="form-control" style="width: 100%; padding: 8px;" onchange="previewSelectedFile(this)">
                    </div>

                    <div style="margin-top: 10px; text-align: center;">
                        <img id="prodImagePreview" src="https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=500&auto=format&fit=crop" onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=500&auto=format&fit=crop';" style="max-height: 100px; border-radius: 6px; object-fit: cover; border: 1px solid var(--border-color); display: inline-block;">
                    </div>
                </div>
                
                <div class="form-group" style="margin-bottom: 0;">
                    <label class="form-label">Trạng thái</label>
                    <select id="prodStatus" name="status" class="form-control" style="width: 100%; background: var(--bg-primary);">
                        <option value="ACTIVE">Đang bán</option>
                        <option value="INACTIVE">Ngừng bán</option>
                    </select>
                </div>

                <div style="display: flex; flex-direction: column; gap: 10px; justify-content: center; padding-top: 10px;">
                    <label style="display: flex; align-items: center; gap: 8px; font-size: 0.95rem; cursor: pointer; color: var(--text-secondary);">
                        <input type="checkbox" id="prodIsNew" name="isNew" value="true"> Mới (NEW)
                    </label>
                    <label style="display: flex; align-items: center; gap: 8px; font-size: 0.95rem; cursor: pointer; color: var(--text-secondary);">
                        <input type="checkbox" id="prodIsBestSeller" name="isBestSeller" value="true"> Bán chạy (HOT)
                    </label>
                </div>
            </div>
            
            <div style="display: flex; justify-content: flex-end; gap: 12px; margin-top: 28px;">
                <button type="button" onclick="closeModal()" class="btn btn-secondary" style="padding: 10px 20px; font-size: 0.9rem;">Hủy</button>
                <button type="submit" class="btn btn-primary" style="padding: 10px 24px; font-size: 0.9rem;">Lưu</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openAddModal() {
        document.getElementById("modalTitle").innerText = "Thêm Sản Phẩm Mới";
        document.getElementById("productForm").action = "${pageContext.request.contextPath}/admin/products/add";
        document.getElementById("prodId").value = "";
        document.getElementById("prodName").value = "";
        document.getElementById("prodCategory").value = document.getElementById("prodCategory").options[0].value;
        document.getElementById("prodBrand").value = document.getElementById("prodBrand").options[0].value;
        document.getElementById("prodPrice").value = "";
        document.getElementById("prodDiscountPrice").value = "";
        document.getElementById("prodDescription").value = "";
        document.getElementById("prodImageUrl").value = "assets/images/placeholder.svg";
        document.getElementById("prodStatus").value = "ACTIVE";
        document.getElementById("prodIsNew").checked = false;
        document.getElementById("prodIsBestSeller").checked = false;
        
        toggleImgSource('url');
        document.getElementById("prodImagePreview").src = "https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=500&auto=format&fit=crop";
        document.getElementById("productModal").style.display = "flex";
    }

    function openEditModal(prod) {
        document.getElementById("modalTitle").innerText = "Chỉnh Sửa Sản Phẩm";
        document.getElementById("productForm").action = "${pageContext.request.contextPath}/admin/products/edit";
        document.getElementById("prodId").value = prod.id;
        document.getElementById("prodName").value = prod.name;
        document.getElementById("prodCategory").value = prod.categoryId;
        document.getElementById("prodBrand").value = prod.brandId;
        document.getElementById("prodPrice").value = parseInt(prod.price);
        document.getElementById("prodDiscountPrice").value = prod.discountPrice ? parseInt(prod.discountPrice) : "";
        document.getElementById("prodDescription").value = prod.description;
        document.getElementById("prodImageUrl").value = prod.imageUrl;
        document.getElementById("prodStatus").value = prod.status;
        document.getElementById("prodIsNew").checked = prod.isNew;
        document.getElementById("prodIsBestSeller").checked = prod.isBestSeller;
        
        toggleImgSource('url');
        updatePreview(prod.imageUrl);
        document.getElementById("productModal").style.display = "flex";
    }

    function toggleImgSource(mode) {
        if (mode === 'url') {
            document.getElementById('boxUrlInput').style.display = 'block';
            document.getElementById('boxFileInput').style.display = 'none';
            document.getElementById('btnTabUrl').style.background = 'var(--accent)';
            document.getElementById('btnTabUrl').style.color = '#000';
            document.getElementById('btnTabFile').style.background = 'var(--bg-tertiary)';
            document.getElementById('btnTabFile').style.color = 'var(--text-primary)';
        } else {
            document.getElementById('boxUrlInput').style.display = 'none';
            document.getElementById('boxFileInput').style.display = 'block';
            document.getElementById('btnTabFile').style.background = 'var(--accent)';
            document.getElementById('btnTabFile').style.color = '#000';
            document.getElementById('btnTabUrl').style.background = 'var(--bg-tertiary)';
            document.getElementById('btnTabUrl').style.color = 'var(--text-primary)';
        }
    }

    function updatePreview(url) {
        if (url && url.trim() !== '') {
            document.getElementById('prodImagePreview').src = url;
        } else {
            document.getElementById('prodImagePreview').src = 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=500&auto=format&fit=crop';
        }
    }

    function previewSelectedFile(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('prodImagePreview').src = e.target.result;
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

    function closeModal() {
        document.getElementById("productModal").style.display = "none";
    }
</script>
</body>
</html>
