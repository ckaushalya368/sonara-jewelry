
CREATE DATABASE sonara_jewelry;

USE sonara_jewelry;

-- 1. Users Table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    role ENUM('customer', 'admin') DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Categories Table
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Products Table
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT,
    product_name VARCHAR(150) NOT NULL,
    description TEXT,
    metal_type VARCHAR(50),
    weight DECIMAL(10,3),
    purity DECIMAL(5,2),
    making_charge DECIMAL(12,2) DEFAULT 0,
    gemstone_value DECIMAL(12,2) DEFAULT 0,
    current_price DECIMAL(12,2) DEFAULT 0,
    stock_quantity INT DEFAULT 0,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
);

-- 4. Product Images Table
CREATE TABLE product_images (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON DELETE CASCADE
);

-- 5. Carts Table
CREATE TABLE carts (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 6. Cart Items Table
CREATE TABLE cart_items (
    cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT DEFAULT 1,
    FOREIGN KEY (cart_id) REFERENCES carts(cart_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 7. Orders Table
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL,
    order_status VARCHAR(50) DEFAULT 'pending',
    delivery_address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 8. Order Items Table
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT DEFAULT 1,
    unit_price DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 9. Payments Table
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_method VARCHAR(50),
    payment_status VARCHAR(50) DEFAULT 'pending',
    amount DECIMAL(12,2) NOT NULL,
    transaction_reference VARCHAR(150),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- 10. Metal Rates Table
CREATE TABLE metal_rates (
    rate_id INT AUTO_INCREMENT PRIMARY KEY,
    metal_type VARCHAR(50) NOT NULL,
    rate_per_gram DECIMAL(12,2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'LKR',
    source VARCHAR(150),
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 11. Price Rules Table
CREATE TABLE price_rules (
    rule_id INT AUTO_INCREMENT PRIMARY KEY,
    rule_name VARCHAR(100) NOT NULL,
    making_charge DECIMAL(12,2) DEFAULT 0,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
);

-- 12. Price History Table
CREATE TABLE price_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    rate_id INT NOT NULL,
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (rate_id) REFERENCES metal_rates(rate_id)
);

-- 13. Product Stones Table
CREATE TABLE product_stones (
    stone_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    stone_name VARCHAR(100),
    carat DECIMAL(8,3),
    stone_value DECIMAL(12,2) DEFAULT 0,
    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

-- 14. Product Price History Table
CREATE TABLE product_price_history (
    price_history_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    previous_price DECIMAL(12,2),
    new_price DECIMAL(12,2),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 15. API Sync Logs Table
CREATE TABLE api_sync_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    api_name VARCHAR(100),
    sync_status VARCHAR(50),
    message TEXT,
    synced_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
