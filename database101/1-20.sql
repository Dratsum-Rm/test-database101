--------------------------------------------------
-- 3. Queries ตามโจทย์
--------------------------------------------------
-- 1) แสดงข้อมูลลูกค้าทั้งหมด
SELECT id, name, email, phone
FROM users; -- id, ชื่อ, email, เบอร์โทร

-- 2) แสดงรายชื่อสินค้า พร้อมราคา เรียงจากราคาสูงไปต่ำ
SELECT name, price
FROM products
ORDER BY price DESC; -- เรียงจากแพงสุดลงต่ำสุด

-- 3) แสดงรายการประเภทสินค้าทั้งหมด
SELECT id, name
FROM categories; -- id และชื่อ category

-- 4) ดึงรายการสินค้าที่ stock น้อยกว่า 100 ชิ้น
SELECT id, name, stock
FROM products
WHERE stock < 100; -- filter stock < 100

-- 5) หา product ที่ ราคามากกว่า 100 บาทขึ้นไป
SELECT id, name, price
FROM products
WHERE price > 100; -- filter price > 100

-- 6) ดูข้อมูล cart_items ทั้งหมด พร้อมชื่อ user และ product
SELECT ci.id, ci.cart_id, ci.product_id, ci.quantity, ci.price_at_time,
       u.name AS user_name, p.name AS product_name
FROM cart_items ci
JOIN carts c ON ci.cart_id = c.id
JOIN users u ON c.user_id = u.id
JOIN products p ON ci.product_id = p.id;
-- join เพื่อดูชื่อ user และชื่อสินค้า

--------------------------------------------------
-- 7) แสดงสินค้าแต่ละตัว พร้อมชื่อหมวดหมู่
-- product_name, category_name, price, stock
--------------------------------------------------
SELECT 
    p.name AS product_name,          -- • ชื่อสินค้า
    c.name AS category_name,         -- • ชื่อหมวดหมู่ของสินค้า
    p.price,                         -- • ราคาปัจจุบัน
    p.stock                          -- • จำนวนคงเหลือในคลัง
FROM products p                      -- • ตารางสินค้า (ตั้ง alias = p)
JOIN categories c ON p.category_id = c.id; 
                                     -- • join กับหมวดหมู่ผ่าน product.category_id = categories.id


--------------------------------------------------
-- 8) รวมจำนวนสินค้าใน cart ของ Alice (status = active)
--------------------------------------------------
SELECT 
    u.name AS user_name,                 -- ชื่อลูกค้า
    ca.id AS cart_id,                    -- ไอดีของ cart
    ca.status,                           -- สถานะ (active)
    SUM(ci.quantity) AS total_items      -- จำนวนรวม
FROM cart_items ci
JOIN carts ca ON ci.cart_id = ca.id
JOIN users u ON ca.user_id = u.id
WHERE u.name = 'Alice'
  AND ca.status = 'active'
GROUP BY ca.id;                           -- ให้รู้ว่าเป็น cart ไหน


--------------------------------------------------
-- 9) แสดง order ทั้งหมด พร้อมชื่อผู้สั่งซื้อ
--------------------------------------------------
SELECT 
    o.id AS order_id,                -- • เลขคำสั่งซื้อ
    u.name AS customer_name,         -- • ชื่อลูกค้าที่ซื้อ
    o.total_amount,                  -- • จำนวนเงินรวมในออเดอร์
    o.created_at                     -- • วันที่สร้างออเดอร์
FROM orders o                        -- • ตารางออเดอร์
JOIN users u ON o.user_id = u.id;    -- • เชื่อมกับลูกค้าแต่ละคน


--------------------------------------------------
-- 10) สินค้าใน order #1 + line_total
--------------------------------------------------
SELECT
    p.name AS product_name,                 -- • ชื่อสินค้า
    oi.quantity,                            -- • จำนวนที่ซื้อ
    oi.price_at_time AS price,              -- • ใช้ price_at_time แทน oi.price
    (oi.quantity * oi.price_at_time) AS line_total  -- • ราคารวม = จำนวน × price_at_time
FROM order_items oi
JOIN products p ON oi.product_id = p.id
WHERE oi.order_id = 1;


--------------------------------------------------
-- 11) นับจำนวนสินค้าในแต่ละหมวดหมู่
--------------------------------------------------
SELECT 
    c.name AS category_name,         -- • ชื่อหมวดหมู่
    COUNT(p.id) AS total_products    -- • จำนวนสินค้าที่อยู่ในหมวดนั้น
FROM categories c                    -- • หมวดหมู่ทั้งหมด
LEFT JOIN products p ON c.id = p.category_id
                                     -- • left join เพื่อให้หมวดว่างก็ยังแสดง
