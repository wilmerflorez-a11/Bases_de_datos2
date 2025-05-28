--Plantilla para Consultas con Múltiples JOINs
--Cuando tienes que unir varias tablas y obtener resultados basados en múltiples relaciones, la estructura general es:

SELECT 
    t1.columna1,
    t2.columna2,
    t3.columna3,
    -- más columnas necesarias
FROM tabla1 t1
JOIN tabla2 t2 ON t1.columna_comun = t2.columna_comun
JOIN tabla3 t3 ON t2.columna_comun = t3.columna_comun
-- más JOINs según sea necesario
WHERE condición
GROUP BY columna_agrupada
HAVING condición_filtro
ORDER BY columna_ordenada;

--Ejemplo con un escenario de ventas:
--Supongamos que quieres obtener el nombre del producto, el nombre del vendedor y la cantidad vendida. Las tablas son:
productos (id_producto, nombre)
ventas (id_venta, id_producto, cantidad)
vendedores (id_vendedor, nombre)

SELECT 
    p.nombre AS producto,
    v.nombre AS vendedor,
    ve.cantidad AS cantidad_vendida
FROM productos p
JOIN ventas ve ON p.id_producto = ve.id_producto
JOIN vendedores v ON ve.id_vendedor = v.id_vendedor
WHERE ve.fecha_venta BETWEEN '2025-01-01' AND '2025-12-31'
ORDER BY ve.cantidad DESC;

--Plantilla para Consultas con LEFT JOIN (Incluir Registros No Coincidentes)
--Si necesitas que todos los registros de una tabla estén presentes, incluso si 
--no hay coincidencias en las tablas relacionadas, utilizamos LEFT JOIN.

SELECT 
    t1.columna1,
    t2.columna2,
    t3.columna3
FROM tabla1 t1
LEFT JOIN tabla2 t2 ON t1.columna_comun = t2.columna_comun
LEFT JOIN tabla3 t3 ON t2.columna_comun = t3.columna_comun
WHERE condición
ORDER BY columna_ordenada;

--Ejemplo con clientes y pedidos:
--Supongamos que quieres ver todos los clientes y los pedidos que han hecho (incluso si algunos clientes no han realizado pedidos). 
--Las tablas son:

clientes (id_cliente, nombre)
pedidos (id_pedido, id_cliente, fecha_pedido)

SELECT 
    c.nombre AS cliente,
    p.id_pedido,
    p.fecha_pedido
FROM clientes c
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente
ORDER BY c.nombre;


--Plantilla para Subconsultas en WHERE (Filtrar usando el resultado de otra consulta)
--Cuando necesitas filtrar los resultados de una tabla usando una subconsulta, esta es la estructura general:

SELECT 
    columna1,
    columna2
FROM tabla1
WHERE columna IN ( 
    SELECT columna_relacionada
    FROM tabla2
    WHERE condición
);

--Ejemplo con ventas y productos:
--Supongamos que quieres ver los productos vendidos que tienen una cantidad mayor que el promedio de todos los productos vendidos. 
--Las tablas son:

productos (id_producto, nombre)
ventas (id_venta, id_producto, cantidad)

SELECT 
    p.nombre AS producto,
    ve.cantidad AS cantidad_vendida
FROM productos p
JOIN ventas ve ON p.id_producto = ve.id_producto
WHERE ve.cantidad > (
    SELECT AVG(cantidad)
    FROM ventas
);

--Plantilla para Consultas con GROUP BY (Agrupación y Agregados)
--Cuando necesitas realizar agregaciones (como COUNT, SUM, AVG) en conjunto con GROUP BY, usa esta plantilla:

SELECT 
    t1.columna_agrupada,
    COUNT(t2.columna) AS cantidad,
    SUM(t2.columna) AS total
FROM tabla1 t1
JOIN tabla2 t2 ON t1.columna_comun = t2.columna_comun
GROUP BY t1.columna_agrupada
HAVING condición_filtro
ORDER BY columna_ordenada;

--Ejemplo con ventas y productos:
--Supongamos que quieres saber cuántos productos fueron vendidos por cada categoría y el total vendido. Las tablas son:

productos (id_producto, nombre, categoria_id)
ventas (id_venta, id_producto, cantidad)
categorias (id_categoria, nombre_categoria)

SELECT 
    c.nombre_categoria AS categoria,
    COUNT(ve.id_venta) AS total_ventas,
    SUM(ve.cantidad) AS total_vendido
