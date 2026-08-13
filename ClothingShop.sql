IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'ClothingShop')
BEGIN
    CREATE DATABASE ClothingShop;
END
GO

USE ClothingShop;
GO

-- =========================
-- ROLE
-- =========================
CREATE TABLE Roles (
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE
);

-- =========================
-- USER
-- =========================
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    RoleID INT NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(15),
    Password VARCHAR(255) NOT NULL,
    Gender BIT,
    DateOfBirth DATE,
    Avatar VARCHAR(255),
    Status BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_User_Role
    FOREIGN KEY(RoleID) REFERENCES Roles(RoleID)
);

-- =========================
-- ADDRESS
-- =========================
CREATE TABLE Addresses(
    AddressID INT IDENTITY PRIMARY KEY,
    UserID INT NOT NULL,
    ReceiverName NVARCHAR(100),
    Phone VARCHAR(15),
    Province NVARCHAR(100),
    District NVARCHAR(100),
    Ward NVARCHAR(100),
    AddressDetail NVARCHAR(255),
    IsDefault BIT DEFAULT 0,

    FOREIGN KEY(UserID) REFERENCES Users(UserID)
);

-- =========================
-- CATEGORY
-- =========================
CREATE TABLE Categories(
    CategoryID INT IDENTITY PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    Status BIT DEFAULT 1
);

-- =========================
-- BRAND
-- =========================
CREATE TABLE Brands(
    BrandID INT IDENTITY PRIMARY KEY,
    BrandName NVARCHAR(100) NOT NULL,
    Logo VARCHAR(255),
    Status BIT DEFAULT 1
);

-- =========================
-- PRODUCT
-- =========================
CREATE TABLE Products(
    ProductID INT IDENTITY PRIMARY KEY,
    CategoryID INT NOT NULL,
    BrandID INT NOT NULL,

    ProductName NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX),
    Material NVARCHAR(100),

    Price DECIMAL(18,2) NOT NULL,
    DiscountPrice DECIMAL(18,2),

    Thumbnail VARCHAR(255),

    SoldQuantity INT DEFAULT 0,
    ViewCount INT DEFAULT 0,

    Status BIT DEFAULT 1,

    FOREIGN KEY(CategoryID) REFERENCES Categories(CategoryID),
    FOREIGN KEY(BrandID) REFERENCES Brands(BrandID)
);

-- =========================
-- COLOR
-- =========================
CREATE TABLE Colors(
    ColorID INT IDENTITY PRIMARY KEY,
    ColorName NVARCHAR(50),
    ColorCode VARCHAR(20)
);

-- =========================
-- SIZE
-- =========================
CREATE TABLE Sizes(
    SizeID INT IDENTITY PRIMARY KEY,
    SizeName VARCHAR(10)
);

