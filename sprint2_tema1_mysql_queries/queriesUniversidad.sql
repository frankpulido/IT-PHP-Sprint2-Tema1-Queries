USE scheme_universidad;

/* ****** Visualizar el esquema E-R y realizar las siguientes consultas ****** */

// 1.01- Retornar listado con primer apellido, segundo apellido y nombre de todos los alumnos/as. Orden alfabético ASC : primer apellido -> segundo apellido -> nombre.
SELECT p.apellido1, p.apellido2, p.nombre FROM persona p WHERE p.tipo IN('alumno') ORDER BY p.apellido1 ASC, p.apellido2 ASC, p.nombre ASC;

// 1.02- Averigua el nombre y los apellidos de los alumnos que no han dado de alta su número de teléfono en la base de datos.
SELECT p.nombre, p.apellido1, p.apellido2 FROM persona p WHERE p.tipo IN('alumno') AND p.telefono IS NULL;

// 1.03- Retornar listado de los alumnos/as que nacieron en el año 1999.
SELECT * FROM persona p WHERE p.tipo IN ('alumno') AND p.fecha_nacimiento LIKE '1999%';

// 1.04- Retornar listado de profesores/as que no han dado de alta su número de teléfono en la base de datos y cuyo NIF termina en "K".
SELECT * FROM persona p WHERE p.tipo IN ('profesor') AND p.nif LIKE '%K' AND p.telefono IS NULL;

// 1.05- Retornar listado de las asignaturas que se imparten en el primer cuatrimestre, en el tercer curso del grado que tiene el identificador 7.
SELECT * FROM asignatura a WHERE a.cuatrimestre = 1 AND a.curso = 3 AND a.id_grado = 7;

// 1.06- Retornar listado de los profesores/as y el nombre del departamento al que pertenecen. El listado debe devolver cuatro columnas : primer apellido, segundo apellido, nombre y nombre del departamento. Orden alfabético ASC : apellidos -> nombre.
/* ANTERIOR :
SELECT p.apellido1, p.apellido2, p.nombre, d.nombre AS departamento FROM persona p JOIN profesor pro ON p.id = pro.id_profesor JOIN departamento d ON pro.id_departamento = d.id ORDER BY p.apellido1, p.apellido2, p.nombre;
*/
SELECT p.apellido1, p.apellido2, p.nombre, d.nombre AS departamento FROM persona p JOIN profesor pro ON p.id = pro.id_profesor LEFT JOIN departamento d ON pro.id_departamento = d.id ORDER BY p.apellido1, p.apellido2, p.nombre;

// 1.07- Retornar listado con el nombre de las asignaturas, año de inicio y año de fin del curso escolar del alumno/a con NIF 26902806M.
/* ANTERIOR :
SELECT * FROM persona p JOIN (SELECT ama.id_alumno, a.nombre AS asignatura, ce.anyo_inicio AS inicio, ce.anyo_fin AS final FROM asignatura a JOIN alumno_se_matricula_asignatura ama ON a.id = ama.id_asignatura JOIN curso_escolar ce ON ama.id_curso_escolar = ce.id) AS subquery ON p.id = subquery.id_alumno WHERE p.nif LIKE "26902806M";
*/
// RESTRINJO CAMPOS DE SALIDA :
SELECT subquery.asignatura, subquery.inicio, subquery.final FROM persona p JOIN (SELECT ama.id_alumno, a.nombre AS asignatura, ce.anyo_inicio AS inicio, ce.anyo_fin AS final FROM asignatura a JOIN alumno_se_matricula_asignatura ama ON a.id = ama.id_asignatura JOIN curso_escolar ce ON ama.id_curso_escolar = ce.id) AS subquery ON p.id = subquery.id_alumno WHERE p.nif LIKE "26902806M";

