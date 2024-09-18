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
Cuando se piensa usar algunas columnas para hace SEARCH las definimos de tipo INDEX,
Por defecto el PRIMARY KEY queda siempre definido como INDEX.

****************

LECCIONES APRENDIDAS :
1) Las Tablas que hacen uso de FOREIGN KEYS deben declararse de forma ulterior a las que contienen las PRIMARY KEYS de las que hacen uso.
2) La PRIMARY KEY COMPUESTA de una Tabla relacional de 2 entidades debe declararse como primera instrucción debajo de CREATE TABLE.

**********************************

TABLA sale_items
Existen 2 FOREIGN KEYS son combinadas en 1 PRIMARY KEY
id_sale REFERENCES sales(id_sale)
id_product REFERENCES products(id_product)

**********************************

PENDIENTE DE RESOLVER
La creación del registro de cada venta en la Tabla SALES se hace sin suministrar el último atributo : total_sale
Es necesario programar 2 cosas en la Base de Datos para que funcione correctamente :

1) LAST_INSERT_ID
2) TRIGGER
PARENT-CHILD (Tabla ORDERS - Tabla ORDER_ITEMS) : 2:39:08 -> https://youtu.be/7S_tz1z_5bA?t=9549

LAST_INSERT_ID : Esta instrucción debe retornar el PK del último registro de Tabla SALES para usarlo en la creación de nuevos registros en Tabla SALE_ITEMS.
Todos los productos (registros) que agreguemos a la Tabla SALE_ITEMS se hacen SIN indicar atributo "id_sale" que SE HEREDA de SALES con la instrucción LAST_INSERT_ID.
Mientras no se abra un nuevo registro en la Tabla SALES se usará dicho id, dado que no se habrá cerrado la venta.

TRIGGER : Cada nueva entrada de datos (INSERT INTO) hecha en la Tabla SALE_ITEMS debe desencadenar una actualización del campo total_sale de la Tabla SALES (ON
sale_items.id_sale = sales.id_sale).
*/

DROP DATABASE IF EXISTS optica;
CREATE DATABASE optica CHARACTER SET utf8mb4;


USE optica;

CREATE TABLE suppliers (
    id_supplier INT(11) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    commercial_name VARCHAR(50) NOT NULL,
    address_street_name VARCHAR(30) NOT NULL,
    address_st_number TINYINT(4) NOT NULL,
    address_floor TINYINT(2) NOT NULL,
    address_door TINYINT(2) NOT NULL,
    address_country VARCHAR(30) NOT NULL,
    address_city VARCHAR(30) NOT NULL,
    address_cp CHAR(5) NOT NULL,
    phone VARCHAR(9) NOT NULL,
    nif VARCHAR(30) UNIQUE NOT NULL
);

