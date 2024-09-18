/*
****** Rubén : A continuación comento statements de MariaDB cuando exporta una Base de Datos. Podemos comentar utilidad ? ******
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

Al finalo de cada Tabla creada, después del paréntesis, la instrucción cierra así :
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

****************
FOREIGN KEY CONSTRAINTS (ON DELETE *** ON UPDATE ***):
  NO ACTION
  CASCADE
  SET NULL
  RESTRICT
****************

INDEXES :
Cuando se piensa usar algunas columnas para hace SEARCH las definimos de tipo INDEX.
Por defecto el PRIMARY KEY queda siempre definido como INDEX.

****************

LECCIONES APRENDIDAS :
1) Las Tablas que hacen uso de FOREIGN KEYS deben declararse de forma ulterior a las que contienen las PRIMARY KEYS de las que hacen uso.
2) La PRIMARY KEY COMPUESTA de una Tabla relacional de 2 entidades debe declararse como primera instrucción debajo de CREATE TABLE.

****************

INVESTIGAR PARA ESTE CASO EN CONCRETO DONDE LA CATEGORÍA SÓLO APLICA PARA EL ENUM PIZZA :
CONSTRAINT chk_category CHECK (product_type = 'pizza' OR id_category IS NULL)

**********************************

TABLA order_items
Existen 2 FOREIGN KEYS son combinadas en 1 PRIMARY KEY
order_id REFERENCES orders(id_order)
id_product REFERENCES products(id_product)

**********************************

PENDIENTE DE RESOLVER
La creación del registro de cada venta en la Tabla orders se hace sin suministrar el último atributo : total_price
Es necesario programar 2 cosas en la Base de Datos para que funcione correctamente :

1) LAST_INSERT_ID
2) TRIGGER
PARENT-CHILD (Tabla ORDERS - Tabla ORDER_ITEMS) : 2:39:08 -> https://youtu.be/7S_tz1z_5bA?t=9549

LAST_INSERT_ID : Esta instrucción debe retornar el PK del último registro de Tabla ORDERS para usarlo en la creación de nuevos registros en Tabla ORDER_ITEMS.
Todos los productos (registros) que agreguemos a la Tabla ORDER_ITEMS se hacen SIN indicar atributo "id_order" que SE HEREDA de ORDERS con la instrucción LAST_INSERT_ID.
Mientras no se abra un nuevo registro en la Tabla ORDERS se usará dicho id, dado que no se habrá cerrado la venta.

TRIGGER : Cada nueva entrada de datos (INSERT INTO) hecha en la Tabla ORDER_ITEMS debe desencadenar una actualización del campo total_price de la Tabla ORDERS (ON
order_items.order_id = orders.id_order).
*/

DROP DATABASE IF EXISTS pizzeria;
CREATE DATABASE pizzeria CHARACTER SET utf8mb4;


USE pizzeria;

CREATE TABLE category (
  id_category tinyint(3) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name_category varchar(20) NOT NULL
);


