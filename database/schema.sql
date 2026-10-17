-- 1. Tạo CSDL kaipy_ecommerce
CREATE DATABASE IF NOT EXISTS kaipy_ecommerce CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE kaipy_ecommerce;

-- 2. Bảng Danh mục sản phẩm (Categories)
CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Bảng Người dùng (Users: Khách hàng & Admin)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role ENUM('customer', 'admin') DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Bảng Sản phẩm (Products)
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    price DECIMAL(12,2) NOT NULL,
    discount_price DECIMAL(12,2),
    stock_quantity INT DEFAULT 0,
    description TEXT,
    specs JSON, -- Lưu cấu hình kỹ thuật dạng JSON
    image_url VARCHAR(550),
    is_indexed_vector BOOLEAN DEFAULT FALSE, -- Cờ đánh dấu đã đưa vào ChromaDB chưa
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
);

-- 5. Bảng Sổ địa chỉ giao hàng (User Addresses)
CREATE TABLE IF NOT EXISTS user_addresses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    recipient_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address_line VARCHAR(255) NOT NULL,
    is_default BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 6. Bảng Đơn hàng (Orders - Phục vụ VietQR Payment)
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_code VARCHAR(50) UNIQUE NOT NULL,
    user_id INT,
    total_amount DECIMAL(12,2) NOT NULL,
    payment_method ENUM('COD', 'VietQR') DEFAULT 'VietQR',
    payment_status ENUM('pending', 'paid', 'failed') DEFAULT 'pending',
    order_status ENUM('pending', 'processing', 'shipping', 'completed', 'cancelled') DEFAULT 'pending',
    qr_url TEXT,
    shipping_address TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- 7. Bảng Chi tiết đơn hàng (Order Items)
CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT
);

-- 8. Bảng Đánh giá & Nhận xét (Reviews - Phục vụ AI Review Summarization)
CREATE TABLE IF NOT EXISTS reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 9. Bảng Lịch sử Tư vấn AI (AI Chat Logs)
CREATE TABLE IF NOT EXISTS ai_chat_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    user_query TEXT NOT NULL,
    ai_response TEXT NOT NULL,
    retrieved_product_ids JSON, -- Lưu danh sách ID sản phẩm RAG đã gợi ý
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);