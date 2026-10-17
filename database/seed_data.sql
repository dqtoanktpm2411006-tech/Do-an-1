USE kaipy_ecommerce;

-- 1. Thêm danh mục sản phẩm (nếu chưa có)
INSERT IGNORE INTO categories (id, name, slug) VALUES
(1, 'Điện thoại', 'dien-thoai'),
(2, 'Laptop', 'laptop'),
(3, 'Phụ kiện', 'phu-kien');

-- 2. Thêm dữ liệu sản phẩm mẫu
INSERT INTO products (category_id, name, slug, price, discount_price, stock_quantity, description, specs, image_url) VALUES
(2, 'Laptop ASUS ROG Zephyrus G14', 'laptop-asus-rog-zephyrus-g14', 35990000, 32990000, 10, 'Laptop Gaming mỏng nhẹ, màn hình OLED 120Hz, chip AMD Ryzen 9, RAM 32GB.', '{"cpu": "AMD Ryzen 9", "ram": "32GB", "screen": "14 inch OLED"}', 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=500&auto=format&fit=crop'),
(3, 'Tai nghe Sony WH-1000XM5 Chống ồn', 'tai-nghe-sony-wh-1000xm5', 7990000, 7490000, 20, 'Tai nghe chụp tai chống ồn chủ động cao cấp, thời lượng pin 30 giờ.', '{"battery": "30h", "bluetooth": "5.2"}', 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&auto=format&fit=crop'),
(3, 'Bàn phím cơ Keychron K2 Pro Wireless', 'ban-phim-co-keychron-k2-pro', 2490000, 2150000, 15, 'Bàn phím cơ layout 75%, kết nối Bluetooth/Type-C, gõ êm văn phòng.', '{"switch": "Red/Brown", "layout": "75%"}', 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=500&auto=format&fit=crop'),
(3, 'Màn hình Dell UltraSharp U2723QE 4K', 'man-hinh-dell-ultrasharp-u2723qe', 13500000, 12800000, 8, 'Màn hình đồ họa chuyên nghiệp 27 inch 4K IPS Black, độ bao phủ màu 98% DCI-P3.', '{"size": "27 inch", "resolution": "4K"}', 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=500&auto=format&fit=crop');