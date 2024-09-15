<?php
/*
Queries de la SEGUNDA Base de Datos : squema_universidad.sql
RESOURCE TUTORIAL WorkBench : https://www.youtube.com/watch?v=7S_tz1z_5bA
RESOURCES QUERY ATTRIBUTES :
https://dev.mysql.com/doc/refman/8.4/en/query-attributes.html

Different kinds of JOIN :
    (INNER) JOIN
    LEFT (OUTER) JOIN
    RIGHT (OUTER) JOIN
    FULL (OUTER) JOIN
    CROSS JOIN

ALL JOINS : https://www.stratascratch.com/blog/different-types-of-sql-joins-that-you-must-know/
EJEMPLOS SELF-JOIN : https://www.stratascratch.com/blog/illustrated-guide-about-self-join-in-sql/

-------------------------------------------------------------------

RESOURCE : https://www.youtube.com/watch?v=7S_tz1z_5bA

INDEX :
JOIN (SAME DATABASE, 2 DIFFERENT TABLES) : 1:24:54 -> https://www.youtube.com/watch?v=7S_tz1z_5bA
JOIN (ACROSS DIFFERENT DATABASES, 2 DIFFERENT TABLES) : 1:33:22 -> https://www.youtube.com/watch?v=7S_tz1z_5bA
SELF JOIN (SAME DATABASE, SAME TABLE) : 1:36:08 -> https://www.youtube.com/watch?v=7S_tz1z_5bA
INNER JOINNING MORE THAN 2 TABLES (SAME DATABASE, DIFFERENT TABLES - MORE THAN 2) : 1:40:25 -> 
COMPOUND JOIN CONDITIONS : 1:47:08 -> 
COMPOSITE PRIMARY KEY (combinación de valores de 2 columnas) : 1:47:08 -> 
IMPLICIT JOIN SYNTAX : 1:50:52 -> 
OUTER JOINS (SAME DATABASE, DIFFERENT TABLES) : 1:53:13 -> 
OUTER JOINNING MORE THAN 2 TABLES (SAME DATABASE, DIFFERENT TABLES - MORE THAN 2) : 1:59:40 -> 
SELF OUTER JOIN (SAME DATABASE, SAME TABLE) : 2:06:00 -> 
***
USING clause : 2:08:11 -> 
USING clause con claves primarias compuestas -> 2:10:00
***
NATURAL JOINS : 2:13:32 -> 
CROSS JOINS : 2:14:53 -> 
***
UNIONS (SAME DATABASE, SAME TABLE) : 2:18:10 -> 
UNIONS (SAME DATABASE, 2+ DIFFERENT TABLES) : 2:21:55 -> 
************
COLUMN ATTRIBUTES / INSERTING ROWS : 2:26:40 -> 
INSERTING HIERARCHICAL ROWS (MULTIPLE TABLES) : 2:39:08 -> 
CREATING A COPY OF A TABLE : 2:45:00 -> 
UPDATING A ROW : 2:53:48 -> 
DELETING A ROW : 3:06:37 -> 
RESTORING A DATABASE : 3:08:00 -> 
************
USING SUB-QUERIES : 2:46:55 -> 
USING SUB-QUERIES IN UPDATES : 3:01:00 -> 

-------------------------------------------------------------------

RESOURCES :
https://disenowebakus.net/tipos-de-datos-mysql.php#google_vignette
https://disenowebakus.net/llevando-datos-de-la-base-mysql-a-las-paginas-php.php

******
Tipos de datos en SQL

TINYINT (-128 hasta 127) - SMALLINT (-32768 hasta 32767) - MEDIUMINT - INT - BIGINT
Se puede especificar longitud en numero de caracteres

FLOAT - DOUBLE - DECIMAL
Se puede especificar longitud en número TOTAL de caracteres (incluido el punto), añadiendo cuantos van después del punto. (7,2) = 9999.99 máximo
Usar DOUBLE en lugar de FLOAT porque las operaciones emplean FLOAT y se puede perder precisión
DECIMAL : Ideal para PRECIOS

DATE (YYYY-MM-DD) - DATETIME (YYYY-MM-DD HH:MM:SS) - TIME (HH-MM-SS) - TIMESTAMP - YEAR
DATE : se puede separar con cualquier símbolo (no sólo guiones) o ninguno.
TIME : va desde -839:59:59 hasta 839:59:59 (unos 35 días hacia atrás y hacia adelante de la fecha actual)
TIMESTAMP : podemos definir que su valor se mantenga actualizado automáticamente,cada vez que se inserte o que se actualice un registro.
    Seleccionar en Atributos la opción "on update" CURRENT_TIMESTAMP, y como valor predeterminado CURRENT_TIMESTAMP.
    Formatos :
    AAAA-MM-DD HH:MM:SS
    AAAA-MM-DD
    AA-MM-DD
PHP : Generamos TIMESTAMP con la función TIME almacenado en un INT de 10 dígitos.

CHAR : cuando conocemos exactamente la longitud, se lo contrario perdemos el exceso. Ejemplo : código cuenta bancaria.
VARCHAR : para el resto de los textos.
ENUM : SELECCIÓN SIMPLE. Campo obligatorio (NO NULL) con opciones predefinidas, mutuamente excluyentes. Máximo : 65535 opciones.
SET : SELECCIÓN MÚLTIPLE. Valores predefinidos, parecido a ENUM, pero con un máximo de 64, acepta tomar más de un valor y acepta también NULL.

BLOB : Manera de almacenar una imagen en código binario
Normalmente no se almacena así sino que se usa la URL de la imagen almacenada como VARCHAR

******

ATRIBUTOS - MODIFICADORES :
(INDEX, PRIMARY KEY, UNIQUE Y FULL TEXT se encuentran dentro de INDEX)
PRIMARY KEY
AUTO INCREMENT
DEFAULT
UNIQUE : se puede usar por ejemplo para el DNI del cliente sin que el campo dni sea un PK. 2 clientes no pueden tener el mismo DNI.
NO NULL
UNSIGNED : si no necesitamos usar números negativos duplica la longitud posible del tipo de variable numérica.
    TINYINT (0 - 255)
    SMALLINT (0 - 65535)
INDEX : se usa para campos comúnmente usados en búsquedas, al mantenerlos indexados se agiliza el tiempo de respuesta de dichas búsquedas. Lo que hace es crear una "tabla paralela" ordenada por el campo elegido en lugar del PK. La tabla paralela devuelve al buscador el PK del registro encontrado.
FULL TEXT : además de almacenar el texto, se almacena cada palabra en una celda de memoria, permitiendo así buscar cualquier palabra dentro del atributo del registro.
(Usarlo para la búsqueda de los títulos de las películas)
BINARY

*/
?>