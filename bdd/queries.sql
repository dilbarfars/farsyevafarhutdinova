-- ============================================================
-- queries.sql — SQL-запросы для приложения «Башмак» (C#)
-- Знак ? — место, куда в C#-коде подставляется значение (параметр команды).
-- В скобках указаны пункты чек-листа, за которые отвечает запрос.
-- ============================================================
USE `bashmak`;

-- ------------------------------------------------------------
-- 1. Вход в приложение (пп. 2.5, 2.6, 3.17)
--    Одна строка — вход выполнен, ФИО и роль для шапки окна.
--    Пустой результат — «неправильный логин или пароль».
-- ------------------------------------------------------------
SELECT u.id, u.full_name, r.name AS role
FROM users u
JOIN roles r ON r.id = u.role_id
WHERE u.login = ? AND u.password = ?;

-- ------------------------------------------------------------
-- 2. Каталог товаров (пп. 2.7–2.11)
--    Один запрос для окна Гостя, Клиента, Менеджера и Администратора:
--    названия категории, производителя и поставщика вместо голых id.
-- ------------------------------------------------------------
SELECT p.id, p.article, p.name, p.unit, p.price, p.discount, p.stock_qty,
       p.description, p.photo,
       c.name AS category, m.name AS manufacturer, s.name AS supplier
FROM products p
JOIN categories    c ON c.id = p.category_id
JOIN manufacturers m ON m.id = p.manufacturer_id
JOIN suppliers     s ON s.id = p.supplier_id;

-- ------------------------------------------------------------
-- 3. Поиск, фильтр, сортировка (пп. 3.2–3.6)
--    Базовый запрос из п. 2 + условия. Условия можно использовать
--    по отдельности или все сразу (п. 3.6) — убирается лишняя строка.
-- ------------------------------------------------------------

-- 3.1 Поиск по названию + фильтр по поставщику + сортировка по остатку (п. 3.6)
SELECT p.id, p.article, p.name, p.unit, p.price, p.discount, p.stock_qty,
       p.description, p.photo,
       c.name AS category, m.name AS manufacturer, s.name AS supplier
FROM products p
JOIN categories    c ON c.id = p.category_id
JOIN manufacturers m ON m.id = p.manufacturer_id
JOIN suppliers     s ON s.id = p.supplier_id
WHERE p.name LIKE CONCAT('%', ?, '%')
  AND p.supplier_id = ?
ORDER BY p.stock_qty DESC;

-- 3.2 Только поиск по названию
--     ... WHERE p.name LIKE CONCAT('%', ?, '%')

-- 3.3 Только фильтр по поставщику (пп. 3.4–3.5)
--     ... WHERE p.supplier_id = ?

-- 3.4 Только сортировка по остатку на складе (пп. 3.2–3.3):
--     ... ORDER BY p.stock_qty ASC;    -- по возрастанию
--     ... ORDER BY p.stock_qty DESC;   -- по убыванию

-- 3.5 Список поставщиков для выпадающего фильтра — см. п. 4

-- ------------------------------------------------------------
-- 4. Справочники для выпадающих списков формы и фильтра
-- ------------------------------------------------------------
SELECT id, name FROM categories;
SELECT id, name FROM manufacturers;
SELECT id, name FROM suppliers;

-- ------------------------------------------------------------
-- 5. Добавление товара (пп. 3.7, 3.10)
-- ------------------------------------------------------------
INSERT INTO products
  (article, name, unit, price, discount, stock_qty, description, photo,
   category_id, manufacturer_id, supplier_id)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);

-- ------------------------------------------------------------
-- 6. Редактирование товара (пп. 3.12, 3.19)
-- ------------------------------------------------------------
-- 6.1 Открыть товар для редактирования — заполнить все поля формы сразу
SELECT * FROM products WHERE id = ?;

-- 6.2 Сохранить изменения
UPDATE products
SET article = ?, name = ?, unit = ?, price = ?, discount = ?, stock_qty = ?,
    description = ?, photo = ?,
    category_id = ?, manufacturer_id = ?, supplier_id = ?
WHERE id = ?;

-- ------------------------------------------------------------
-- 7. Удаление товара (п. 3.16 — нельзя удалить купленный товар)
-- ------------------------------------------------------------
-- 7.1 Проверка до удаления: если больше 0 — показать пользователю
--     понятное предупреждение и НЕ выполнять DELETE.
SELECT COUNT(*) AS used_in_orders FROM prodorders WHERE product_id = ?;

-- 7.2 Удаление. Если товар есть в заказе, СУБД откажет с ошибкой 1451
--     (связь prodorders → products без CASCADE).
DELETE FROM products WHERE id = ?;
