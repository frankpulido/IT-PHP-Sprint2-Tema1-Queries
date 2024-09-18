USE schema_optica;

-- 1- Record de compras histórico (total) de todos los clientes ordenado por Cliente ASC (apellido 1, apellido 2, nombre).
SELECT c.last_name1 AS 'apellido 1', c.last_name2 AS 'apellido 2', c.first_name AS 'nombre', SUM(s.total_sale) AS 'total ventas € por cliente' FROM sales s JOIN customers c ON s.id_customer = c.id_customer GROUP BY c.id_customer ORDER BY c.last_name1, c.last_name2, c.first_name;

-- 2- Record de compras histórico (total) de un cliente concreto.
SELECT c.last_name1 AS 'apellido 1', c.last_name2 AS 'apellido 2', c.first_name AS 'nombre', SUM(s.total_sale) AS 'total compras cliente €' FROM sales s JOIN customers c ON s.id_customer = c.id_customer WHERE c.last_name1 LIKE 'DOE' AND c.first_name LIKE 'JANE';

-- 1B- Misma consulta 1 desde la Tabla de Detalle de Ventas [extracción desde tabla sale_items, s.total_price es un query attribute NO resuelto]
SELECT c.last_name1 AS 'apellido 1', c.last_name2 AS 'apellido 2', c.first_name AS 'nombre', subquery.total_€ AS 'total ventas € por cliente' FROM customers c JOIN (SELECT s.id_customer, SUM(si.quantity * si.price) AS 'total_€' FROM sales s JOIN sale_items si ON s.id_sale = si.id_sale GROUP BY s.id_customer) AS subquery ON c.id_customer = subquery.id_customer GROUP BY c.id_customer ORDER BY c.last_name1, c.last_name2, c.first_name;

-- 2B- Misma consulta 2 desde la Tabla de Detalle de Ventas [extracción desde tabla sale_items, s.total_price es un query attribute NO resuelto]
SELECT c.last_name1 AS 'apellido 1', c.last_name2 AS 'apellido 2', c.first_name AS 'nombre', subquery.total_€ AS 'total compras cliente €' FROM customers c JOIN (SELECT s.id_customer, SUM(si.price) AS 'total_€' FROM sales s JOIN sale_items si ON s.id_sale = si.id_sale GROUP BY s.id_customer) AS subquery ON c.id_customer = subquery.id_customer WHERE c.last_name1 LIKE 'DOE' AND c.first_name LIKE 'JANE';

-- 3- Record de ventas histórico (total) de todos los empleados en un año en concreto. Ordenado por Empleado ASC (apellido 1, apellido 2, nombre).
SELECT e.emp_last_name AS 'apellido empleado', e.emp_name AS 'nombre empleado', SUM(s.total_sale) AS 'ventas € 2024' FROM employees e JOIN sales s ON e.id_employee = s.id_employee WHERE s.date_sale LIKE "2024%" GROUP BY e.id_employee;

-- 4- Record de ventas histórico (total) de un empleado concreto en un año en concreto.
SELECT e.emp_last_name AS 'apellido empleado', e.emp_name AS 'nombre empleado', SUM(s.total_sale) AS 'Report empleado - ventas € 2024' FROM employees e JOIN sales s ON e.id_employee = s.id_employee WHERE e.emp_last_name LIKE 'MARTINEZ' AND e.emp_name LIKE 'LUCAS' AND s.date_sale LIKE "2024%";

-- 5- Listar el proveedores que ha suministrado las gafas TOP VENTAS en unidades.
SELECT su.commercial_name AS 'proveedor', subquery.quantity AS 'TOP 1 record unidades vendidas' FROM suppliers su JOIN (SELECT p.id_supplier AS 'supplier', SUM(si.quantity) AS 'quantity' FROM products p JOIN sale_items si ON p.id_product = si.id_product GROUP BY p.id_supplier) AS subquery ON su.id_supplier = subquery.supplier ORDER BY subquery.quantity DESC LIMIT 1;

-- 6- Listar el proveedores que ha suministrado las gafas TOP VENTAS en euros.
SELECT su.commercial_name AS 'proveedor', subquery.ventas AS 'TOP 1 record ventas €' FROM suppliers su JOIN (SELECT p.id_supplier AS 'supplier', SUM(si.quantity * si.price) AS 'ventas' FROM products p JOIN sale_items si ON p.id_product = si.id_product GROUP BY p.id_supplier) AS subquery ON su.id_supplier = subquery.supplier ORDER BY subquery.ventas DESC LIMIT 1;