// 1.08- Retornar listado con el nombre de todos los departamentos que tienen profesores/as que imparten alguna asignatura del Grado en Ingeniería Informática (Plan 2015).
SELECT d.nombre FROM departamento d JOIN profesor p ON d.id = p.id_departamento JOIN asignatura a ON p.id_profesor = a.id_profesor JOIN grado g ON a.id_grado = g.id WHERE g.nombre LIKE '%Ingeniería Informática%' GROUP BY d.nombre;

// 1.09- Retornar listado con todos los alumnos/as que se han matriculado en alguna asignatura durante el curso escolar 2018/2019.
SELECT * FROM persona p JOIN alumno_se_matricula_asignatura ama ON p.id = ama.id_alumno JOIN curso_escolar ce ON ama.id_curso_escolar = ce.id WHERE ce.anyo_inicio = 2018 GROUP BY p.nombre;




/* ****** Realizar las siguientes consultas usando las cláusulas LEFT JOIN y RIGHT JOIN ****** */

// 2.01- Retornar listado con todos los profesores/as y sus departamentos (incluso si no tienen departamento asignado). Columnas/Orden ASC : nombre del departamento -> apellido1 -> apellido2 -> nombre.
SELECT d.nombre AS departamento, p.apellido1, p.apellido2, p.nombre FROM persona p JOIN profesor pro ON p.id = pro.id_profesor LEFT JOIN departamento d ON pro.id_departamento = d.id ORDER BY d.nombre, p.apellido1, p.apellido2, p.nombre;

// 2.02- Retornar listado con los profesores/as que no están asociados a ningún departamento.
SELECT * FROM persona p LEFT JOIN profesor pro ON p.id = pro.id_profesor WHERE pro.id_departamento IS NULL;

// 2.03- Retornar listado con los departamentos que no tienen profesores asociados.
/* ANTERIOR :
SELECT *
*/
SELECT d.nombre FROM departamento d LEFT JOIN profesor p ON d.id = p.id_departamento  WHERE p.id_profesor IS NULL;

// 2.04- Retornar listado listado con los profesores/as que no imparten ninguna asignatura.
SELECT pro.id_profesor, pro.id_departamento, p.apellido1, p.apellido2, p.nombre FROM persona p JOIN profesor pro ON p.id = pro.id_profesor LEFT JOIN asignatura a ON pro.id_profesor = a.id_profesor WHERE a.id_profesor IS NULL;

// 2.05- Retornar listado con las asignaturas que no tienen un profesor/a asignado.
SELECT * FROM asignatura a WHERE a.id_profesor IS NULL;

NO ES NECESARIO EL JOIN : SELECT * FROM asignatura a LEFT JOIN profesor pro ON a.id_profesor = pro.id_profesor WHERE pro.id_profesor IS NULL;

// 2.06- Retornar listado con todos los departamentos que no han impartido asignaturas en ningún curso escolar.
/* ANTERIOR :
SELECT d.nombre FROM departamento d JOIN profesor pro ON d.id = pro.id_departamento JOIN asignatura a ON pro.id_profesor = a.id_profesor LEFT JOIN alumno_se_matricula_asignatura ama ON a.id = ama.id_asignatura GROUP BY d.nombre HAVING COUNT(ama.id_curso_escolar) = 0;
*/
SELECT d.nombre FROM departamento d LEFT JOIN profesor pro ON d.id = pro.id_departamento LEFT JOIN asignatura a ON pro.id_profesor = a.id_profesor LEFT JOIN alumno_se_matricula_asignatura ama ON a.id = ama.id_asignatura GROUP BY d.nombre HAVING COUNT(ama.id_curso_escolar) = 0;



/* ****** Realiza las siguientes consultas resumen ****** */

// 3.01- Retornar el número total de alumnos
SELECT COUNT(p.id) AS 'total alumnos' FROM persona p WHERE p.tipo IN ('alumno');

// 3.02- Retornar el número de alumnos nacidos en el año 1999.
SELECT COUNT(p.id) AS 'total alumnos nacidos en 1999' FROM persona p WHERE p.tipo IN ('alumno') AND p.fecha_nacimiento LIKE "1999%";

