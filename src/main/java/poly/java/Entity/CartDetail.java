package poly.java.Entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "CartDetails")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CartDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "CartDetailID")
    private Integer cartDetailId;

    @ManyToOne
    @JoinColumn(name = "CartID", nullable = false)
    private Cart cart;

    @ManyToOne
    @JoinColumn(name = "VariantID", nullable = false)
    private ProductVariant variant;

    @Column(name = "Quantity")
    private Integer quantity;
}