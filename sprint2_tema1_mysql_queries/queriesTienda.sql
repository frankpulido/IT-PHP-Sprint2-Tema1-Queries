USE scheme_tienda;


// 1- Listar "nombre" de los productos en la Tabla Productos
SELECT `nombre` FROM `producto` ORDER BY `nombre`;
/* La referencia a los atributos funciona con comillas simples, dobles o sin comillas : Preguntar a Rubén que es lo más conveniente a adoptar como norma */

// 2- Listar nombres y precios de los productos en la Tabla Productos
SELECT `nombre`, `precio` FROM `producto` ORDER BY `nombre`;

// 3- Listar TODA la información de la Tabla Producto, sin ordenar
SELECT * FROM `producto`;

// 3?- Listar los campos (nombres de las columnas) de la Tabla Producto
SHOW COLUMNS FROM `producto`;

// 4- Listar nombres y precios en € y USD de los productos en la Tabla Productos
SELECT `nombre`, `precio` AS €, ROUND(`precio`*1.11,2) AS USD FROM `producto`;

// 5- Listar TODOS los productos de la Tabla Productos : nombres y precios en € y USD (usando aliases)
SELECT `nombre` AS `nombre de producto`, `precio` AS euros, ROUND(`precio`*1.11,2) AS `dólares americanos` FROM `producto`;

// 6- Listar nombres y precios de TODOS los productos de la Tabla Producto, mostrando los nombres en mayúsculas
SELECT UPPER(`nombre`) AS productos, ROUND (`precio`,2) AS `precio €` FROM producto;

// 7- Listar nombres y precios de TODOS los productos de la Tabla Producto, mostrando los nombres en minúsculas
SELECT LOWER(`nombre`) AS productos, ROUND (`precio`,2) AS `precio €` FROM producto;

// 8- Lista el nombre de TODOS los fabricantes en una columna y los 2 primeros caracteres del nombre en mayúsculas en otra columna, Tabla Fabricante
SELECT `nombre`, UPPER(SUBSTRING(`nombre`,1,2)) AS cod FROM `fabricante`;

// 9- Listar los nombres y precios de TODOS los productos de la Tabla Producto redondeando el precio
SELECT `nombre`, ROUND(`precio`) FROM producto;

// 10 - Listar los nombres y precios de TODOS los productos de la Tabla Producto truncando el precio sin decimales
SELECT `nombre`, TRUNCATE(`precio`,0) FROM producto;

// 11- Listar el código de los fabricantes de la Tabla Producto que tienen productos en la Tabla Producto
// ANTES DE LA CORRECCIÓN : SELECT fabricante.codigo FROM fabricante INNER JOIN producto WHERE fabricante.codigo = producto.codigo_fabricante;
SELECT producto.codigo_fabricante FROM producto;

// 12- Listar el código de los fabricantes de la Tabla Producto que tienen productos en la Tabla Producto, evitando repetir códigos
// ANTES DE LA CORRECCIÓN : SELECT fabricante.codigo FROM fabricante INNER JOIN producto WHERE fabricante.codigo = producto.codigo_fabricante GROUP BY fabricante.codigo; 
SELECT producto.codigo_fabricante FROM producto GROUP BY producto.codigo_fabricante;

// 13- Listar los nombres de los fabricantes ordenados de forma ascendente
SELECT * FROM fabricante ORDER BY `nombre`;

// 14- Listar los nombres de los fabricantes ordenados de forma descendente
SELECT * FROM fabricante ORDER BY `nombre` DESC;

// 15- Listar los nombres de los productos en 2 columnas, la primera en orden alfabético ascendente, la segunda en orden de precio descendente
/* Casi lo he conseguido, pero debo mantener sólo la primera ocurrencia de cada valor de la columna 1 (query1). GROUP BY query1.nombre NO FUNCIONA : */
SELECT query1.nombre AS orderAZ , query2.nombre AS orderPriceDesc FROM producto query1 CROSS JOIN producto query2 ORDER BY query1.nombre ASC, query2.precio DESC;

/* SELF JOIN : https://www.youtube.com/watch?v=7S_tz1z_5bA
IR A MINUTO : 1:33:00
NO FUNCIONA (usa el primer ORDER BY para ambas columnas) : SELECT `nombre` AS `query 1` , `nombre` AS `query 2` FROM producto ORDER BY `nombre` ASC, `precio` DESC;
UNION ALL (no funciona) : (SELECT `nombre` AS `query 1` FROM tienda.producto ORDER BY `nombre`) UNION ALL (SELECT `nombre` AS `query 2` FROM tienda.producto ORDER BY `precio` DESC);
*/

