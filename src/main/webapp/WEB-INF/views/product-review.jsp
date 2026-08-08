<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ taglib prefix="c"
           uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="container"
     style="padding-top: 40px; padding-bottom: 60px;">

  <h2 class="section-title">
    Đánh Giá Sản Phẩm
  </h2>

  <p class="section-desc">
    Chia sẻ cảm nhận của bạn về sản phẩm
  </p>


  <!-- FORM ĐÁNH GIÁ -->

  <div class="form-container"
       style="
            max-width: 700px;
            margin: 30px auto;
         ">

    <form
            action="${pageContext.request.contextPath}/review"
            method="POST">

      <input
              type="hidden"
              name="productId"
              value="${productId}"
      >


      <div class="form-group">

        <label>
          Đánh giá
        </label>

        <select
                name="rating"
                class="form-control"
                required>

          <option value="">
            -- Chọn số sao --
          </option>

          <option value="5">
            ★★★★★ - Rất tốt
          </option>

          <option value="4">
            ★★★★☆ - Tốt
          </option>

          <option value="3">
            ★★★☆☆ - Bình thường
          </option>

          <option value="2">
            ★★☆☆☆ - Không tốt
          </option>

          <option value="1">
            ★☆☆☆☆ - Rất tệ
          </option>

        </select>

      </div>


      <div class="form-group">

        <label>
          Nội dung đánh giá
        </label>

        <textarea
                name="comment"
                class="form-control"
                rows="5"
                required
                placeholder="Nhập cảm nhận của bạn..."></textarea>

      </div>


      <button
              type="submit"
              class="btn btn-primary">

        Gửi Đánh Giá

      </button>

    </form>

  </div>


  <!-- DANH SÁCH REVIEW -->

  <div style="max-width: 900px; margin: 50px auto;">

    <h3>
      Đánh Giá Của Khách Hàng
    </h3>


    <c:choose>

      <c:when test="${not empty reviews}">

        <c:forEach
                var="review"
                items="${reviews}">

          <div
                  style="
                                padding: 20px;
                                border-bottom: 1px solid var(--border-color);
                            ">

            <strong>
                ${review.user.fullName}
            </strong>

            <div style="
                            margin-top: 8px;
                            color: #f59e0b;
                        ">

                ${review.rating} / 5 ★

            </div>


            <p style="
                            margin-top: 10px;
                        ">

                ${review.comment}

            </p>


            <small style="
                            color: var(--text-muted);
                        ">

                ${review.createdAt}

            </small>

          </div>

        </c:forEach>

      </c:when>


      <c:otherwise>

        <p style="
                    color: var(--text-secondary);
                    margin-top: 20px;
                ">

          Chưa có đánh giá nào cho sản phẩm này.

        </p>

      </c:otherwise>

    </c:choose>

  </div>

</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>