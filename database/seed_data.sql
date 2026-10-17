USE kaipy_ecommerce;

-- 1. Thêm Danh mục
INSERT INTO categories (id, name, slug) VALUES
(1, 'Điện thoại', 'dien-thoai'),
(2, 'Laptop', 'laptop'),
(3, 'Phụ kiện', 'phu-kien');

-- 2. Thêm Sản phẩm mẫu
INSERT INTO products (category_id, name, slug, price, discount_price, stock_quantity, description, specs, image_url) VALUES
(2, 'Laptop ASUS ROG Zephyrus G14', 'laptop-asus-rog-zephyrus-g14', 35990000, 32990000, 10, 'Laptop Gaming mỏng nhẹ, màn hình OLED 120Hz, chip AMD Ryzen 9, RAM 32GB.', '{"cpu": "AMD Ryzen 9", "ram": "32GB", "screen": "14 inch OLED"}', 'https://via.placeholder.com/300'),
(3, 'Tai nghe Sony WH-1000XM5 Chống ồn', 'tai-nghe-sony-wh-1000xm5', 7990000, 7490000, 20, 'Tai nghe chụp tai chống ồn chủ động cao cấp, thời lượng pin 30 giờ.', '{"battery": "30h", "bluetooth": "5.2"}', 'https://via.placeholder.com/300'),
(3, 'Bàn phím cơ Keychron K2 Pro Wireless', 'ban-phim-co-keychron-k2-pro', 2490000, 2150000, 15, 'Bàn phím cơ layout 75%, kết nối Bluetooth/Type-C, gõ êm văn phòng.', '{"switch": "Red/Brown", "layout": "75%"}', 'https://via.placeholder.com/300'),
(3, 'Màn hình Dell UltraSharp U2723QE 4K', 'man-hinh-dell-ultrasharp-u2723qe', 13500000, 12800000, 8, 'Màn hình đồ họa chuyên nghiệp 27 inch 4K IPS Black, độ bao phủ màu 98% DCI-P3.', '{"size": "27 inch", "resolution": "4K"}', 'https://via.placeholder.com/300');

-- 3. Thêm Đánh giá mẫu
INSERT INTO reviews (product_id, user_id, rating, comment) VALUES
(1, 1, 5, 'Máy siêu mỏng nhẹ, màn hình OLED màu lên rất rực rỡ và mượt.'),
(2, 1, 5, 'Chống ồn đỉnh cao, đeo cả ngày không đau tai.');