package poly.java.Entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Size;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.Nationalized;

@Entity
@Table(name = "Banners")
public class Banner {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "BannerID", nullable = false)
    private Integer id;

    @Size(max = 100)
    @Nationalized
    @Column(name = "Title", length = 100)
    private String title;

    @Size(max = 255)
    @Column(name = "ImageURL")
    private String imageURL;

    @Size(max = 255)
    @Column(name = "LinkURL")
    private String linkURL;

    @ColumnDefault("1")
    @Column(name = "Status")
    private Boolean status;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getImageURL() {
        return imageURL;
    }

    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }

    public String getLinkURL() {
        return linkURL;
    }

    public void setLinkURL(String linkURL) {
        this.linkURL = linkURL;
    }

    public Boolean getStatus() {
        return status;
    }

    public void setStatus(Boolean status) {
        this.status = status;
    }

    public String getImageUrl() {
        return imageURL;
    }

    public String getLink() {
        return linkURL != null ? linkURL : "";
    }

}