// 16- Retornar una lista con las 5 primeras filas de la Tabla Fabricante.
SELECT * FROM fabricante LIMIT 5;

// 17- Listar la cuarta y la quinta fila de la Tabla Fabricante
SELECT * FROM fabricante LIMIT 3,2;

// 18- Listar el nombre y el precio del producto más barato usando ORDER BY y LIMIT
SELECT `nombre`, `precio` FROM producto ORDER BY `precio` LIMIT 1;

// 19- Listar el nombre y el precio del producto más caro usando ORDER BY y LIMIT
SELECT `nombre`, `precio` FROM producto ORDER BY `precio` DESC LIMIT 1;

// 20- Listar el nombre de todos los productos de la Tabla Producto cuyo código de fabricante es igual a 2
SELECT * FROM producto WHERE `codigo_fabricante` IN(2);
// podía haber hecho "codigo_fabricante" = 2, pero no habría usado IN en ningún query...

// 21- Retornar un listado con todos los nombres de producto, precio y nombre del fabricante de la Tabla Productos.
SELECT p.nombre, p.precio, f.nombre AS fabricante FROM producto p LEFT JOIN fabricante f ON p.codigo_fabricante = f.codigo;

// 22- Retornar un listado con todos los nombres de producto, precio y nombre del fabricante de la Tabla Productos. Ordenar alfabéticamente por nombre del fabricante
SELECT f.nombre AS fabricante, p.nombre, p.precio FROM producto p LEFT JOIN fabricante f ON p.codigo_fabricante = f.codigo ORDER BY f.nombre;

// 23- Retornar un listado con el código de producto, nombre del producto, código del fabricante y nombre del fabricante, de todos los productos de la base de datos.
SELECT p.codigo AS cod_producto, p.nombre AS producto, p.codigo_fabricante AS cod_fabricante, f.nombre AS fabricante FROM producto p LEFT JOIN fabricante f ON p.codigo_fabricante = f.codigo;

// 24- Retorna el nombre del producto, el precio y el nombre del fabricante del producto más barato.
SELECT p.nombre AS producto, p.precio AS "precio €", f.nombre AS fabricante FROM producto p JOIN fabricante f ORDER BY p.precio ASC LIMIT 1;

// 25- Retorna el nombre del producto, el precio y el nombre del fabricante del producto más caro.
SELECT p.nombre AS producto, p.precio AS "precio €", f.nombre AS fabricante FROM producto p JOIN fabricante f ORDER BY p.precio DESC LIMIT 1;

// 26- Retorna un listado de todos los productos del fabricante Lenovo.
SELECT p.nombre AS "productos de Lenovo" FROM producto p JOIN fabricante f ON p.codigo_fabricante = f.codigo WHERE f.nombre = "Lenovo";

// 27- Retorna un listado de todos los productos del fabricante Crucial cuyo precio sea mayor de 200 €.
SELECT p.nombre AS "Crucial > 200 €" FROM producto p JOIN fabricante f ON p.codigo_fabricante = f.codigo WHERE f.nombre = "Crucial" AND p.precio > 200;

// 28- Retorna un listado de todos los productos del fabricante Asus, Hewlett-Packard y Seagate (sin utilizar el operador IN).
SELECT p.nombre, f.nombre FROM producto p JOIN fabricante f ON p.codigo_fabricante = f.codigo WHERE f.nombre = "Asus" OR f.nombre = "Hewlett-Packard" OR f.nombre = "Seagate";

// 29- Retorna un listado de todos los productos del fabricante Asus, Hewlett-Packard y Seagate. Usa el operador IN.
SELECT p.nombre, f.nombre FROM producto p JOIN fabricante f ON p.codigo_fabricante = f.codigo WHERE f.nombre IN ("Asus", "Hewlett-Packard", "Seagate");

// 30- Retorna un listado con el nombre y el precio de todos los productos de los fabricantes cuyo nombre termine en la vocal "e".
SELECT p.nombre AS producto, ROUND(p.precio, 2) AS 'precio €', f.nombre AS fabricante FROM producto p JOIN fabricante f ON p.codigo_fabricante = f.codigo WHERE f.nombre LIKE "%e"; 

// 31- Retorna un listado con el nombre y el precio de todos los productos de los fabricantes cuyo nombre contenga el caracter "w".
SELECT p.nombre AS producto, ROUND(p.precio, 2) AS 'precio €', f.nombre AS fabricante FROM producto p JOIN fabricante f ON p.codigo_fabricante = f.codigo WHERE f.nombre LIKE "%w%";

