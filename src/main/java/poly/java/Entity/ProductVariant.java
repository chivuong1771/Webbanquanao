package poly.java.Entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import org.hibernate.annotations.ColumnDefault;

import java.math.BigDecimal;

@Entity
@Table(name = "ProductVariants")
public class ProductVariant {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "VariantID", nullable = false)
    private Integer id;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "ProductID", nullable = false)
    private Product productID;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "ColorID", nullable = false)
    private Color colorID;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "SizeID", nullable = false)
    private poly.java.Entity.Size sizeID;

    @Size(max = 50)
    @Column(name = "SKU", length = 50)
    private String sku;

    @Column(name = "Price", precision = 18, scale = 2)
    private BigDecimal price;

    @ColumnDefault("0")
    @Column(name = "Quantity")
    private Integer quantity;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Product getProductID() {
        return productID;
    }

    public void setProductID(Product productID) {
        this.productID = productID;
    }

    public Color getColorID() {
        return colorID;
    }

    public void setColorID(Color colorID) {
        this.colorID = colorID;
    }

    public poly.java.Entity.Size getSizeID() {
        return sizeID;
    }

    public void setSizeID(poly.java.Entity.Size sizeID) {
        this.sizeID = sizeID;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
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

}