--------------------------------------------------
-- 2. เพิ่มข้อมูลตัวอย่าง (INSERT)
--------------------------------------------------
-- Users
INSERT INTO users (name, email, phone, created_at) VALUES
('Alice', 'alice@example.com', '080-000-0001', '2025-12-10T10:00:00Z'), -- user #1
('Bob',   'bob@example.com',   '080-000-0002', '2025-12-10T10:30:00Z'), -- user #2
('Charlie','charlie@example.com','080-000-0003','2025-12-10T11:00:00Z'); -- user #3

-- Categories
INSERT INTO categories (name) VALUES
('Electronics'), -- id=1
('Clothing'),    -- id=2
('Books'),       -- id=3
('Home & Kitchen'); -- id=4

-- Products
INSERT INTO products (name, description, price, stock, category_id, created_at) VALUES
('Smartphone X1', 'High-end smartphone with OLED display', 599.99, 50, 1, '2025-12-10T12:00:00Z'), -- electronics
('Wireless Headphones', 'Noise-cancelling over-ear headphones', 129.99, 120, 1, '2025-12-10T12:05:00Z'), -- electronics
('T-Shirt Black M', '100% cotton unisex t-shirt (size M)', 19.99, 200, 2, '2025-12-10T12:10:00Z'), -- clothing
('T-Shirt White L', '100% cotton unisex t-shirt (size L)', 21.99, 150, 2, '2025-12-10T12:12:00Z'), -- clothing
('Fantasy Novel Vol.1', 'First book in fantasy series', 9.99, 80, 3, '2025-12-10T12:15:00Z'), -- books
('Coffee Mug 350ml', 'Ceramic mug, dishwasher safe', 7.50, 100, 4, '2025-12-10T12:20:00Z'); -- home & kitchen

-- Alice's cart
INSERT INTO carts (user_id, status, created_at) VALUES
(1, 'active', '2025-12-10T13:00:00Z'); -- cart #1 ของ Alice

-- Items in Alice's cart
INSERT INTO cart_items (cart_id, product_id, quantity, price_at_time) VALUES
(1, 1, 1, 599.99),  -- Smartphone X1
(1, 3, 2, 19.99);   -- 2x T-Shirt Black M

-- Alice places an order from that cart
INSERT INTO orders (user_id, total_amount, status, created_at) VALUES
(1, 599.99 + 2*19.99, 'paid', '2025-12-10T14:00:00Z'); -- order #1

-- Order items for order #1
INSERT INTO order_items (order_id, product_id, quantity, price_at_time) VALUES
(1, 1, 1, 599.99),
(1, 3, 2, 19.99);