// 32- Retorna un listado que contenga el nombre del producto, precio y nombre del fabricante, de todos los productos que tengan un precio mayor o igual a 180 €. Ordena el resultado en primer lugar por precio (en orden descendente) y en segundo lugar por su nombre (en orden ascendente).
SELECT p.nombre AS producto, ROUND(p.precio, 2) AS 'precio €', f.nombre AS fabricante FROM producto p JOIN fabricante f ON p.codigo_fabricante = f.codigo WHERE p.precio > 180 ORDER BY p.precio DESC, p.nombre ASC;

// 33- Retorna un listado con el código y el nombre de los fabricantes que tengan productos asociados en la base de datos.
SELECT f.codigo, f.nombre AS 'fabricante' FROM fabricante f JOIN producto p ON f.codigo = p.codigo_fabricante GROUP BY f.nombre;

// 34- Retorna un listado de todos los fabricantes en la base de datos y sus productos asociados, aún cuando no exista ninguno.
SELECT f.nombre AS 'fabricante', p.nombre AS producto FROM fabricante f LEFT JOIN producto p ON f.codigo = p.codigo_fabricante;
/* Mejorar 34, la salida es correcta */

// 35- Retorna un listado con los fabricantes sin productos asociados.
SELECT f.nombre AS 'fabricante' FROM fabricante f LEFT JOIN producto p ON f.codigo = p.codigo_fabricante WHERE p.codigo_fabricante IS NULL; 

// 36- Retorna un listado con todos los productos del fabricante Lenovo. (Sin utilizar INNER JOIN).
SELECT p.nombre FROM producto p LEFT JOIN fabricante f ON p.codigo_fabricante = f.codigo WHERE f.nombre = "Lenovo";

// 37- Retorna un listado con todos los datos de los productos que tienen el mismo precio que el producto más caro del fabricante Lenovo. (Sin utilizar INNER JOIN).
SELECT * FROM producto p LEFT JOIN fabricante f ON p.codigo_fabricante = f.codigo WHERE f.nombre != "Lenovo" AND p.precio = (SELECT MAX(p1.precio) FROM producto p1 LEFT JOIN fabricante f1 ON p1.codigo_fabricante = f1.codigo WHERE f1.nombre = "Lenovo");
/*
FUNCIONA : Es necesario modificar algún precio de los otros productos (precio = 559) para conseguir un output 
*/

// 38- Retorna el producto más caro del fabricante Lenovo.
A
SELECT p.nombre AS "Lenovo TOP product", MAX(p.precio) AS "MAX price in stock" FROM producto p LEFT JOIN fabricante f ON p.codigo_fabricante = f.codigo WHERE f.nombre = "Lenovo";
B Sin indicar precio
SELECT p.nombre AS "Lenovo TOP product" FROM producto p LEFT JOIN fabricante f ON p.codigo_fabricante = f.codigo WHERE f.nombre = "Lenovo" ORDER BY p.precio DESC LIMIT 1;

// 39- Retorna el nombre del producto más barato del fabricante Hewlett-Packard.
A
SELECT p.nombre AS "Hewlett-Packard cheapest product", MIN(p.precio) AS "MIN price in stock" FROM producto p LEFT JOIN fabricante f ON p.codigo_fabricante = f.codigo WHERE f.nombre = "Hewlett-Packard";
B Sin indicar precio
SELECT p.nombre AS "Hewlett-Packard cheapest product" FROM producto p LEFT JOIN fabricante f ON p.codigo_fabricante = f.codigo WHERE f.nombre = "Hewlett-Packard" ORDER BY p.precio ASC LIMIT 1;

// 40- Retorna todos los productos de la base de datos que tengan un precio mayor o igual al del producto més caro del fabricante Lenovo.
SELECT * FROM producto p WHERE p.precio > (SELECT MAX(p.precio) FROM producto p JOIN fabricante f ON p.codigo_fabricante = f.codigo WHERE f.nombre LIKE "Lenovo");

// 41- Retorna un listado con todos los productos del fabricante Asus cuyo precio sea mayor al precio medio de la totalidad de sus productos.
SELECT * FROM producto p JOIN fabricante f ON p.codigo_fabricante = f.codigo WHERE f.nombre LIKE "Asus" AND p.precio > (SELECT AVG(p.precio) FROM producto p JOIN fabricante f ON p.codigo_fabricante = f.codigo WHERE f.nombre LIKE "Asus");