// 3.03- Retornar listado con el número total de profesores de cada departamento ordenado por orden decreciente de número de profesores. Excluir departamentos SIN profesores asociados.
SELECT d.nombre AS 'departamento', COUNT(pro.id_profesor) AS 'profesores asociados' FROM departamento d JOIN profesor pro ON d.id = pro.id_departamento GROUP BY d.id_departamento ORDER BY COUNT(pro.id_profesor) DESC, d.nombre;
/* ÉSTA INCLIUYE DEPARTAMENTOS SIN PROFESORES ASOCIADOS
SELECT d.nombre AS 'departamento', COUNT(pro.id_profesor) AS 'profesores asociados' FROM departamento d LEFT JOIN profesor pro ON d.id = pro.id_departamento GROUP BY d.id_departamento ORDER BY COUNT(pro.id_profesor) DESC, d.nombre;
*/

// 3.04- Retornar listado con el número total de profesores de cada departamento ordenado por orden decreciente de número de profesores, aún si no existiesen.
SELECT d.nombre AS 'departamento', COUNT(pro.id_profesor) AS 'profesores asociados' FROM departamento d LEFT JOIN profesor pro ON d.id = pro.id_departamento GROUP BY d.id ORDER BY COUNT(pro.id_profesor) DESC, d.nombre;

// 3.05- Retornar listado con el nombre de los grados existentes y número total de asignaturas de cada uno de ellos (incluso si no existe ninguna), ordenado por número decreciente de asignaturas.
SELECT g.nombre AS 'grado', COUNT(a.id) AS 'número asignaturas' FROM grado g LEFT JOIN asignatura a ON g.id = a.id_grado GROUP BY g.id ORDER BY COUNT(a.id) DESC, g.nombre; 

// 3.06- Retornar listado con el nombre de los grados existentes y su total de asignaturas (sólo grados con un mínimo de 40 asignaturas) ordenado por número decreciente de asignaturas.
SELECT g.nombre AS 'grado', COUNT(a.id) AS 'número asignaturas' FROM grado g LEFT JOIN asignatura a ON g.id = a.id_grado GROUP BY g.id HAVING COUNT(a.id) >= 40 ORDER BY COUNT(a.id) DESC, g.nombre;

// 3.07- Retornar listado con 3 columnas : nombre de los grados, tipo de asignatura y total de créditos de las asignaturas correspondientes a cada tipo.
SELECT g.nombre, a.tipo, SUM(a.creditos) AS 'total créditos' FROM grado g LEFT JOIN asignatura a ON g.id = a.id_grado GROUP BY g.nombre, a.tipo ORDER BY g.nombre, a.tipo; 




// 3.08- Retornar un listado que muestre el total de alumnos matriculados en asignaturas de cada uno de los cursos. Usar 2 columnas : año de inicio y total de alumnos.
/* ANTERIOR :
SELECT ce.anyo_inicio AS 'inicio curso', COUNT(ama.id_alumno) AS 'alumnos matriculados' FROM alumno_se_matricula_asignatura ama JOIN curso_escolar ce ON ama.id_curso_escolar = ce.id GROUP BY ce.anyo_inicio, ce.id;
*/
/*
SELF JOIN : https://youtu.be/7S_tz1z_5bA?si=PfkWoHdLohM6W8e-&t=5772
SELF OUTER JOIN : https://youtu.be/7S_tz1z_5bA?si=GCOTp4rbEd49aKEh&t=7560
SUBQUERY :
SELECT COUNT(DISTINCT ama1.id_alumno) AS 'alumnos', ama2.id_curso_escolar AS 'id_curso' FROM alumno_se_matricula_asignatura ama1 JOIN alumno_se_matricula_asignatura ama2 ON ama1.id_alumno = ama2.id_alumno GROUP BY ama2.id_curso_escolar;
*/
SELECT ce.anyo_inicio AS 'inicio curso' , subquery.alumnos AS 'alumnos matriculados' FROM curso_escolar ce JOIN (SELECT COUNT(DISTINCT ama1.id_alumno) AS 'alumnos', ama2.id_curso_escolar AS 'id_curso' FROM alumno_se_matricula_asignatura ama1 JOIN alumno_se_matricula_asignatura ama2 ON ama1.id_alumno = ama2.id_alumno GROUP BY ama2.id_curso_escolar) AS subquery ON subquery.id_curso = ce.id GROUP BY ce.anyo_inicio;




