# Guion del docente — Sesión 05
## Modelado de datos industriales con PostgreSQL

## Ficha técnica de la sesión

| | |
|---|---|
| **Duración total** | 2 horas (120 min) |
| **Objetivo de la sesión** | Que cada docente-alumno diseñe un esquema relacional propio, cargue datos de prueba y escriba consultas de reporte industrial en SQL. |
| **Material que debes preparar antes** | `modulo_05.pptx`; pgAdmin instalado y conectado a tu PostgreSQL de prueba; tu propio esquema ya cargado con datos de ejemplo para la demo. |
| **Requisito técnico del salón** | PostgreSQL corriendo vía Docker (de la sesión 1); pgAdmin instalado en cada equipo, o acceso vía `psql`. |
| **Documentos de apoyo** | `modulos/modulo_05_postgresql.md`, `tareas/ejercicios_clase.md` (Módulo 05), `tareas/tarea_05.md` |

---

## Minuto a minuto

| Tiempo | Bloque | Qué hacer |
|---|---|---|
| 0:00–0:10 | Recuperación | Verificar Docker + conexión a pgAdmin |
| 0:10–0:20 | ¿Por qué guardar el histórico? | Analogía de la libreta |
| 0:20–0:40 | Diseño del esquema | equipos / lecturas / alarmas, explicado en el pizarrón |
| 0:40–1:00 | Ejercicio en clase 5.1 | Crear la tabla e insertar a mano |
| 1:00–1:05 | Descanso | — |
| 1:05–1:25 | Demo de consultas | AVG, MAX, JOIN explicados uno por uno |
| 1:25–1:45 | Ejercicio en clase 5.2 | Preguntarle cosas a la libreta |
| 1:45–2:05 | Trabajo guiado | Adaptar el esquema al proceso propio |
| 2:05–2:15 | Cierre y tarea | Explicar tarea 05 |

---

## Guion narrado

### Apertura (0:00–0:10)

> "Hasta ahora, cada vez que cerramos el suscriptor o el simulador, los datos que vimos se perdieron para siempre — se esfumaron en cuanto pasaron por la pantalla. Hoy resolvemos eso."

### Bloque 1 — ¿Por qué guardar el histórico? (0:10–0:20)

**Analogía central de la sesión:**
> "Todo lo que hicimos hasta ahora es como un mensaje de voz que se borra en cuanto lo escuchas. PostgreSQL es la libreta donde por fin anotamos lo que pasó, para poder consultarlo después: '¿cuál fue la temperatura promedio ayer en la tarde?' — eso solo se puede responder si alguien lo anotó."

Pregunta al grupo: "En su taller o proceso actual, ¿cómo registran ahora mismo el histórico de una variable? ¿en papel, en Excel, no lo registran?" — conecta las respuestas con el valor de automatizar esto.

### Bloque 2 — Diseño del esquema (0:20–0:40)

**Dibuja en el pizarrón (no proyectes todavía el código), construyendo la explicación con el grupo:**

> "¿Qué información necesitamos guardar sobre un sensor? Nombre, en qué área está, qué rango es normal para él..." (anota lo que digan)
> "Y por otro lado, ¿qué necesitamos guardar de cada lectura?" (anota: valor, momento en que se tomó)

> "Aquí está la decisión de diseño más importante de hoy: **estos son dos tablas distintas**, no una sola. ¿Por qué? Porque el nombre del sensor no cambia cada segundo, pero sus lecturas sí. Si mezcláramos todo en una sola tabla, estaríamos repitiendo el nombre 'horno_01' miles de veces — un desperdicio enorme."

**Ahora sí, proyecta el código SQL** y ve explicando cada línea:
- `SERIAL PRIMARY KEY` = "un número de folio que se pone solo."
- `REFERENCES equipos(id_equipo)` = "aquí es donde 'conectamos' la tabla de lecturas con la de equipos — le decimos 'esta lectura le pertenece a este equipo'."
- `TIMESTAMPTZ DEFAULT now()` = "si no le decimos la fecha, PostgreSQL pone la de ahora mismo, sola."