CREATE TABLE customers (
  id_customer int(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  customer_firstname varchar(20) NOT NULL,
  customer_lastname1 varchar(20) NOT NULL,
  customer_lastname2 varchar(20) NOT NULL,
  customer_address varchar(50) NOT NULL,
  customer_province varchar(20) NOT NULL,
  customer_city varchar(20) NOT NULL,
  customer_postalcode char(5) NOT NULL,
  customer_phone char(9) NOT NULL
);


CREATE TABLE restaurants (
  id_restaurant tinyint(3) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  address_rest varchar(40) NOT NULL,
  province_rest varchar(20) NOT NULL,
  city_rest varchar(20) NOT NULL,
  postalcode_rest varchar(5) NOT NULL
);


CREATE TABLE employees (
  id_employee smallint(4) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_restaurant tinyint(3) UNSIGNED NOT NULL,
  FOREIGN KEY (`id_restaurant`) REFERENCES `restaurants` (`id_restaurant`) ON DELETE RESTRICT ON UPDATE CASCADE,
  employee_firstname varchar(20) NOT NULL,
  employee_lastname varchar(20) NOT NULL,
  employee_nif varchar(9) UNIQUE NOT NULL,
  employee_phone varchar(9) NOT NULL,
  employee_role enum('kitchen','delivery') NOT NULL
);


CREATE TABLE products (
  id_product tinyint(3) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_category tinyint(3) UNSIGNED NULL,
  FOREIGN KEY (`id_category`) REFERENCES `category` (`id_category`) ON DELETE SET NULL ON UPDATE CASCADE,
  product_type enum('pizza','burguer','drink') NOT NULL,
  product_name varchar(30) NOT NULL,
  product_description varchar(250) NOT NULL,
  url_img varchar(50) NOT NULL,
  price decimal(5,2) NOT NULL
);


CREATE TABLE orders (
  id_order int(8) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_employee smallint(4) UNSIGNED NOT NULL,
  FOREIGN KEY (`id_employee`) REFERENCES `employees` (`id_employee`) ON DELETE RESTRICT ON UPDATE CASCADE,
  customer_id int(6) UNSIGNED NOT NULL,
  FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id_customer`) ON DELETE NO ACTION ON UPDATE CASCADE,
  order_date datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  pickup_mode enum('delivery','take away') NOT NULL,
  q_pizzas tinyint(2) NOT NULL DEFAULT 0,
  q_burguers tinyint(2) NOT NULL DEFAULT 0,
  q_beverages tinyint(2) NOT NULL DEFAULT 0,
  total_price decimal(7,2) NOT NULL DEFAULT 0
);

/*
El atributo orders.total_price debe actualizarse con un TRIGGER cada vez que se crea un registro en order_items con (order_items.order_id = orders.id_order)
El TRIGGER se crea para la Tabla order_items
Los atributos q_pizzas, q_burguers y q_beverages también deben actualizarse con un TRIGGER en order_items :
orders.p_pizzas = SELECT SUM(subquery.quantity) FROM (SELECT order_items.quantity AS quantity FROM order_items JOIN products ON order_items.id_product = products.id_product WHERE products.product_type IN(pizza)) WHERE order_items.order_id = orders.id_order;

Consulta SIN la subquery
orders.p_pizzas = SELECT SUM(order_items.quantity) WHERE order_items.order_id = orders.id_order;
SUBQUERY :
SELECT order_items.quantity AS quantity FROM order_items JOIN products ON order_items.id_product = products.id_product WHERE products.product_type IN(pizza);
*/

CREATE TABLE order_items (
  PRIMARY KEY (`order_id`, `id_product`),
  order_id int(8) UNSIGNED NOT NULL,
  FOREIGN KEY (`order_id`) REFERENCES `orders` (`id_order`) ON DELETE CASCADE ON UPDATE CASCADE,
  id_product tinyint(3) UNSIGNED NOT NULL,
  FOREIGN KEY (`id_product`) REFERENCES `products` (`id_product`) ON DELETE RESTRICT ON UPDATE CASCADE,
  quantity tinyint(2) NOT NULL,
  unit_price decimal(5,2) NOT NULL
);

/*
En la Tabla anterior se crea un PRIMARY KEY compuesto de los 2 FOREIGN KEYS : (order_id, id_product)
order_id se HEREDA de la Tabla orders usando la instrucción : LAST_INSERT_ID.
Un mismo order_id puede formar distintas PRIMARY KEY combinándose con distintos id_product de la misma venta, pero nunca habrá 2 PRIMARY KEY iguales, al introducir 2 productos iguales en la misma orden estamos incrementando order_items.quantity.

TRIGGERS
Cada vez que introducimos un nuevo registro en esta tabla (ORDER_ITEMS) debemos usar TRIGGERS que modifiquen la Tabla ORDERS :
1) orders.total_price = SUM(order_items.quantity * order_items.unit_price) WHERE order_items.order_id = orders.id_order;
Cada vez que se crea una entrada en ORDER_ITEMS deben ejecutarse los siguientes :
SUBQUERY : SELECT oi.quantity, p.product_type FROM order_items oi JOIN products p ON oi.id_product = p.id_product WHERE id_product = [valor_ingresado];
2) orders.q_pizzas = ADD oi.quantity CASE subquery.quantity IN ('pizza');
3) orders.q_burguers = ADD oi.quantity CASE subquery.quantity IN ('burguer');
4) orders.q_ beverages = ADD oi.quantity CASE subquery.quantity IN ('drink');
*/

CREATE TABLE deliveries (
    PRIMARY KEY (`order_id`, `id_employee`),
    order_id int(8) UNSIGNED NOT NULL,
    FOREIGN KEY (`order_id`) REFERENCES `orders` (`id_order`) ON DELETE RESTRICT ON UPDATE CASCADE,
    id_employee smallint(4) UNSIGNED NOT NULL,
    FOREIGN KEY (`id_employee`) REFERENCES `employees` (`id_employee`) ON DELETE RESTRICT ON UPDATE CASCADE,
    delivery_time datetime NOT NULL
);

/* DATA SET GENERADO CON CHAT GPT */

-- Insert pizza categories
INSERT INTO category (name_category) VALUES
('special'),
('gluten free'),
('vegetarian');

-- Insert restaurants
INSERT INTO restaurants (address_rest, province_rest, city_rest, postalcode_rest) VALUES
('123 Pizza St', 'Madrid', 'Madrid', '28001'),
('456 Burger Ave', 'Barcelona', 'Barcelona', '08001');

-- Insert customers
INSERT INTO customers (customer_firstname, customer_lastname1, customer_lastname2, customer_address, customer_province, customer_city, customer_postalcode, customer_phone) VALUES
('John', 'Doe', 'Smith', '789 Customer Ln', 'Madrid', 'Madrid', '28002', '600123456'),
('Jane', 'Roe', 'Johnson', '321 Client Rd', 'Barcelona', 'Barcelona', '08002', '600654321'),
('Alice', 'Blue', 'Ray', '852 Buyer St', 'Madrid', 'Madrid', '28003', '600987654'),
('Bob', 'Green', 'Ray', '963 Shopper St', 'Barcelona', 'Barcelona', '08003', '600456789'),
('Charlie', 'Brown', 'Smith', '147 Patron St', 'Madrid', 'Madrid', '28004', '600123789'),
('Eve', 'White', 'Doe', '258 Purchaser Ave', 'Barcelona', 'Barcelona', '08004', '600789123');

-- Insert employees (2 kitchen and 2 delivery employees for each restaurant)
INSERT INTO employees (id_restaurant, employee_firstname, employee_lastname, employee_nif, employee_phone, employee_role) VALUES
(1, 'Mario', 'Santana', '12345678A', '600001111', 'kitchen'),
(1, 'Luigi', 'MarioBros', '23456789B', '600002222', 'kitchen'),
(1, 'Peach', 'Beach', '34567890C', '600003333', 'delivery'),
(1, 'Daisy', 'Giuliani', '45678901D', '600004444', 'delivery'),
(2, 'Frank', 'Pulido', '56789012E', '600005555', 'kitchen'),
(2, 'Laura', 'Cuesta', '67890123F', '600006666', 'kitchen'),
(2, 'Tommy', 'Lea Johns', '78901234G', '600007777', 'delivery'),
(2, 'Ben', 'Stiler', '89012345H', '600008888', 'delivery');

-- Insert products (3 pizzas, 2 burgers, 2 drinks)
INSERT INTO products (id_category, product_type, product_name, product_description, url_img, price) VALUES
(1, 'pizza', 'Special Pizza', 'Delicious special pizza with all toppings.', '/img/pizza1.jpg', 12.99),
(2, 'pizza', 'Gluten-Free Pizza', 'Gluten-free pizza with fresh ingredients.', '/img/pizza2.jpg', 14.99),
(3, 'pizza', 'Vegetarian Pizza', 'Healthy vegetarian pizza with organic toppings.', '/img/pizza3.jpg', 13.99),
(NULL, 'burguer', 'Classic Burger', 'Juicy beef burger with lettuce, tomato, and cheese.', '/img/burger1.jpg', 9.99),
(NULL, 'burguer', 'Chicken Burger', 'Crispy chicken burger with mayo and pickles.', '/img/burger2.jpg', 8.99),
(NULL, 'drink', 'Coke', 'Refreshing Coca-Cola.', '/img/drink1.jpg', 2.50),
(NULL, 'drink', 'Water', 'Bottled still water.', '/img/drink2.jpg', 1.50);


-- Insert orders (each customer makes 2 orders at each restaurant)

INSERT INTO orders (id_employee, customer_id, pickup_mode, q_pizzas, q_burguers, q_beverages, total_price) VALUES
(1, 1, 'delivery', 2, 0, 1, 28.48);  -- John Doe's order
-- Insert order items
INSERT INTO order_items (order_id, id_product, quantity, unit_price) VALUES
(1, 1, 2, 12.99),  -- Special Pizza
(1, 6, 1, 2.50);   -- Coke

INSERT INTO orders (id_employee, customer_id, pickup_mode, q_pizzas, q_burguers, q_beverages, total_price) VALUES
(2, 1, 'take away', 1, 1, 0, 22.98);  -- John Doe's order
-- Insert order items
INSERT INTO order_items (order_id, id_product, quantity, unit_price) VALUES
(2, 3, 1, 13.99),  -- Vegetarian Pizza
(2, 4, 1, 9.99);   -- Classic Burger

INSERT INTO orders (id_employee, customer_id, pickup_mode, q_pizzas, q_burguers, q_beverages, total_price) VALUES
(5, 2, 'delivery', 2, 0, 2, 34.98);  -- Jane Roe's order
-- Insert order items
INSERT INTO order_items (order_id, id_product, quantity, unit_price) VALUES
(3, 2, 2, 14.99),  -- Gluten-Free Pizza
(3, 6, 2, 2.50);   -- Coke

INSERT INTO orders (id_employee, customer_id, pickup_mode, q_pizzas, q_burguers, q_beverages, total_price) VALUES
(6, 2, 'take away', 0, 1, 1, 10.49);  -- Jane Roe's order
-- Insert order items
INSERT INTO order_items (order_id, id_product, quantity, unit_price) VALUES
(4, 5, 1, 8.99),   -- Chicken Burger
(4, 7, 1, 1.50);   -- Water

INSERT INTO orders (id_employee, customer_id, pickup_mode, q_pizzas, q_burguers, q_beverages, total_price) VALUES
(3, 3, 'delivery', 1, 1, 1, 26.48);  -- Alice Blue's order
-- Insert order items
INSERT INTO order_items (order_id, id_product, quantity, unit_price) VALUES
(5, 3, 1, 13.99),  -- Vegetarian Pizza
(5, 4, 1, 9.99),   -- Classic Burger
(5, 6, 1, 2.50);   -- Coke

INSERT INTO orders (id_employee, customer_id, pickup_mode, q_pizzas, q_burguers, q_beverages, total_price) VALUES
(4, 3, 'take away', 2, 0, 0, 25.98);  -- Alice Blue's order
-- Insert order items
INSERT INTO order_items (order_id, id_product, quantity, unit_price) VALUES
(6, 1, 2, 12.99);  -- Special Pizza

INSERT INTO orders (id_employee, customer_id, pickup_mode, q_pizzas, q_burguers, q_beverages, total_price) VALUES
(6, 4, 'delivery', 2, 0, 1, 28.48);  -- Bob Green's order
-- Insert order items
INSERT INTO order_items (order_id, id_product, quantity, unit_price) VALUES
(7, 1, 2, 12.99),  -- Special Pizza
(7, 6, 1, 2.50);   -- Coke

INSERT INTO orders (id_employee, customer_id, pickup_mode, q_pizzas, q_burguers, q_beverages, total_price) VALUES
(7, 4, 'take away', 0, 1, 1, 10.49);  -- Bob Green's order
-- Insert order items
INSERT INTO order_items (order_id, id_product, quantity, unit_price) VALUES
(8, 5, 1, 8.99),   -- Chicken Burger
(8, 7, 1, 1.50);   -- Water

INSERT INTO orders (id_employee, customer_id, pickup_mode, q_pizzas, q_burguers, q_beverages, total_price) VALUES
(4, 5, 'delivery', 1, 1, 1, 23.48);  -- Charlie Yellow's order
-- Insert order items
INSERT INTO order_items (order_id, id_product, quantity, unit_price) VALUES
(9, 3, 1, 13.99),  -- Vegetarian Pizza
(9, 4, 1, 9.99),   -- Classic Burger
(9, 6, 1, 2.50);   -- Coke

INSERT INTO orders (id_employee, customer_id, pickup_mode, q_pizzas, q_burguers, q_beverages, total_price) VALUES
(3, 5, 'take away', 2, 0, 0, 25.98);  -- Charlie Yellow's order
-- Insert order items
INSERT INTO order_items (order_id, id_product, quantity, unit_price) VALUES
(10, 1, 2, 12.99); -- Special Pizza

INSERT INTO orders (id_employee, customer_id, pickup_mode, q_pizzas, q_burguers, q_beverages, total_price) VALUES
(8, 6, 'delivery', 2, 0, 1, 28.48);  -- Eve White's order
-- Insert order items
INSERT INTO order_items (order_id, id_product, quantity, unit_price) VALUES
(11, 1, 2, 12.99), -- Special Pizza
(11, 6, 1, 2.50);  -- Coke

INSERT INTO orders (id_employee, customer_id, pickup_mode, q_pizzas, q_burguers, q_beverages, total_price) VALUES
(7, 6, 'take away', 0, 1, 1, 10.49);  -- Eve White's order
-- Insert order items
INSERT INTO order_items (order_id, id_product, quantity, unit_price) VALUES
(12, 5, 1, 8.99),  -- Chicken Burger
(12, 7, 1, 1.50);  -- Water


INSERT INTO deliveries (order_id, id_employee, delivery_time) VALUES
(1, 3, '2024-09-18 11:25:02'),
(2, 4, '2024-09-18 11:25:02'),
(3, 7, '2024-09-18 11:25:02'),
(4, 8, '2024-09-18 11:25:02'),
(5, 4, '2024-09-18 11:25:02'),
(6, 3, '2024-09-18 11:25:02'),
(7, 7, '2024-09-18 11:25:02'),
(8, 8, '2024-09-18 11:25:02'),
(9, 4, '2024-09-18 11:25:02'),
(10, 3, '2024-09-18 11:25:02'),
(11, 7, '2024-09-18 11:25:02'),
(12, 8, '2024-09-18 11:25:02');


/*

2 FORMAS DE MANTENER LOS RESÚMENES DE VENTAS ACTUALIZADOS

*********************************************

1 : ACTUALIZAR A TRAVÉS DE UN UPDATE CADA VEZ QUE SE EFECTÚE UNA VENTA

UPDATE sales s
JOIN (
    SELECT id_sale, SUM(price) AS total_price
    FROM sale_items
    GROUP BY id_sale
) si ON s.id_sale = si.id_sale
SET s.total_sale = si.total_price;

UPDATE employees e
JOIN (
    SELECT id_employee, SUM(total_sale) AS total_sales
    FROM sales
    GROUP BY id_employee
) s ON e.id_employee = s.id_employee
SET e.sales_current_year = s.total_sales;

*********************************************

2 : USAR TRIGGERS

Trigger to update sales.total_sale based on the sum of sale_items.price:

DELIMITER $$

CREATE TRIGGER update_sales_total
AFTER INSERT OR UPDATE ON sale_items
FOR EACH ROW
BEGIN
    DECLARE total DECIMAL(7,2);
    SELECT IFNULL(SUM(price), 0) INTO total
    FROM sale_items
    WHERE id_sale = NEW.id_sale;

    UPDATE sales
    SET total_sale = total
    WHERE id_sale = NEW.id_sale;
END$$

DELIMITER ;

---------------

Trigger to update employees.sales_current_year based on the sum of sales.total_sale:

DELIMITER $$

CREATE TRIGGER update_employee_sales_total
AFTER INSERT OR UPDATE ON sales
FOR EACH ROW
BEGIN
    DECLARE total DECIMAL(8,2);
    SELECT IFNULL(SUM(total_sale), 0) INTO total
    FROM sales
    WHERE id_employee = NEW.id_employee;

    UPDATE employees
    SET sales_current_year = total
    WHERE id_employee = NEW.id_employee;
END$$

DELIMITER ;

*/