FROM categorias c
JOIN productos p ON c.id_categoria = p.categoria_id
JOIN ventas ve ON p.id_producto = ve.id_producto
GROUP BY c.nombre_categoria
HAVING SUM(ve.cantidad) > 50
ORDER BY total_vendido DESC;

--Plantilla para Subconsultas en SELECT (Cálculos dentro del SELECT)
--Si necesitas realizar cálculos o agregados dentro del SELECT, puedes usar subconsultas en el mismo SELECT:

SELECT 
    t1.columna1,
    (SELECT AVG(t2.columna) FROM tabla2 t2 WHERE t2.columna_comun = t1.columna_comun) AS promedio_columna
FROM tabla1 t1
WHERE condición
ORDER BY columna_ordenada;

--Ejemplo con productos y calificaciones:
--Supongamos que quieres ver los productos junto con su calificación promedio. Las tablas son:

productos (id_producto, nombre)
resenas (id_resena, id_producto, calificacion)

SELECT 
    p.nombre AS producto,
    (SELECT AVG(r.calificacion) 
     FROM resenas r 
     WHERE r.id_producto = p.id_producto) AS promedio_calificacion
FROM productos p
ORDER BY promedio_calificacion DESC;

--Plantilla para Subconsulta Correlacionada (Cuando la subconsulta depende de la fila actual)
--Las subconsultas correlacionadas permiten acceder a las columnas de la tabla externa dentro de la subconsulta. 
--La estructura es la siguiente:

SELECT 
    t1.columna1,
    t1.columna2
FROM tabla1 t1
WHERE t1.columna IN (
    SELECT t2.columna
    FROM tabla2 t2
    WHERE t2.columna_comun = t1.columna_comun
);

--Ejemplo con productos y ventas:
--Supongamos que quieres ver los productos cuyas ventas son mayores al promedio de ventas de ese producto. Las tablas son:

productos (id_producto, nombre)
ventas (id_venta, id_producto, cantidad)

SELECT 
    p.nombre AS producto
FROM productos p
WHERE p.id_producto IN (
    SELECT v.id_producto
    FROM ventas v
    GROUP BY v.id_producto
    HAVING SUM(v.cantidad) > (
        SELECT AVG(cantidad)
        FROM ventas
    )
);


--Muestra el nombre de la categoría y el número total de productos que pertenecen a cada categoría.
SELECT c.nombre , COUNT(p.producto_id)as cantidad
FROM categorias c
JOIN productos p on c.categoria_id = p.categoria_id
GROUP by c.nombre

--Muestra el nombre de los productos y su cantidad disponible en inventario.
SELECT p.nombre , i.cantidad as cantidad_disponible
FROM productos p
JOIN inventario i on p.producto_id = i.producto_id

 --Muestra las categorías que tienen más de 10 productos asociados.
SELECT c.nombre , COUNT(p.producto_id) as cantidad
FROM categorias c 
JOIN productos p on c.categoria_id = p.categoria_id
GROUP by c.nombre
HAVING COUNT(p.producto_id)>10

--Muestra productos con inventario promedio mayor a 50 unidades.
SELECT p.nombre , AVG(i.cantidad) as unidades
FROM productos p
JOIN inventario i on p.producto_id = i.producto_id
GROUP By p.nombre
HAVING AVG(i.cantidad)>50

--Muestra los productos que tienen al menos una reseña con calificación mayor a 4.
SELECT p.nombre , calificacion 
FROM productos p
WHERE resenas(
    SELECT producto_id
    FROM resenas
    WHERE calificacion > 4
);

--Muestra el nombre de las categorías que NO tienen productos asociados.

SELECT c.nombre
FROM categorias c
LEFT JOIN productos p ON c.categoria_id = p.categoria_id
WHERE p.producto_id IS NULL;

--Muestra los productos que tienen un inventario total (suma de todas sus entradas) mayor a 500 unidades.

SELECT p.nombre , SUM(i.cantidad) as Unidades_Totales
FROM productos p 
JOIN inventario i on p.producto_id = i.producto_id
GROUP BY p.nombre
HAVING SUM(i.cantidad)>500

--Lista los productos que tienen un promedio de calificación menor a 3.0.

SELECT p.nombre , AVG(r.calificacion)
FROM productos p
JOIN resenas r on p.producto_id = r.producto_id
GROUP BY p.nombre
HAVING AVG(r.calificacion)< 3.0

--Muestra el nombre de los productos que NO han recibido ninguna reseña.
SELECT p.nombre
FROM productos p
LEFT JOIN resenas r ON p.producto_id = r.producto_id
WHERE r.producto_id IS NULL;