### Ejercicio en clase 5.1 (0:40–1:00)

Guía la creación de la tabla y la inserción manual de un par de filas, exactamente como en `ejercicios_clase.md`. Verifica con `SELECT * FROM mis_lecturas;` en pantalla compartida antes de que sigan solos.

### Descanso (1:00–1:05)

### Bloque 3 — Demo de consultas (1:05–1:25)

> "Ya tenemos la libreta llena de datos. Ahora aprendamos a hacerle preguntas."

Presenta cada consulta con la pregunta en español **antes** del código SQL, para que asocien el lenguaje natural con la sintaxis:

- "¿Cuál es el promedio?" → `SELECT AVG(valor) FROM ...`
- "¿Cuál fue el máximo?" → `SELECT MAX(valor) FROM ...`
- "¿Cuántas lecturas llevo?" → `SELECT COUNT(*) FROM ...`
- "¿Cuáles lecturas están fuera de rango?" → el `JOIN` con la tabla `equipos`.

**Para el `JOIN`, usa esta analogía:**
> "Un JOIN es como juntar dos hojas de Excel usando una columna en común — como cuando en Excel usan BUSCARV para traer el nombre del equipo a partir de su número de folio. SQL hace lo mismo, pero de forma más directa."

### Ejercicio en clase 5.2 (1:25–1:45)

Deja que resuelvan las 3 consultas de `ejercicios_clase.md` en su propia tabla. Pide a 2–3 personas que compartan su resultado en voz alta y confirmen si tiene sentido con los datos que insertaron.

### Bloque 4 — Trabajo guiado: esquema propio (1:45–2:05)

> "Ahora adapten las 3 tablas —equipos, lecturas, alarmas— a su propio proceso. Usen los nombres y rangos que ya definieron desde la sesión 1."

Circula revisando que:
- Las relaciones (`REFERENCES`) estén bien escritas.
- Los tipos de dato sean razonables (¿`NUMERIC` para valores decimales, no `INTEGER`?).

### Cierre y tarea (2:05–2:15)

Presenta `tarea_05.md`, con énfasis en la tabla adicional que deben proponer:

> "La tarea les pide agregar una cuarta tabla que ustedes mismos justifiquen — no hay una respuesta única. Piensen: ¿qué otra información le ayudaría a un supervisor de planta a entender mejor sus datos?"

---

## Preguntas frecuentes anticipadas

| Pregunta típica | Respuesta sugerida |
|---|---|
| "¿Por qué no guardar todo en un solo archivo Excel/CSV en vez de una base de datos?" | "Un CSV funciona para pocos datos, pero cuando tienes miles de lecturas por hora, de varios equipos, consultarlo se vuelve lentísimo y propenso a errores. Una base de datos está diseñada justo para eso: buscar rápido entre millones de filas." |
| "¿Qué pasa si intento borrar un equipo que ya tiene lecturas guardadas?" | Buen momento para mencionar (sin profundizar demasiado) que PostgreSQL, por la relación `REFERENCES`, protege esa integridad — no deja borrar un equipo del que dependen lecturas, a menos que se configure explícitamente lo contrario. |
| "¿`NUMERIC(10,2)` qué significa exactamente?" | "10 dígitos en total, de los cuales 2 son decimales — por ejemplo, permite hasta 99999999.99." |

## Nota pedagógica de cierre

SQL suele ser el tema donde más se nota la diferencia de ritmo entre quienes ya tienen experiencia con bases de datos y quienes no. Considera tener 2–3 consultas "extra" preparadas para quien termine antes (por ejemplo, "¿cuál es la hora del día con más lecturas fuera de rango?"), para que no se aburran mientras el resto avanza.
