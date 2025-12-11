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