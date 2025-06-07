
````markdown
# Fundamentos de Bases de Datos NoSQL con MongoDB

Las bases de datos **NoSQL** (Not Only SQL) son una alternativa a las bases de datos relacionales. Están diseñadas para trabajar con grandes volúmenes de datos no estructurados o semi-estructurados y se caracterizan por ser más flexibles y escalables horizontalmente.

## ¿Por qué usar NoSQL?

- No requieren esquemas fijos.
- Soportan estructuras complejas como documentos JSON.
- Escalabilidad horizontal.
- Alto rendimiento para lecturas y escrituras.


## MongoDB: Base de Datos Documental

MongoDB es una base de datos NoSQL orientada a documentos. Almacena la información en formato **BSON** (una extensión de JSON).

Cada registro es un **documento**, y los documentos se agrupan en **colecciones**.

---

## Ejemplo práctico

### 1. Crear una base de datos y colección

Primero, listamos las bases de datos y cambiamos a la base `todolist`. Luego, insertamos un usuario:

```js
use todolist

var user = {
  name: 'ana',
  email: 'ana@email.com',
  register_date: '01/01/01',
  country: 'Colombia'
}

db.users.insertOne(user)
````

Consulta de los datos:

```js
db.users.find()
```

![Inserción de usuario](./bf16d1de-fb3a-4d6c-9b9b-1fde71bb36ae.jpg)

---

### 2. Insertar tareas

Ahora insertamos una tarea en una nueva colección llamada `tasks`:

```js
var task = {
  title: 'Redactar informe mensual',
  summary: 'Preparar informe de desempeño del mes',
  status: 'pendiente',
  created_date: '2025/06/01',
  limit_date: '2025/06/20'
}

db.tasks.insertOne(task)
```

Consulta de las tareas:

```js
db.tasks.find()
```

![Inserción de tarea](./575aaadc-ebce-4784-a683-533357436fcb.jpg)

---

