--SINTAXIS
CREATE OR REPLACE FUNCTION nombre(parametro1 tipo1, parametro2 tipo2)
RETURNS tipo_de_retorno AS $$
DECLARE
    -- Declaración de variables
    variable1 tipo_variable;
    variable2 tipo_variable := valor_inicial;
BEGIN
    -- Código de la función 
    
    RETURN valor;  
END;
$$ LANGUAGE plpgsql;



--CREAR UN PROCEDIMIENTO ALMACENADO QUE SUME DOS NUMEROS Y DEVUELVA EL RESULTADO

CREATE OR REPLACE FUNCTION suma(integer, integer)
RETURNS integer AS $$
DECLARE
    numero1 ALIAS FOR $1;
    numero2 ALIAS FOR $2;
    resultado integer;
BEGIN
    resultado := numero1 + numero2;
    RETURN resultado;
END;
$$ LANGUAGE plpgsql;

SELECT suma(5, 7);

--CREAR UN PROCEDIMIENTO ALMACENADO QUE RESTE DOS NUMEROS Y DEVUELVA EL RESULTADO

CREATE OR REPLACE FUNCTION resta(numero1 integer, numero2 integer)
RETURNS integer AS $$
DECLARE
    resultado integer;
BEGIN
    resultado := numero1 - numero2;
    RETURN resultado;
END;
$$ LANGUAGE plpgsql;

--CREAR UN PROCEDIMIENTO ALMACENADO QUE RECIBA DOS VALORES ENTEROS Y REALICE LA SUME Y LA RESTA Y LOS DEVUELVA COMO PARAMETROS DE SALIDA

CREATE OR REPLACE FUNCTION Devolver_suma_resta(numero1 integer, numero2 integer, OUT resultado_suma integer, OUT resultado_resta integer)
RETURNS integer AS $$
BEGIN
    resultado_suma := numero1 + numero2;
    resultado_resta := numero1 - numero2;
    raise notice 'El valor de la suma es: %', resultado_suma;
    raise notice 'El valor de la resta es: %', resultado_resta;
    RETURN resultado_suma;
END;
$$ LANGUAGE plpgsql;

--CONCATENAR

CREATE OR REPLACE FUNCTION CONCATENAR(datos users) RETURNS text as $$
BEGIN
    RETURN datos.uid || '-' || datos.name || '-' || datos.email;
END
$$ LANGUAGE plpgsql;

SELECT CONCATENAR(u.*) from users u;

--RETORNAR LOS DATOS DE UNA TABLA;

CREATE OR REPLACE FUNCTION SendTable() RETURNS table(
    tid int,
    title varchar,
    summary text
) as $$
BEGIN
    RETURN query
        SELECT t.tid , t.title, t.summary from tasks t where t.tid = 8 ;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM SendTable();

--INTRODUCCION AL LENGUAJE PLSQL
--  := OPERADOR DE ASIGNACION

--RECUPERAR UNA FILA DE UNA TABLA
SELECT expresions into target from tabla;
SELECT * into data_user from users;

--LLAMADO DE LAS FUNCIONES
--  SELECT recuperar valores , funciones necesitan el SELECT

--LLAMAR FUNCIONES SIN RECUPERAR VALORES 
--  PERFORM .... (Muy utilizado en los procedimientos almacenados)

--ENVIO MENSAJES
--  RAISE <<LEVEL>>
--  FOR 'Mensaje';
--  DEBUG = Registro en base de datos no productivo;
--  NOTICE = Registro en la base de datos y envia el mensaje;
--  EXCEPTION = Registro termina una transaccion;

--ESTRUCTURAS DE CONTROL
--  IF expresion then
--      sentecia
--  ELSE
--      sentecia
--  END IF;

CREATE OR REPLACE PROCEDURE view_user(iduser integer) as $$ 
DECLARE
    reguser users%ROWTYPE;
    nombre varchar;
    fecha timestamp;
    retorno integer;
BEGIN
    SELECT * INTO reguser FROM users where uid  = iduser;
    RAISE NOTICE 'Traje el usuario: %',reguser.uid;
    IF(reguser.country = 'Colombia')THEN
        RAISE NOTICE 'Es colombiano';
    ELSE
        RAISE NOTICE 'Otra Nacionalidad';
    END IF;

    fecha := reguser.register_date;
    RAISE NOTICE 'Se registro en: %',fecha;

    retorno := imprimir_valor(5);
    RAISE NOTICE 'Retornar funcion: %',retorno;

    PERFORM imprimir_valor(5);
