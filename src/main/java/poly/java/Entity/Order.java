package poly.java.Entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.Nationalized;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "Orders")
public class Order {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "OrderID", nullable = false)
    private Integer id;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "UserID", nullable = false)
    private User userID;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "AddressID", nullable = false)
    private Address addressID;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CouponID")
    private Coupon couponID;

    @ColumnDefault("getdate()")
    @Column(name = "OrderDate")
    private Instant orderDate;

    @Column(name = "TotalAmount", precision = 18, scale = 2)
    private BigDecimal totalAmount;

    @Column(name = "DiscountAmount", precision = 18, scale = 2)
    private BigDecimal discountAmount;

    @Column(name = "ShippingFee", precision = 18, scale = 2)
    private BigDecimal shippingFee;

    @Column(name = "FinalAmount", precision = 18, scale = 2)
    private BigDecimal finalAmount;

    @Size(max = 50)
    @Nationalized
    @Column(name = "PaymentMethod", length = 50)
    private String paymentMethod;

    @Size(max = 50)
    @Nationalized
    @Column(name = "PaymentStatus", length = 50)
    private String paymentStatus;

    @Size(max = 50)
    @Nationalized
    @Column(name = "OrderStatus", length = 50)
    private String orderStatus;

    @Size(max = 255)
    @Nationalized
    @Column(name = "Note")
    private String note;

    @OneToMany(mappedBy = "orderID", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<OrderDetail> orderDetails;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public User getUserID() {
        return userID;
    }

    public void setUserID(User userID) {
        this.userID = userID;
    }

    public Address getAddressID() {
        return addressID;
    }

    public void setAddressID(Address addressID) {
        this.addressID = addressID;
    }

    public Coupon getCouponID() {
        return couponID;
    }

    public void setCouponID(Coupon couponID) {
        this.couponID = couponID;
    }

    public Instant getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Instant orderDate) {
        this.orderDate = orderDate;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }

    public BigDecimal getShippingFee() {
        return shippingFee;
    }

    public void setShippingFee(BigDecimal shippingFee) {
        this.shippingFee = shippingFee;
    }

    public BigDecimal getFinalAmount() {
        return finalAmount;
    }

    public void setFinalAmount(BigDecimal finalAmount) {
        this.finalAmount = finalAmount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public List<OrderDetail> getOrderDetails() {
        return orderDetails;
    }

    public void setOrderDetails(List<OrderDetail> orderDetails) {
        this.orderDetails = orderDetails;
    }

    public Date getCreatedAt() {
        return orderDate != null ? Date.from(orderDate) : new Date();
    }

    public BigDecimal getTotalPrice() {
        return finalAmount != null ? finalAmount : (totalAmount != null ? totalAmount : BigDecimal.ZERO);
    }

    public String getFullname() {
        if (addressID != null && addressID.getReceiverName() != null && !addressID.getReceiverName().isBlank()) {
            return addressID.getReceiverName();
        }
        if (userID != null && userID.getFullName() != null) {
            return userID.getFullName();
        }
        return "";
    }

    public String getPhone() {
        if (addressID != null && addressID.getPhone() != null && !addressID.getPhone().isBlank()) {
            return addressID.getPhone();
        }
        if (userID != null && userID.getPhone() != null) {
            return userID.getPhone();
        }
        return "";
    }

    public String getAddress() {
        if (addressID != null) {
            StringBuilder sb = new StringBuilder();
            if (addressID.getAddressDetail() != null && !addressID.getAddressDetail().isBlank()) {
                sb.append(addressID.getAddressDetail());
            }
            if (addressID.getWard() != null && !addressID.getWard().isBlank()) {
                if (sb.length() > 0) sb.append(", ");
                sb.append(addressID.getWard());
            }
            if (addressID.getDistrict() != null && !addressID.getDistrict().isBlank()) {
                if (sb.length() > 0) sb.append(", ");
                sb.append(addressID.getDistrict());
            }
            if (addressID.getProvince() != null && !addressID.getProvince().isBlank()) {
                if (sb.length() > 0) sb.append(", ");
                sb.append(addressID.getProvince());
            }
            return sb.toString();
        }
        return "";
    }

    public String getUsername() {
        if (userID != null && userID.getEmail() != null) {
            return userID.getEmail().split("@")[0];
        }
        return "";
    }

}