CREATE TABLE products (
    id_product SMALLINT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    sku_supplier VARCHAR(50) UNIQUE NOT NULL,
    model  VARCHAR(25) NOT NULL,
    frame_type ENUM('no-frame', 'metallic', 'acetate') NOT NULL,
    frame_colour VARCHAR(25) NOT NULL,
    left_colour VARCHAR(25) NULL,
    right_colour VARCHAR(25) NULL,
    price DECIMAL(7,2) NOT NULL,
    id_supplier INT(11) UNSIGNED NOT NULL,
    FOREIGN KEY (id_supplier) REFERENCES suppliers(id_supplier) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE customers (
    id_customer INT(11) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    last_name1 VARCHAR(30) NOT NULL,
    last_name2 VARCHAR(30) NULL,
    mobile VARCHAR(9) NOT NULL,
    mail VARCHAR(60) NULL,
    date_signup DATE NOT NULL,
    customer_nif VARCHAR(9) UNIQUE NOT NULL
);

CREATE TABLE employees (
    id_employee SMALLINT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    emp_name VARCHAR(30) NOT NULL,
    emp_last_name VARCHAR(30) NOT NULL,
    date_on_board DATE NOT NULL,
    sales_current_year DECIMAL(8,2) NULL,
    sales_last_year DECIMAL(8,2) NULL
);

CREATE TABLE sales (
    id_sale INT(11) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    date_sale DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_customer INT(11) UNSIGNED NOT NULL,
    FOREIGN KEY (id_customer) REFERENCES customers(id_customer) ON DELETE NO ACTION ON UPDATE CASCADE,
    id_employee SMALLINT(6) UNSIGNED NOT NULL,
    FOREIGN KEY (id_employee) REFERENCES employees(id_employee) ON DELETE NO ACTION ON UPDATE CASCADE,
    total_sale DECIMAL(7,2) NULL DEFAULT 0
);

/*
El atributo sales.total_sale debe actualizarse con un TRIGGER cada vez que se crea un registro en sale_items con (sale_items.id_sale = sales.id_sale)
El TRIGGER se crea para la Tabla sale_items.
*/

CREATE TABLE sale_items (
    PRIMARY KEY (id_sale, id_product),
    id_sale INT(11) UNSIGNED NOT NULL,
    FOREIGN KEY (id_sale) REFERENCES sales(id_sale) ON DELETE CASCADE ON UPDATE CASCADE,
    id_product SMALLINT(6) UNSIGNED NOT NULL,
    FOREIGN KEY (id_product) REFERENCES products(id_product) ON DELETE RESTRICT ON UPDATE CASCADE,
    quantity TINYINT(2) UNSIGNED NOT NULL,
    grad_left VARCHAR(5) NOT NULL,
    grad_right VARCHAR(5) NOT NULL,
    colour_left VARCHAR(20) NOT NULL,
    colour_right VARCHAR(20) NOT NULL,
    price DECIMAL(7,2) NOT NULL
);

/*
En la Tabla anterior se crea un PRIMARY KEY compuesto de los 2 FOREIGN KEYS : (id_sale, id_product)
id_sale se HEREDA de la Tabla sales usando la instrucción : LAST_INSERT_ID (aún no sé cómo).
Un mismo id_sale puede formar distintas PRIMARY KEY combinándose con distintos id_product de la misma venta, pero nunca habrá 2 PRIMARY KEY iguales. De introducir 2 productos iguales en la misma orden estamos incrementando sale_items.quantity... (dejo unas gafas extras en el coche o la oficina).
TRIGGER : Cada vez que introducimos un nuevo registro en esta tabla (SALE_ITEMS) deberemos usar algo así :
sales.total_sale = SUM(sale_items.quantity * sale_items.price) WHERE sale_items.id_sale = sales.id_sale
*/

CREATE TABLE referrals (
    PRIMARY KEY (id_customer_declares, being_referred_by_nif),
    id_customer_declares INT(11) UNSIGNED UNIQUE NOT NULL,
    FOREIGN KEY (id_customer_declares) REFERENCES customers (id_customer) ON DELETE RESTRICT ON UPDATE CASCADE,
    being_referred_by_nif VARCHAR(9) NOT NULL,
    FOREIGN KEY (being_referred_by_nif) REFERENCES customers (customer_nif) ON DELETE RESTRICT ON UPDATE CASCADE
);


-- Suppliers
INSERT INTO suppliers (commercial_name, address_street_name, address_st_number, address_floor, address_door, address_country, address_city, address_cp, phone, nif)
VALUES 
('VisionWorld', 'Main St', 12, 3, 2, 'Spain', 'Madrid', '28001', '912345678', 'B12345678'),
('EyeCare', '2nd Ave', 45, 1, 1, 'Spain', 'Barcelona', '08001', '934567891', 'B87654321'),
('LensCraft', 'Park Blvd', 23, 4, 3, 'Spain', 'Sevilla', '41001', '955678912', 'B11223344');

-- Customers
INSERT INTO customers (first_name, last_name1, last_name2, mobile, mail, date_signup, customer_nif)
VALUES 
('John', 'Doe', 'Smith', '600123456', 'john.doe@mail.com', '2024-01-15', '12345678A'),
('Jane', 'Doe', 'Brown', '600123457', 'jane.doe@mail.com', '2024-01-16', '23456789B'),
('Alice', 'Johnson', 'White', '600123458', 'alice.johnson@mail.com', '2024-01-17', '34567890C'),
('Bob', 'Williams', 'Gray', '600123459', 'bob.williams@mail.com', '2024-01-18', '45678901D'),
('Charlie', 'Davis', 'Green', '600123460', 'charlie.davis@mail.com', '2024-01-19', '56789012E'),
('David', 'Miller', 'Black', '600123461', 'david.miller@mail.com', '2024-01-20', '67890123F'),
('Eve', 'Garcia', 'Martinez', '600123462', 'eve.garcia@mail.com', '2024-01-21', '78901234G'),
('Frank', 'Lopez', 'Hernandez', '600123463', 'frank.lopez@mail.com', '2024-01-22', '89012345H'),
('Grace', 'Martinez', 'Diaz', '600123464', 'grace.martinez@mail.com', '2024-01-23', '47886327M'),
('Hank', 'Perez', 'Sanchez', '600123465', 'hank.perez@mail.com', '2024-01-24', '71275217B');

-- Employees
INSERT INTO employees (emp_name, emp_last_name, date_on_board, sales_current_year, sales_last_year)
VALUES 
('Emily', 'Rodriguez', '2023-01-10', 769.94, 5000.00),
('Lucas', 'Martinez', '2022-05-12', 529.96, 8000.00),
('Olivia', 'Hernandez', '2023-03-20', 399.97, 6000.00);

-- Products for each supplier
INSERT INTO products (sku_supplier, model, frame_type, frame_colour, left_colour, right_colour, price, id_supplier)
VALUES
-- Products for Supplier 1
('VW1001', 'Model A', 'acetate', 'black', 'blue', 'blue', 99.99, 1),
('VW1002', 'Model B', 'metallic', 'silver', 'green', 'green', 149.99, 1),
('VW1003', 'Model C', 'acetate', 'brown', 'yellow', 'yellow', 129.99, 1),
('VW1004', 'Model D', 'metallic', 'gold', 'red', 'red', 179.99, 1),
('VW1005', 'Model E', 'acetate', 'gray', 'black', 'black', 109.99, 1),
('VW1006', 'Model F', 'metallic', 'blue', 'blue', 'blue', 159.99, 1),
('VW1007', 'Model G', 'acetate', 'green', 'green', 'green', 119.99, 1),
('VW1008', 'Model H', 'metallic', 'red', 'red', 'red', 139.99, 1),
('VW1009', 'Model I', 'acetate', 'purple', 'purple', 'purple', 89.99, 1),
('VW1010', 'Model J', 'metallic', 'black', 'black', 'black', 169.99, 1),

-- Products for Supplier 2
('EC2001', 'Model K', 'acetate', 'blue', 'blue', 'blue', 99.99, 2),
('EC2002', 'Model L', 'metallic', 'silver', 'silver', 'silver', 149.99, 2),
('EC2003', 'Model M', 'acetate', 'green', 'green', 'green', 129.99, 2),
('EC2004', 'Model N', 'metallic', 'gold', 'gold', 'gold', 179.99, 2),
('EC2005', 'Model O', 'acetate', 'red', 'red', 'red', 109.99, 2),
('EC2006', 'Model P', 'metallic', 'black', 'black', 'black', 159.99, 2),
('EC2007', 'Model Q', 'acetate', 'purple', 'purple', 'purple', 119.99, 2),
('EC2008', 'Model R', 'metallic', 'green', 'green', 'green', 139.99, 2),
('EC2009', 'Model S', 'acetate', 'yellow', 'yellow', 'yellow', 89.99, 2),
('EC2010', 'Model T', 'metallic', 'orange', 'orange', 'orange', 169.99, 2),

-- Products for Supplier 3
('LC3001', 'Model U', 'acetate', 'black', 'blue', 'blue', 99.99, 3),
('LC3002', 'Model V', 'metallic', 'silver', 'green', 'green', 149.99, 3),
('LC3003', 'Model W', 'acetate', 'brown', 'yellow', 'yellow', 129.99, 3),
('LC3004', 'Model X', 'metallic', 'gold', 'red', 'red', 179.99, 3),
('LC3005', 'Model Y', 'acetate', 'gray', 'black', 'black', 109.99, 3),
('LC3006', 'Model Z', 'metallic', 'blue', 'blue', 'blue', 159.99, 3),
('LC3007', 'Model AA', 'acetate', 'green', 'green', 'green', 119.99, 3),
('LC3008', 'Model AB', 'metallic', 'red', 'red', 'red', 139.99, 3),
('LC3009', 'Model AC', 'acetate', 'purple', 'purple', 'purple', 89.99, 3),
('LC3010', 'Model AD', 'metallic', 'black', 'black', 'black', 169.99, 3);

-- Sales for each customer (randomized)
INSERT INTO sales (id_customer, id_employee, total_sale)
VALUES
(1, 1, 349.97),
(2, 2, 289.98),
(3, 3, 159.99),
(4, 1, 119.99),
(5, 2, 139.99),
(6, 3, 89.99),
(7, 1, 169.99),
(8, 2, 99.99),
(9, 3, 149.99),
(10, 1, 129.99);

-- Sale items for each sale
INSERT INTO sale_items (id_sale, id_product, quantity, grad_left, grad_right, colour_left, colour_right, price)
VALUES
(1, 1, 2, '-1.25', '-1.00', 'blue', 'blue', 99.99),
(1, 2, 1, '-1.50', '-1.75', 'green', 'green', 149.99),
(1, 3, 1, '-1.00', '-1.25', 'yellow', 'yellow', 99.99),
(2, 4, 1, '-2.00', '-2.25', 'red', 'red', 179.99),
(2, 5, 1, '-2.25', '-2.50', 'black', 'black', 109.99),
(3, 6, 1, '-0.75', '-0.50', 'blue', 'blue', 159.99),
(4, 7, 1, '-1.00', '-1.50', 'green', 'green', 119.99),
(5, 8, 1, '-2.00', '-2.25', 'red', 'red', 139.99),
(6, 9, 1, '-2.50', '-2.75', 'purple', 'purple', 89.99),
(7, 10, 1, '-1.75', '-1.50', 'black', 'black', 169.99),
(8, 11, 1, '-0.25', '-0.50', 'blue', 'blue', 99.99),
(9, 12, 1, '-1.50', '-1.25', 'green', 'green', 149.99),
(10, 13, 1, '-2.00', '-2.25', 'yellow', 'yellow', 129.99);


-- Referrals
INSERT INTO referrals (id_customer_declares, being_referred_by_nif) VALUES
(10, '23456789B'),
(9, '45678901D'),
(8, '34567890C'),
(7, '34567890C'),
(3, '12345678A'),
(2, '12345678A');