END;
$$ LANGUAGE plpgsql;

CALL view_user(2);


--CREAR UN PROCEDIMIENTO QUE PERMITA LISTAR LAS TAREAS CON UNA PRIORIDAD 2 SI LA TAREA ESTA PENDIENTE IMPRIMIR UN MENSAJE 'ECHELE GANAS' Y SI ESTA TERMINADA FELICITAR


CREATE OR REPLACE PROCEDURE mostrar_tarea_prioridad_2(tarea_id INT)
AS $$
DECLARE
    regtarea tasks%ROWTYPE;
    estado VARCHAR;
    mensaje TEXT;
BEGIN
    SELECT * INTO regtarea FROM tasks WHERE pid = 2 ;
    RAISE NOTICE 'Tarea: % | Estado: %', regtarea.title, regtarea.status;
    estado := regtarea.status;
    IF (estado = 'pendiente') THEN
        mensaje := '¡Échele ganas!';
    ELSE IF (estado = 'completada') THEN
        mensaje := '¡Felicidades!';
    END IF;
    RAISE NOTICE '%', mensaje;
END;
$$ LANGUAGE plpgsql;



CALL mostrar_tarea_prioridad_2(3);

--Estructura CASE

CASE expresion 
WHEN expresion THEN 
sentecias 
WHEN expresion 2 THEN
sentecias
[ELSE
sentecias
]
END CASE;
--PROCEDIMIENTO QUE BASADO EN EL PAIS DEVUELVA LA NACIONALIDAD

CREATE OR REPLACE PROCEDURE devolver_nacionalidad(usuario_id INT)
AS $$
DECLARE
    regusuario users%ROWTYPE;BEGIN
    SELECT * INTO regusuario FROM users WHERE uid = users_id;
    RAISE NOTICE 'Nacionalidad: %', regusuario.country;
    CASE regusuario.country
    WHEN 'colombia' THEN
        RAISE NOTICE 'Es colombiano';
    WHEN 'peru' THEN
        RAISE NOTICE 'Es peruano';
    WHEN 'ecuador' THEN
        RAISE NOTICE 'Es ecuatoriano';
    ELSE
        RAISE NOTICE 'Otra Nacionalidad'
    END CASE;
END;
$$ LANGUAGE plpgsql;



--ESTRUCTURAS DE REPETICION

--LOOP
CREATE OR REPLACE PROCEDURE ejemplo_loop(limite integer) AS $$
DECLARE 
    cont integer := 0;
BEGIN
    LOOP
        cont := cont + 1;
        RAISE NOTICE 'El valor del contador es: %', cont;
        
        IF cont >= limite THEN
            RAISE NOTICE 'Se va a finalizar';
            EXIT;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CALL ejemplo_loop(5);

--WHILE
WHILE(condicion)LOOP
END LOOP

CREATE OR REPLACE PROCEDURE ejemplo_while(limite integer) AS $$
DECLARE
    cont integer := 0;
BEGIN
    WHILE(cont >= limite)LOOP
    cont:= cont +1;
    RAISE NOTICE 'El valor del contador es: %', cont;
    END LOOP;
    RAISE NOTICE 'Se va a finalizar el while';
END;
$$ LANGUAGE plpgsql;

CALL ejemplo_while(5);

--FOR
FOR variable(contador) in 1...condicion LOOP
END LOOP

CREATE OR REPLACE PROCEDURE ejemplo_for(limite integer)AS $$
BEGIN
    FOR contador in 1..limite LOOP
        RAISE NOTICE 'El valor del contador es:%',contador;
    END LOOP;
RAISE NOTICE'Ha finalizado el for';
END;
$$ LANGUAGE plpgsql;

CALL ejemplo_for(5);

--FOREACH

CREATE OR REPLACE PROCEDURE ejemplo_foreach(int[])as $$
DECLARE
    suma int;
    indice int;
    contador int;
BEGIN
    contador := 0;
    suma := 0;
    FOREACH indice in array $1 LOOP
        contador:= contador+1;
        RAISE NOTICE 'El valor de contador es %',contador;
        suma := suma + indice;
        raise notice 'La suma es: %',suma;
    END LOOP
    RAISE NOTICE ´'Ha finalizado el FOR EACH';
END;
$$ LANGUAGE plpgsql;

call ejemplo_foreach(array[1,2,3,4]);

--EXCEPTIONS



--Como se recorre una consulta con ciclos repetitivos sin cursores 