--Muestra el nombre de los usuarios que han hecho más de 5 reseñas.

SELECT u.nombre , COUNT(r.resena_id) as cantidad_resenas
FROM usuarios u 
JOIN resenas r u.usuario_id on = r.usuario_id
GROUP BY u.nombre
HAVING COUNT(r.resena_id)>5

--Muestra el nombre de los productos que han vendido más de 100 unidades en total.

SELECT p.nombre , SUM(d.cantidad)as cantidad_vendida
FROM productos p
JOIN detalles_pedido d on p.producto_id = d.producto_id
GROUP BY p.nombre
HAVING SUM(d.cantidad)>100 

--Muestra el nombre de los usuarios que han realizado pedidos pagados por 'tarjeta'

SELECT u.nombre , pe.pedido_id , p.metodo as metodo_pago 
FROM usuarios u
JOIN pedidos pe on u.user_id = pe.user_id
JOIN pagos p on pe.pedido_id = p.pedido_id 
WHERE p.metodo = 'tarjeta'

--Muestra las categorías que tienen un inventario promedio por producto superior a 100 unidades.

SELECT c.nombre, AVG(i.cantidad) AS promedio_inventario
FROM categorias c
JOIN productos p ON c.categoria_id = p.categoria_id
JOIN inventario i ON p.producto_id = i.producto_id
GROUP BY c.nombre
HAVING AVG(i.cantidad) > 100;

--Muestra el producto más vendido (mayor cantidad total vendida) junto con su cantidad vendida.

SELECT p.nombre, SUM(d.cantidad) AS cantidad_vendida
FROM productos p
JOIN detalles_pedido d ON p.producto_id = d.producto_id
GROUP BY p.nombre
HAVING SUM(d.cantidad) = (
    SELECT MAX(cantidad_total)
    FROM (
        SELECT SUM(d2.cantidad) AS cantidad_total
        FROM detalles_pedido d2
        JOIN productos p2 ON d2.producto_id = p2.producto_id
        GROUP BY p2.nombre
    ) AS subconsulta
);





-- Tabla: pedidos
pedido_id | cliente_id | total
------------------------------
1         | 1          | 300
2         | 1          | 500
3         | 2          | 100
4         | 3          | 800

-- Mostrar clientes cuyo gasto total > gasto promedio de todos los clientes.

SELECT cliente_id, SUM(total) AS gasto_total
FROM pedidos
GROUP BY cliente_id
HAVING SUM(total) > (
    SELECT AVG(gasto_cliente)
    FROM (
        SELECT cliente_id, SUM(total) AS gasto_cliente
        FROM pedidos
        GROUP BY cliente_id
    ) AS gastos
);





















-- Tabla: peliculas
pelicula_id | titulo
-------------------
1           | Titanic
2           | Avatar
3           | Terminator
4           | Alien

-- Tabla: calificaciones
calificacion_id | pelicula_id | calificacion
-------------------------------------------
1               | 1           | 9
2               | 2           | 8
3               | 3           | 10
4               | 4           | 7
5               | 1           | 8

-- Mostrar top 5 películas por calificación promedio.

SELECT titulo, promedio
FROM (
    SELECT p.titulo, AVG(c.calificacion) AS promedio
    FROM peliculas p
    JOIN calificaciones c ON p.pelicula_id = c.pelicula_id
    GROUP BY p.titulo
    ORDER BY promedio DESC
    LIMIT 5
) AS sub;


-- Tabla: productos
producto_id | nombre    | precio | categoria_id
-----------------------------------------------
1           | Laptop    | 1200   | 1
2           | Tablet    | 600    | 1
3           | Shampoo   | 10     | 2
4           | Perfume   | 50     | 2

-- Mostrar productos con precio menor al promedio de su categoría.

SELECT nombre, precio
FROM productos
WHERE precio < (
    SELECT AVG(precio)
    FROM productos AS p2
    WHERE p2.categoria_id = productos.categoria_id
);




--Mostrar los clientes cuyo pedido individual más alto (MAX(total)) es mayor que el mínimo de los máximos de todos los clientes.
SELECT cliente_id, MAX(total) AS pedido_maximo
FROM pedidos
GROUP BY cliente_id
HAVING MAX(total) > (
    SELECT MIN(pedido_maximo)
    FROM (
        SELECT cliente_id, MAX(total) AS pedido_maximo
        FROM pedidos
        GROUP BY cliente_id
    ) AS maximos
);





















