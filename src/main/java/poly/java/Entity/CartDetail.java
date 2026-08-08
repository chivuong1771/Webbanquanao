package poly.java.Entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import org.hibernate.annotations.ColumnDefault;

@Entity
@Table(name = "CartDetails")
public class CartDetail {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "CartDetailID", nullable = false)
    private Integer id;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "CartID", nullable = false)
    private Cart cartID;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "VariantID", nullable = false)
    private ProductVariant variantID;

    @ColumnDefault("1")
    @Column(name = "Quantity")
    private Integer quantity;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Cart getCartID() {
        return cartID;
    }

    public void setCartID(Cart cartID) {
        this.cartID = cartID;
    }

    public ProductVariant getVariantID() {
        return variantID;
    }

    public void setVariantID(ProductVariant variantID) {
        this.variantID = variantID;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public Integer getProductId() {
        if (variantID != null && variantID.getProductID() != null) {
            return variantID.getProductID().getId();
        }
        return null;
    }

    public String getProductName() {
        if (variantID != null && variantID.getProductID() != null) {
            return variantID.getProductID().getProductName();
        }
        return "";
    }

    public java.math.BigDecimal getActualPrice() {
        if (variantID != null && variantID.getProductID() != null) {
            if (variantID.getProductID().getDiscountPrice() != null && variantID.getProductID().getDiscountPrice().compareTo(java.math.BigDecimal.ZERO) > 0) {
                return variantID.getProductID().getDiscountPrice();
            }
            return variantID.getProductID().getPrice();
        }
        return java.math.BigDecimal.ZERO;
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

    public String getImageUrl() {
        if (variantID != null && variantID.getProductID() != null) {
            return variantID.getProductID().getThumbnail();
        }
        return "";
    }

    public java.math.BigDecimal getTotalAmount() {
        java.math.BigDecimal price = getActualPrice();
        if (price != null && quantity != null) {
            return price.multiply(java.math.BigDecimal.valueOf(quantity));
        }
        return java.math.BigDecimal.ZERO;
    }

}