// 3.09- Retornar listado con el número de asignaturas impartidas por cada profesor, aún si no impartiese ninguna. Columnas : ID, nombre, primer apellido, segundo apellido, total asignaturas. Orden : total de asignaturas DESC.
SELECT p.id, p.nombre, p.apellido1, p.apellido2, COUNT(a.id) AS 'total asignaturas' FROM persona p JOIN profesor pro ON p.id = pro.id_profesor LEFT JOIN asignatura a ON pro.id_profesor = a.id_profesor GROUP BY pro.id_profesor ORDER BY COUNT(a.id) DESC, p.apellido1; 

// 3.10- Retornar todos los datos del alumno más joven.
/* ANTERIOR :
SELECT * FROM persona p WHERE p.tipo IN('alumno') ORDER BY p.fecha_nacimiento LIMIT 1;
*/
// DEBÍA ORDENAR DESCENDIENTE, TENGO FECHA DE NACIMIENTO, NO EDAD
SELECT * FROM persona p WHERE p.tipo IN('alumno') ORDER BY p.fecha_nacimiento DESC LIMIT 1;

// 3.11- Retornar listado de los profesores con algún departamento asociado que no imparta ninguna asignatura.
SELECT * FROM persona p JOIN (SELECT pro.id_profesor FROM profesor pro LEFT JOIN (SELECT pro.id_departamento FROM asignatura a LEFT JOIN profesor pro ON pro.id_profesor = a.id_profesor) AS subquery1 ON pro.id_departamento = subquery1.id_departamento WHERE subquery1.id_departamento IS NULL ORDER BY pro.id_profesor ASC) AS subquery2 ON p.id = subquery2.id_profesor ORDER BY p.id;

/*
SUBQUERY ME DA 2 COLUMNAS DE IGUAL NOMBRE, 2 SE LLAMAN ID Y OTRAS 2 ID_PROFESOR :
SELECT * FROM departamento d LEFT JOIN profesor pro ON d.id = pro.id_departamento LEFT JOIN asignatura a ON pro.id_profesor = a.id_profesor GROUP BY d.id HAVING COUNT(a.id) = 0;

SUBQUERY ME DA 1 ÚNICA COLUMNA CON LOS ID_DEPARTAMENTO DE TODAS LAS ASIGNATURAS :
SELECT pro.id_departamento FROM asignatura a LEFT JOIN profesor pro ON pro.id_profesor = a.id_profesor;

JOIN con subquery anterior me da ID PROFESORES cuyos departamentos no tienen asignaturas en curso :
SELECT pro.id_profesor FROM profesor pro LEFT JOIN (SELECT pro.id_departamento FROM asignatura a LEFT JOIN profesor pro ON pro.id_profesor = a.id_profesor) AS subquery1 ON pro.id_departamento = subquery1.id_departamento WHERE subquery1.id_departamento IS NULL ORDER BY pro.id_profesor ASC;

LISTO !!!!
SELECT * FROM persona p JOIN (SELECT pro.id_profesor FROM profesor pro LEFT JOIN (SELECT pro.id_departamento FROM asignatura a LEFT JOIN profesor pro ON pro.id_profesor = a.id_profesor) AS subquery1 ON pro.id_departamento = subquery1.id_departamento WHERE subquery1.id_departamento IS NULL ORDER BY pro.id_profesor ASC) AS subquery2 ON p.id = subquery2.id_profesor ORDER BY p.id;
*/