package poly.java.Entity;

import jakarta.persistence.*;

@Entity
@Table(name = "Sizes")
public class Size {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "SizeID", nullable = false)
    private Integer id;

    @jakarta.validation.constraints.Size(max = 10)
    @Column(name = "SizeName", length = 10)
    private String sizeName;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getSizeName() {
        return sizeName;
    }

    public void setSizeName(String sizeName) {
        this.sizeName = sizeName;
    }

}