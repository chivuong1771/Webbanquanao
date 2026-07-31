package poly.java.Entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Size;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.Nationalized;

import java.math.BigDecimal;
import java.time.Instant;

@Entity
@Table(name = "Coupons")
public class Coupon {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "CouponID", nullable = false)
    private Integer id;

    @Size(max = 50)
    @Column(name = "Code", length = 50)
    private String code;

    @Size(max = 100)
    @Nationalized
    @Column(name = "CouponName", length = 100)
    private String couponName;

    @Size(max = 20)
    @Column(name = "DiscountType", length = 20)
    private String discountType;

    @Column(name = "DiscountValue", precision = 18, scale = 2)
    private BigDecimal discountValue;

    @Column(name = "MinimumOrder", precision = 18, scale = 2)
    private BigDecimal minimumOrder;

    @Column(name = "Quantity")
    private Integer quantity;

    @Column(name = "StartDate")
    private Instant startDate;

    @Column(name = "EndDate")
    private Instant endDate;

    @ColumnDefault("1")
    @Column(name = "Status")
    private Boolean status;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getCouponName() {
        return couponName;
    }

    public void setCouponName(String couponName) {
        this.couponName = couponName;
    }

    public String getDiscountType() {
        return discountType;
    }

    public void setDiscountType(String discountType) {
        this.discountType = discountType;
    }

    public BigDecimal getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(BigDecimal discountValue) {
        this.discountValue = discountValue;
    }

    public BigDecimal getMinimumOrder() {
        return minimumOrder;
    }

    public void setMinimumOrder(BigDecimal minimumOrder) {
        this.minimumOrder = minimumOrder;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public Instant getStartDate() {
        return startDate;
    }

    public void setStartDate(Instant startDate) {
        this.startDate = startDate;
    }

    public Instant getEndDate() {
        return endDate;
    }

    public void setEndDate(Instant endDate) {
        this.endDate = endDate;
    }

    public Boolean getStatus() {
        return status;
    }

    public void setStatus(Boolean status) {
        this.status = status;
    }

}