GROUP BY c.id;                       -- • จัดกลุ่มตามหมวดหมู่


--------------------------------------------------
-- 12) email ที่มีคำว่า @example.com
--------------------------------------------------
SELECT 
    id,                              -- • User ID
    name,                            -- • ชื่อลูกค้า
    email                            -- • อีเมลที่ตรงเงื่อนไข
FROM users
WHERE email LIKE '%@example.com%';   -- • ค้นหา string ที่มี @example.com อยู่ในข้อความ


--------------------------------------------------
-- 13) แสดงเฉพาะสินค้าหมวด Electronics
--------------------------------------------------
SELECT 
    p.id,                            -- • Product ID
    p.name,                          -- • ชื่อสินค้า
    p.price,                         -- • ราคา
    p.stock                          -- • จำนวนคงเหลือ
FROM products p
JOIN categories c ON p.category_id = c.id
                                     -- • เชื่อม table เพื่อรู้ว่าสินค้าอยู่หมวดไหน
WHERE c.name = 'Electronics';        -- • เฉพาะหมวด Electronics


--------------------------------------------------
-- 14) แสดง 3 สินค้าราคาถูกที่สุด
--------------------------------------------------
SELECT 
    id,                              -- • Product ID
    name,                            -- • ชื่อสินค้า
    price                            -- • ราคา
FROM products
ORDER BY price ASC                   -- • เรียงจากถูก → แพง
LIMIT 3;                             -- • เอาแค่ 3 อันดับแรก


--------------------------------------------------
-- 15) สรุปยอดขายสินค้าแต่ละตัว
--------------------------------------------------
SELECT 
    p.name AS product_name,                         
    SUM(oi.quantity) AS total_quantity_sold,        
    SUM(oi.quantity * oi.price_at_time) AS total_revenue   -- • ใช้ price_at_time แทน oi.price
FROM order_items oi
JOIN products p ON oi.product_id = p.id
GROUP BY oi.product_id;


--------------------------------------------------
-- 16) สินค้าที่ขายดีที่สุด (จำนวนชิ้นรวมมากที่สุด)
--------------------------------------------------
SELECT 
    p.name AS product_name,               -- • ชื่อสินค้า
    SUM(oi.quantity) AS total_sold        -- • จำนวนรวมที่ถูกขาย
FROM order_items oi
JOIN products p ON oi.product_id = p.id
GROUP BY oi.product_id
ORDER BY total_sold DESC                  -- • เรียงจากขายเยอะ → น้อย
LIMIT 1;                                  -- • เอาอันดับ 1 เท่านั้น


--------------------------------------------------
-- 17) ลูกค้าที่มียอดซื้อรวมสูงที่สุด
--------------------------------------------------
SELECT 
    u.name AS customer_name,              -- • ชื่อลูกค้า
    SUM(o.total_amount) AS total_spent    -- • ยอดเงินรวมทั้งหมดที่เคยสั่ง
FROM orders o
JOIN users u ON o.user_id = u.id
GROUP BY o.user_id
ORDER BY total_spent DESC                 -- • เรียงจากใช้เงินมาก → น้อย
LIMIT 1;                                  -- • เอาคนที่พีคที่สุด


--------------------------------------------------
-- 18) ออเดอร์ที่มี total_amount มากกว่า 500
--------------------------------------------------
SELECT 
    id AS order_id,                       -- • เลขออเดอร์
    user_id,                              -- • ใครเป็นคนสั่ง
    total_amount,                         -- • ยอดรวมในออเดอร์
    created_at                            -- • วันที่สร้าง
FROM orders
WHERE total_amount > 500;                 -- • เงื่อนไขยอดเกิน 500 บาท


--------------------------------------------------
-- 19) สินค้าที่ไม่เคยถูกสั่งซื้อเลย
--------------------------------------------------
SELECT 
    p.id,                                 -- • Product ID
    p.name                                -- • ชื่อสินค้า
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
                                          -- • left join เพื่อเช็คว่าเคยมีใน order_items ไหม
WHERE oi.product_id IS NULL;              -- • Null = ไม่มีรายการสั่งซื้อเลย


--------------------------------------------------
-- 20) หมวดหมู่ที่ทำรายได้รวมสูงที่สุด
--------------------------------------------------
SELECT
    c.name AS category_name,
    SUM(oi.quantity * oi.price_at_time) AS total_revenue   -- • ใช้ price_at_time แทน oi.price
FROM categories c
JOIN products p ON p.category_id = c.id
JOIN order_items oi ON oi.product_id = p.id
GROUP BY c.id
ORDER BY total_revenue DESC
LIMIT 1;