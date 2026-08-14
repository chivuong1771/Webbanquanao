package poly.java.Entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.Nationalized;

import java.math.BigDecimal;

@Entity
@Table(name = "Products")
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ProductID", nullable = false)
    private Integer id;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "CategoryID", nullable = false)
    private Category categoryID;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "BrandID", nullable = false)
    private Brand brandID;

    @Size(max = 200)
    @NotNull
    @Nationalized
    @Column(name = "ProductName", nullable = false, length = 200)
    private String productName;

    @Nationalized
    @Lob
    @Column(name = "Description")
    private String description;

    @Size(max = 100)
    @Nationalized
    @Column(name = "Material", length = 100)
    private String material;

    @NotNull
    @Column(name = "Price", nullable = false, precision = 18, scale = 2)
    private BigDecimal price;

    @Column(name = "DiscountPrice", precision = 18, scale = 2)
    private BigDecimal discountPrice;

    @Size(max = 255)
    @Column(name = "Thumbnail")
    private String thumbnail;

    @ColumnDefault("0")
    @Column(name = "SoldQuantity")
    private Integer soldQuantity;

    @ColumnDefault("0")
    @Column(name = "ViewCount")
    private Integer viewCount;

    @ColumnDefault("1")
    @Column(name = "Status")
    private Boolean status;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Category getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(Category categoryID) {
        this.categoryID = categoryID;
    }

    public Brand getBrandID() {
        return brandID;
    }

    public void setBrandID(Brand brandID) {
        this.brandID = brandID;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getMaterial() {
        return material;
    }

    public void setMaterial(String material) {
        this.material = material;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public BigDecimal getDiscountPrice() {
        return discountPrice;
    }

    public void setDiscountPrice(BigDecimal discountPrice) {
        this.discountPrice = discountPrice;
    }

    public String getThumbnail() {
        return thumbnail;
    }

    public String getImageUrl() {
        if (thumbnail != null && !thumbnail.isBlank()) {
            if (thumbnail.startsWith("http://") || thumbnail.startsWith("https://")) {
                return thumbnail;
            }
            if (thumbnail.contains("/")) {
                return thumbnail;
            }
            switch (thumbnail.toLowerCase()) {
                case "ao1.jpg": return "https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=500&auto=format&fit=crop";
                case "ao2.jpg": return "https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=500&auto=format&fit=crop";
                case "ao3.jpg": return "https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=500&auto=format&fit=crop";
                case "ao4.jpg": return "https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=500&auto=format&fit=crop";
                case "ao5.jpg": return "https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=500&auto=format&fit=crop";
                case "ao6.jpg": return "https://images.unsplash.com/photo-1542272604-780c36856d60?w=500&auto=format&fit=crop";
                default: return thumbnail;
            }
        }
        if (productImages != null && !productImages.isEmpty()) {
            for (ProductImage img : productImages) {
                if (img.getImageUrl() != null && !img.getImageUrl().isBlank()) {
                    return img.getImageUrl();
                }
            }
        }
        return "https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=500&auto=format&fit=crop";
    }

    public String getPrimaryImage() {
        return getImageUrl();
    }

    public void setThumbnail(String thumbnail) {
        this.thumbnail = thumbnail;
    }

    public Integer getSoldQuantity() {
        return soldQuantity;
    }

    public void setSoldQuantity(Integer soldQuantity) {
        this.soldQuantity = soldQuantity;
    }

    public Integer getViewCount() {
        return viewCount;
    }

    public void setViewCount(Integer viewCount) {
        this.viewCount = viewCount;
    }

    public Boolean getStatus() {
        return status;
    }

    public void setStatus(Boolean status) {
        this.status = status;
    }

    @OneToMany(mappedBy = "productID", fetch = FetchType.LAZY)
    private java.util.List<ProductVariant> productVariants;

    @OneToMany(mappedBy = "productID", fetch = FetchType.LAZY)
    private java.util.List<ProductImage> productImages;

    public java.util.List<ProductVariant> getProductVariants() {
        return productVariants;
    }

    public void setProductVariants(java.util.List<ProductVariant> productVariants) {
        this.productVariants = productVariants;
    }

    public java.util.List<ProductImage> getProductImages() {
        return productImages;
    }

    public void setProductImages(java.util.List<ProductImage> productImages) {
        this.productImages = productImages;
    }

}