-- =========================
-- PRODUCT VARIANT
-- =========================
CREATE TABLE ProductVariants(
    VariantID INT IDENTITY PRIMARY KEY,
    ProductID INT NOT NULL,
    ColorID INT NOT NULL,
    SizeID INT NOT NULL,

    SKU VARCHAR(50),

    Price DECIMAL(18,2),

    Quantity INT DEFAULT 0,

    FOREIGN KEY(ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY(ColorID) REFERENCES Colors(ColorID),
    FOREIGN KEY(SizeID) REFERENCES Sizes(SizeID)
);

-- =========================
-- PRODUCT IMAGE
-- =========================
CREATE TABLE ProductImages(
    ImageID INT IDENTITY PRIMARY KEY,
    ProductID INT NOT NULL,
    ImageURL VARCHAR(255),
    IsMain BIT DEFAULT 0,

    FOREIGN KEY(ProductID) REFERENCES Products(ProductID)
);

-- =========================
-- CART
-- =========================
CREATE TABLE Carts(
    CartID INT IDENTITY PRIMARY KEY,
    UserID INT UNIQUE,

    FOREIGN KEY(UserID) REFERENCES Users(UserID)
);

-- =========================
-- CART DETAIL
-- =========================
CREATE TABLE CartDetails(
    CartDetailID INT IDENTITY PRIMARY KEY,
    CartID INT NOT NULL,
    VariantID INT NOT NULL,
    Quantity INT DEFAULT 1,

    FOREIGN KEY(CartID) REFERENCES Carts(CartID),
    FOREIGN KEY(VariantID) REFERENCES ProductVariants(VariantID)
);

-- =========================
-- WISHLIST
-- =========================
CREATE TABLE Wishlist(
    WishlistID INT IDENTITY PRIMARY KEY,
    UserID INT NOT NULL,
    ProductID INT NOT NULL,

    FOREIGN KEY(UserID) REFERENCES Users(UserID),
    FOREIGN KEY(ProductID) REFERENCES Products(ProductID)
);

-- =========================
-- COUPON
-- =========================
CREATE TABLE Coupons(
    CouponID INT IDENTITY PRIMARY KEY,
    Code VARCHAR(50) UNIQUE,
    CouponName NVARCHAR(100),
    DiscountType VARCHAR(20),
    DiscountValue DECIMAL(18,2),
    MinimumOrder DECIMAL(18,2),
    Quantity INT,
    StartDate DATETIME,
    EndDate DATETIME,
    Status BIT DEFAULT 1
);

-- =========================
-- ORDER
-- =========================
CREATE TABLE Orders(
    OrderID INT IDENTITY PRIMARY KEY,
    UserID INT NOT NULL,
    AddressID INT NOT NULL,
    CouponID INT NULL,

    OrderDate DATETIME DEFAULT GETDATE(),

    TotalAmount DECIMAL(18,2),
    DiscountAmount DECIMAL(18,2),
    ShippingFee DECIMAL(18,2),
    FinalAmount DECIMAL(18,2),

    PaymentMethod NVARCHAR(50),
    PaymentStatus NVARCHAR(50),
    OrderStatus NVARCHAR(50),

    Note NVARCHAR(255),

    FOREIGN KEY(UserID) REFERENCES Users(UserID),
    FOREIGN KEY(AddressID) REFERENCES Addresses(AddressID),
    FOREIGN KEY(CouponID) REFERENCES Coupons(CouponID)
);

-- =========================
-- ORDER DETAIL
-- =========================
CREATE TABLE OrderDetails(
    OrderDetailID INT IDENTITY PRIMARY KEY,
    OrderID INT NOT NULL,
    VariantID INT NOT NULL,

    Price DECIMAL(18,2),
    Quantity INT,
    Total DECIMAL(18,2),

    FOREIGN KEY(OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY(VariantID) REFERENCES ProductVariants(VariantID)
);

-- =========================
-- REVIEW
-- =========================
CREATE TABLE Reviews(
    ReviewID INT IDENTITY PRIMARY KEY,
    UserID INT NOT NULL,
    ProductID INT NOT NULL,

    Rating INT CHECK(Rating BETWEEN 1 AND 5),
    Comment NVARCHAR(MAX),

    CreatedAt DATETIME DEFAULT GETDATE(),

    FOREIGN KEY(UserID) REFERENCES Users(UserID),
    FOREIGN KEY(ProductID) REFERENCES Products(ProductID)
);

-- =========================
-- PROMOTION
-- =========================
CREATE TABLE Promotions(
    PromotionID INT IDENTITY PRIMARY KEY,
    PromotionName NVARCHAR(100),
    DiscountType VARCHAR(20),
    DiscountValue DECIMAL(18,2),
    StartDate DATETIME,
    EndDate DATETIME,
    Status BIT DEFAULT 1
);

CREATE TABLE PromotionDetails(
    PromotionDetailID INT IDENTITY PRIMARY KEY,
    PromotionID INT NOT NULL,
    ProductID INT NOT NULL,

    FOREIGN KEY(PromotionID) REFERENCES Promotions(PromotionID),
    FOREIGN KEY(ProductID) REFERENCES Products(ProductID)
);

-- =========================
-- BANNER
-- =========================
CREATE TABLE Banners(
    BannerID INT IDENTITY PRIMARY KEY,
    Title NVARCHAR(100),
    ImageURL VARCHAR(255),
    LinkURL VARCHAR(255),
    Status BIT DEFAULT 1
);

-- =========================
-- SETTINGS
-- =========================
CREATE TABLE Settings(
    SettingID INT IDENTITY PRIMARY KEY,
    SettingKey NVARCHAR(100),
    SettingValue NVARCHAR(MAX)
);

-- =========================
-- INVENTORY HISTORY
-- =========================
CREATE TABLE InventoryHistory(
    HistoryID INT IDENTITY PRIMARY KEY,
    VariantID INT NOT NULL,
    Quantity INT,
    Type NVARCHAR(20),
    CreatedAt DATETIME DEFAULT GETDATE(),

    FOREIGN KEY(VariantID) REFERENCES ProductVariants(VariantID)
);

INSERT INTO Roles(RoleName)
VALUES
('ADMIN'),
('CUSTOMER');

INSERT INTO Users
(RoleID,FullName,Email,Phone,Password,Gender,DateOfBirth,Avatar,Status)
VALUES
(1,N'Administrator','admin@gmail.com','0900000000',
'123456',1,'2000-01-01','admin.png',1),

(2,N'Nguyễn Văn An','an@gmail.com','0901111111',
'123456',1,'2002-05-15','user1.png',1),

(2,N'Trần Thị Bình','binh@gmail.com','0902222222',
'123456',0,'2001-07-20','user2.png',1),

(2,N'Lê Minh Cường','cuong@gmail.com','0903333333',
'123456',1,'2000-03-18','user3.png',1),

(2,N'Phạm Thu Hà','ha@gmail.com','0904444444',
'123456',0,'2003-09-12','user4.png',1),

(2,N'Đỗ Quốc Huy','huy@gmail.com','0905555555',
'123456',1,'2002-12-30','user5.png',1);

INSERT INTO Categories(CategoryName,Description)
VALUES
(N'Áo thun',N'Các loại áo thun'),
(N'Áo sơ mi',N'Các loại áo sơ mi'),
(N'Áo khoác',N'Các loại áo khoác'),
(N'Hoodie',N'Áo hoodie'),
(N'Quần jean',N'Quần jean nam nữ'),
(N'Quần short',N'Quần short'),
(N'Váy',N'Các loại váy'),
(N'Phụ kiện',N'Phụ kiện thời trang');

INSERT INTO Brands(BrandName,Logo)
VALUES
(N'Nike','nike.png'),
(N'Adidas','adidas.png'),
(N'Puma','puma.png'),
(N'Uniqlo','uniqlo.png'),
(N'Routine','routine.png'),
(N'Yody','yody.png'),
(N'H&M','hm.png'),
(N'Zara','zara.png');

INSERT INTO Colors(ColorName,ColorCode)
VALUES
(N'Trắng','#FFFFFF'),
(N'Đen','#000000'),
(N'Đỏ','#FF0000'),
(N'Xanh dương','#0000FF'),
(N'Xanh lá','#008000'),
(N'Vàng','#FFFF00'),
(N'Xám','#808080'),
(N'Hồng','#FFC0CB'),
(N'Nâu','#8B4513'),
(N'Kem','#FFFDD0');

INSERT INTO Sizes(SizeName)
VALUES
('S'),
('M'),
('L'),
('XL'),
('XXL');

INSERT INTO Products
(CategoryID,BrandID,ProductName,Description,Material,Price,DiscountPrice,Thumbnail)
VALUES
(1,1,N'Áo thun Basic Trắng',N'Áo thun cotton basic',N'Cotton 100%',299000,249000,'ao1.jpg'),
(1,2,N'Áo thun Basic Đen',N'Áo thun cotton basic',N'Cotton 100%',299000,249000,'ao2.jpg'),
(2,4,N'Áo sơ mi Oxford',N'Áo sơ mi nam',N'Cotton',499000,449000,'ao3.jpg'),
(3,3,N'Áo khoác Bomber',N'Áo khoác bomber',N'Polyester',899000,799000,'ao4.jpg'),
(4,5,N'Hoodie Basic',N'Hoodie nỉ',N'Nỉ',699000,629000,'ao5.jpg'),
(5,1,N'Quần Jean Slim Fit',N'Jean co giãn',N'Denim',599000,539000,'quan1.jpg'),
(5,2,N'Quần Jean Xanh',N'Jean xanh',N'Denim',629000,569000,'quan2.jpg'),
(6,6,N'Quần Short Kaki',N'Quần short kaki',N'Kaki',399000,349000,'quan3.jpg'),
(7,8,N'Váy Công Sở',N'Váy nữ',N'Kate',699000,629000,'vay1.jpg'),
(1,7,N'Áo thun Oversize',N'Oversize Unisex',N'Cotton',359000,319000,'ao6.jpg');

INSERT INTO ProductVariants(ProductID,ColorID,SizeID,SKU,Price,Quantity)
VALUES
(1,1,2,'AT001-W-M',249000,50),
(1,2,3,'AT001-B-L',249000,40),
(1,2,4,'AT001-B-XL',249000,30),
(1,3,2,'AT001-R-M',249000,20),

(2,2,2,'AT002-B-M',249000,50),
(2,1,3,'AT002-W-L',249000,40),
(2,4,4,'AT002-U-XL',249000,25),
(2,5,2,'AT002-G-M',249000,20),

(3,1,2,'SM001-W-M',449000,20),
(3,2,3,'SM001-B-L',449000,20),
(3,1,4,'SM001-W-XL',449000,15),
(3,3,3,'SM001-R-L',449000,10),

(4,2,3,'AK001-B-L',799000,15),
(4,9,4,'AK001-BR-XL',799000,10),
(4,1,2,'AK001-W-M',799000,15),
(4,8,3,'AK001-P-L',799000,8),

(5,2,3,'HD001-B-L',629000,20),
(5,1,2,'HD001-W-M',629000,25),
(5,4,4,'HD001-U-XL',629000,12),
(5,10,3,'HD001-C-L',629000,15),

(6,4,3,'QJ001-U-L',539000,30),
(6,2,2,'QJ001-B-M',539000,20),
(6,9,4,'QJ001-BR-XL',539000,10),
(6,1,3,'QJ001-W-L',539000,15),

(7,4,2,'QJ002-U-M',569000,20),
(7,2,3,'QJ002-B-L',569000,18),
(7,5,4,'QJ002-G-XL',569000,12),
(7,1,2,'QJ002-W-M',569000,10),

(8,10,2,'QS001-C-M',349000,30),
(8,2,3,'QS001-B-L',349000,25),
(8,9,4,'QS001-BR-XL',349000,20),
(8,5,2,'QS001-G-M',349000,18),

(9,8,2,'V001-P-M',629000,15),
(9,2,3,'V001-B-L',629000,12),
(9,1,2,'V001-W-M',629000,10),
(9,3,3,'V001-R-L',629000,8),

(10,2,3,'AT003-B-L',319000,40),
(10,1,2,'AT003-W-M',319000,35),
(10,5,4,'AT003-G-XL',319000,20),
(10,3,3,'AT003-R-L',319000,18);

INSERT INTO ProductImages(ProductID,ImageURL,IsMain)
VALUES
(1,'ao1_1.jpg',1),
(1,'ao1_2.jpg',0),

(2,'ao2_1.jpg',1),
(2,'ao2_2.jpg',0),

(3,'ao3_1.jpg',1),
(3,'ao3_2.jpg',0),

(4,'ao4_1.jpg',1),
(4,'ao4_2.jpg',0),

(5,'ao5_1.jpg',1),
(5,'ao5_2.jpg',0),

(6,'quan1_1.jpg',1),
(6,'quan1_2.jpg',0),

(7,'quan2_1.jpg',1),
(7,'quan2_2.jpg',0),

(8,'quan3_1.jpg',1),
(8,'quan3_2.jpg',0),

(9,'vay1_1.jpg',1),
(9,'vay1_2.jpg',0),

(10,'ao6_1.jpg',1),
(10,'ao6_2.jpg',0);

INSERT INTO Addresses
(UserID,ReceiverName,Phone,Province,District,Ward,AddressDetail,IsDefault)
VALUES
(2,N'Nguyễn Văn An','0901111111',N'Hồ Chí Minh',N'Quận 1',N'Bến Nghé',N'12 Nguyễn Huệ',1),
(3,N'Trần Thị Bình','0902222222',N'Hồ Chí Minh',N'Quận 7',N'Tân Phú',N'45 Nguyễn Thị Thập',1),
(4,N'Lê Minh Cường','0903333333',N'Hà Nội',N'Cầu Giấy',N'Dịch Vọng',N'120 Xuân Thủy',1),
(5,N'Phạm Thu Hà','0904444444',N'Đà Nẵng',N'Hải Châu',N'Thạch Thang',N'18 Lê Duẩn',1),
(6,N'Đỗ Quốc Huy','0905555555',N'Cần Thơ',N'Ninh Kiều',N'An Hòa',N'88 Mậu Thân',1);

INSERT INTO Carts(UserID)
VALUES
(2),
(3),
(4),
(5),
(6);

INSERT INTO CartDetails(CartID,VariantID,Quantity)
VALUES
(1,1,2),
(1,5,1),

(2,8,2),
(2,12,1),

(3,15,1),
(3,22,2),

(4,28,1),
(4,35,3),

(5,39,1),
(5,40,2);

INSERT INTO Wishlist(UserID,ProductID)
VALUES
(2,4),
(2,7),
(3,5),
(3,10),
(4,1),
(4,9),
(5,2),
(5,8),
(6,3),
(6,6);

INSERT INTO Coupons
(Code,CouponName,DiscountType,DiscountValue,MinimumOrder,Quantity,StartDate,EndDate,Status)
VALUES
('WELCOME10',N'Giảm 10%', 'PERCENT',10,500000,100,'2026-01-01','2026-12-31',1),

('SALE50',N'Giảm 50K','AMOUNT',50000,300000,200,'2026-01-01','2026-12-31',1),

('VIP15',N'Khách VIP','PERCENT',15,1000000,50,'2026-01-01','2026-12-31',1),

('FREESHIP',N'Miễn phí ship','AMOUNT',30000,200000,500,'2026-01-01','2026-12-31',1),

('SUMMER20',N'Summer Sale','PERCENT',20,800000,100,'2026-06-01','2026-08-31',1);

INSERT INTO Promotions
(PromotionName, DiscountType, DiscountValue, StartDate, EndDate, Status)
VALUES
(N'Khai trương', 'PERCENT', 10, '2026-01-01', '2026-12-31', 1),
(N'Summer Sale', 'PERCENT', 20, '2026-06-01', '2026-08-31', 1),
(N'Flash Sale', 'AMOUNT', 50000, '2026-07-01', '2026-07-31', 1);

INSERT INTO PromotionDetails(PromotionID, ProductID)
VALUES
(1,1),
(1,2),
(1,3),
(2,4),
(2,5),
(2,6),
(3,7),
(3,8),
(3,9),
(3,10);

INSERT INTO Orders
(UserID, AddressID, CouponID, TotalAmount, DiscountAmount,
ShippingFee, FinalAmount, PaymentMethod, PaymentStatus,
OrderStatus, Note)
VALUES

(2,1,1,898000,89800,30000,838200,
N'COD',N'Chưa thanh toán',N'Đã giao',N''),

(3,2,2,1248000,50000,30000,1228000,
N'VNPAY',N'Đã thanh toán',N'Đang giao',N''),

(4,3,NULL,629000,0,30000,659000,
N'COD',N'Chưa thanh toán',N'Chờ xác nhận',N''),

(5,4,5,1398000,279600,30000,1148400,
N'MOMO',N'Đã thanh toán',N'Đã giao',N''),

(6,5,NULL,349000,0,30000,379000,
N'COD',N'Chưa thanh toán',N'Đã hủy',N'Khách yêu cầu hủy');

INSERT INTO OrderDetails
(OrderID, VariantID, Price, Quantity, Total)
VALUES

(1,1,249000,2,498000),
(1,13,799000,1,799000),

(2,18,629000,1,629000),
(2,22,539000,1,539000),

(3,35,629000,1,629000),

(4,39,319000,2,638000),
(4,25,569000,2,1138000),

(5,30,349000,1,349000);

INSERT INTO Reviews
(UserID, ProductID, Rating, Comment)
VALUES

(2,1,5,N'Chất vải rất đẹp, mặc thoải mái.'),
(3,4,4,N'Áo khoác đẹp nhưng hơi dày.'),
(4,6,5,N'Quần jean vừa vặn, đáng tiền.'),
(5,10,5,N'Oversize đúng form.'),
(6,8,3,N'Màu hơi khác hình.');

INSERT INTO Banners
(Title, ImageURL, LinkURL, Status)
VALUES
(N'Khai trương','banner1.jpg','/sale',1),
(N'Summer Sale','banner2.jpg','/summer',1),
(N'Flash Sale','banner3.jpg','/flash-sale',1);

INSERT INTO Settings
(SettingKey, SettingValue)
VALUES
('WebsiteName','Clothing Shop'),
('Phone','0900000000'),
('Email','support@clothingshop.com'),
('Address',N'Hồ Chí Minh'),
('Facebook','https://facebook.com/clothingshop');

INSERT INTO InventoryHistory
(VariantID, Quantity, Type)
VALUES

(1,50,'Import'),
(2,40,'Import'),
(3,30,'Import'),
(4,20,'Import'),
(5,50,'Import'),
(6,40,'Import'),
(7,25,'Import'),
(8,20,'Import'),
(9,-2,'Export'),
(10,-1,'Export'),
(11,-1,'Export'),
(12,-3,'Export'),
(13,-1,'Export'),
(14,-2,'Export'),
(15,-1,'Export'),
(16,-1,'Export');

-- =========================
-- PAYMENTS
-- =========================
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    TransactionCode VARCHAR(100) UNIQUE,
    PaymentMethod NVARCHAR(50) NOT NULL,
    Amount DECIMAL(18,2) NOT NULL,
    Status NVARCHAR(50) NOT NULL,
    PaymentDate DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Payment_Order
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

INSERT INTO Payments
(OrderID, TransactionCode, PaymentMethod, Amount, Status)
VALUES
(1, 'COD000001', N'COD', 838200, N'Chờ thanh toán'),
(2, 'VNP000001', N'VNPAY', 1228000, N'Thành công'),
(3, 'COD000002', N'COD', 659000, N'Chờ thanh toán'),
(4, 'MOMO000001', N'MOMO', 1148400, N'Thành công'),
(5, 'COD000003', N'COD', 379000, N'Đã hoàn tiền');

-- =========================
-- ORDER STATUS HISTORY
-- =========================
CREATE TABLE OrderStatusHistory (
    HistoryID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    Status NVARCHAR(50) NOT NULL,
    ChangedAt DATETIME DEFAULT GETDATE(),
    ChangedBy INT NOT NULL,

    CONSTRAINT FK_StatusHistory_Order
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),

    CONSTRAINT FK_StatusHistory_User
    FOREIGN KEY (ChangedBy) REFERENCES Users(UserID)
);

INSERT INTO OrderStatusHistory
(OrderID, Status, ChangedBy)
VALUES
(1, N'Chờ xác nhận', 1),
(1, N'Đã xác nhận', 1),
(1, N'Đang giao', 1),
(1, N'Đã giao', 1),

(2, N'Chờ xác nhận', 1),
(2, N'Đã xác nhận', 1),
(2, N'Đang giao', 1),

(3, N'Chờ xác nhận', 1),

(4, N'Chờ xác nhận', 1),
(4, N'Đã xác nhận', 1),
(4, N'Đang giao', 1),
(4, N'Đã giao', 1),

(5, N'Chờ xác nhận', 1),
(5, N'Đã hủy', 1);
