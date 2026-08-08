package poly.java.Entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;

@Entity
@Table(name = "OrderDetails")
public class OrderDetail {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "OrderDetailID", nullable = false)
    private Integer id;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "OrderID", nullable = false)
    private Order orderID;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "VariantID", nullable = false)
    private ProductVariant variantID;

    @Column(name = "Price", precision = 18, scale = 2)
    private BigDecimal price;

    @Column(name = "Quantity")
    private Integer quantity;

    @Column(name = "Total", precision = 18, scale = 2)
    private BigDecimal total;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Order getOrderID() {
        return orderID;
    }

    public void setOrderID(Order orderID) {
        this.orderID = orderID;
    }

    public ProductVariant getVariantID() {
        return variantID;
    }

    public void setVariantID(ProductVariant variantID) {
        this.variantID = variantID;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getTotal() {
        return total;
    }

    public void setTotal(BigDecimal total) {
        this.total = total;
    }

    public String getProductName() {
        if (variantID != null && variantID.getProductID() != null) {
            return variantID.getProductID().getProductName();
        }
        return "";
    }

    public String getImageUrl() {
        if (variantID != null && variantID.getProductID() != null) {
            return variantID.getProductID().getThumbnail();
        }
        return "";
    }

    public String getColor() {
        if (variantID != null && variantID.getColorID() != null) {
            return variantID.getColorID().getColorName();
        }
        return "";
    }

    public String getSize() {
        if (variantID != null && variantID.getSizeID() != null) {
            return variantID.getSizeID().getSizeName();
        }
        return "";
    }

    public BigDecimal getAmount() {
        if (total != null) {
            return total;
        }
        if (price != null && quantity != null) {
            return price.multiply(BigDecimal.valueOf(quantity));
        }
        return BigDecimal.ZERO;
    }

}