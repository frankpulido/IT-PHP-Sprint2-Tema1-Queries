USE schema_pizzeria;

-- 1- Mostrar cuantos productos de tipo "drink" se han vendido en cada localidad (postal code customer).
SELECT c.customer_postalcode, SUM(subquery2.quantity) AS 'total beverages sold in CP' FROM customers c JOIN (SELECT o.customer_id, subquery1.quantity FROM orders o JOIN (SELECT oi.order_id, oi.quantity AS quantity FROM order_items oi JOIN products p ON oi.id_product = p.id_product WHERE p.product_type IN('drink')) AS subquery1 ON o.id_order = subquery1.order_id) AS subquery2 ON c.id_customer = subquery2.customer_id GROUP BY customer_postalcode ORDER BY c.customer_postalcode ASC;

-- 2- Mostrar cuantos productos de tipo "drink" se han vendido en una determinada localidad (postal code customer = 08002).
SELECT c.customer_postalcode, SUM(subquery2.quantity) AS 'total beverages sold in CP' FROM customers c JOIN (SELECT o.customer_id, subquery1.quantity FROM orders o JOIN (SELECT oi.order_id, oi.quantity AS quantity FROM order_items oi JOIN products p ON oi.id_product = p.id_product WHERE p.product_type IN('drink')) AS subquery1 ON o.id_order = subquery1.order_id) AS subquery2 ON c.id_customer = subquery2.customer_id WHERE c.customer_postalcode = 08002;

-- 3- Listar cuantas órdenes ha efectuado cada empleado.
SELECT e.employee_lastname, e.employee_firstname, COUNT(o.id_order) AS 'total pedidos gestionados' FROM orders o JOIN employees e ON o.id_employee = e.id_employee GROUP BY o.id_employee ORDER BY e.employee_lastname;

-- 4- Listar cuantas órdenes ha efectuado un determinado empleado ('Frank Pulido').
SELECT e.employee_lastname, e.employee_firstname, COUNT(o.id_order) AS 'total pedidos gestionados' FROM orders o JOIN employees e ON o.id_employee = e.id_employee WHERE e.employee_lastname LIKE 'PULIDO' AND e.employee_firstname LIKE 'FRANK';
