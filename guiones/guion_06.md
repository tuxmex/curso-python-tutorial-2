# Guion del docente — Sesión 06
## Persistencia de datos desde Python y Node-RED

## Ficha técnica de la sesión

| | |
|---|---|
| **Duración total** | 2 horas (120 min) |
| **Objetivo de la sesión** | Que cada docente-alumno construya un colector Python que guarde automáticamente en PostgreSQL los datos recibidos por MQTT, con manejo seguro de credenciales y resiliencia ante fallas. |
| **Material que debes preparar antes** | `modulo_06.pptx`; tu propio colector ya funcionando para la demo; ejemplo de `.env` para mostrar buenas prácticas. |
| **Requisito técnico del salón** | Mosquitto + PostgreSQL corriendo; `psycopg2-binary` y `python-dotenv` instalados; esquema del módulo 05 ya creado en cada equipo. |
| **Documentos de apoyo** | `modulos/modulo_06_python_postgresql.md`, `tareas/ejercicios_clase.md` (Módulo 06), `tareas/tarea_06.md` |

---

## Minuto a minuto

| Tiempo | Bloque | Qué hacer |
|---|---|---|
| 0:00–0:10 | Recuperación | Verificar servicios + esquema de sesión 5 |
| 0:10–0:20 | El "cartero automático" | Presentar la idea, conectar módulos 3 y 5 |
| 0:20–0:30 | Variables de entorno | Por qué nunca poner contraseñas en el código |
| 0:30–0:55 | Demo: colector paso a paso | Codificar en vivo, con explicación de `%s` |
| 0:55–1:00 | Descanso | — |
| 1:00–1:25 | Ejercicio en clase 6.1 | Cada quien arma su cartero |
| 1:25–1:45 | Demo: manejo de errores y reconexión | Provocar una caída de PostgreSQL en vivo |
| 1:45–2:05 | Práctica de resiliencia | Cada quien prueba apagar/prender su base de datos |
| 2:05–2:15 | Cierre y tarea | Explicar tarea 06 |

---

## Guion narrado

### Apertura (0:00–0:10)

> "Hoy conectamos dos cosas que ya construyeron por separado: el sensor que manda datos (sesión 3) y la libreta que los guarda (sesión 5). Nos falta el cartero que lleve el mensaje de uno al otro, automáticamente."

### Bloque 1 — El "cartero automático" (0:10–0:20)

**Analogía central de la sesión:**
> "Imaginen un cartero que, en cuanto ve pasar un camión con un paquete (un mensaje MQTT), lo intercepta, lo abre, y lo archiva en el lugar correcto de la bodega (la base de datos) — todo sin que nadie se lo pida cada vez. Eso es exactamente lo que va a hacer nuestro programa de hoy."

Dibuja en el pizarrón el flujo: `Mosquitto → Colector Python → PostgreSQL`, y pregunta: "¿Qué partes de este dibujo ya construimos en sesiones anteriores?" (Todas, excepto la flecha de en medio — hoy construimos esa conexión.)

### Bloque 2 — Variables de entorno (0:20–0:30)

> "Antes de programar el cartero, hablemos de algo importante: ¿dónde guardamos la contraseña de la base de datos?"

**Pregunta trampa al grupo:** "¿Alguien ve algún problema si escribo la contraseña directamente en el código, así: `password='utng_industrial'`?" (Espera respuestas — probablemente alguien mencione que si suben el código a GitHub, la contraseña queda pública.)

> "Exacto. Por eso usamos un archivo separado, `.env`, que **nunca** se sube a Git — es como llevar tu tarjeta de crédito en la cartera y no escrita en tu playera."

Muestra el `.gitignore` con la línea `.env` ya incluida.

### Bloque 3 — Demo: colector paso a paso (0:30–0:55)

**Codifica en vivo, deteniéndote en cada pieza nueva:**

```python
cursor.execute(
    "INSERT INTO lecturas (id_equipo, valor) VALUES (%s, %s);",
    (id_equipo, datos["valor"])
)
```

> "Fíjense bien en este `%s, %s` — parece que estamos dejando espacios en blanco a propósito, y así es. En vez de 'pegar' el valor directamente en el texto del SQL, se lo pasamos por separado, como una lista aparte. Esto evita un problema serio de seguridad llamado *inyección SQL* — no vamos a profundizar en el ataque en sí, pero sí en la regla: **nunca construyan una consulta SQL pegando texto directamente, siempre usen `%s`**."

Continúa armando el `on_message` que conecta el suscriptor MQTT con el `INSERT`, reutilizando el patrón de la sesión 3.

### Ejercicio en clase 6.1 (1:00–1:25, después del descanso)

Deja que cada quien arme su colector con su propio esquema (de la sesión 5) y su propio simulador (de la sesión 3) corriendo al mismo tiempo. Este ejercicio requiere **3 programas corriendo a la vez** (Mosquitto vía Docker, simulador, colector) — verifica que cada quien tenga sus terminales organizadas y sepa cuál es cuál.

**Verificación de cierre del ejercicio:** todos deben ver, en pgAdmin, filas nuevas apareciendo solas en su tabla `lecturas` mientras su simulador sigue corriendo.

### Bloque 4 — Manejo de errores y reconexión (1:25–1:45)

> "¿Qué pasa si, en medio de la noche, la base de datos se reinicia por mantenimiento? Si nuestro colector no está preparado para eso, se cae y deja de guardar todo hasta que alguien lo note y lo reinicie a mano."

**Demo en vivo:** con tu colector corriendo, ejecuta `docker stop utng_postgres` frente al grupo y muestra cómo, sin manejo de errores, el programa se cae con un traceback. Luego muestra la versión con `try/except` y reintento, repite la prueba, y muestra que esta vez el programa "aguanta" e imprime un mensaje de reintento en vez de morir.

> "La diferencia entre estas dos versiones es la diferencia entre un sistema que alguien tiene que estar vigilando 24/7, y uno que se recupera solo."

### Práctica de resiliencia (1:45–2:05)

Pide a cada quien que agregue el manejo de errores a su propio colector y repita la prueba: apagar y volver a encender PostgreSQL mientras el colector sigue corriendo, confirmando que no se detiene.

### Cierre y tarea (2:05–2:15)

Presenta `tarea_06.md`, aclarando que la prueba de resiliencia (Ejercicio 2 de la tarea) es la misma que acaban de practicar en clase, así que ya tienen el procedimiento listo.

---

## Preguntas frecuentes anticipadas

| Pregunta típica | Respuesta sugerida |
|---|---|
| "¿Por qué no uso `f'INSERT INTO ... VALUES ({valor})'` si es más corto?" | "Porque en cuanto ese valor venga de una fuente externa (un sensor, un usuario, un archivo), alguien podría meter algo malicioso disfrazado de dato — el uso de `%s` protege contra eso siempre, no solo 'cuando haga falta'." |
| "¿El archivo `.env` se sube al repositorio del proyecto final?" | "No, nunca. Lo que sí se sube es un `.env.example` con las mismas variables pero sin valores reales, para que cualquiera sepa qué necesita configurar." |
| "Si el colector se cae de verdad (no por la base de datos, sino por un error de programación), ¿el `try/except` lo salva?" | "No necesariamente — el `try/except` que vimos protege contra errores *esperados* (como la conexión perdida). Un error de programación distinto puede seguir tumbando el programa, y eso está bien: no queremos ocultar errores reales, solo ser resilientes ante fallas de infraestructura normales." |

## Nota pedagógica de cierre

Esta sesión suele ser donde el grupo empieza a sentir que "todo se conecta" — aprovecha el cierre para señalar explícitamente que ya tienen 3 de las 5 capas de la arquitectura funcionando juntas (sensor → mensajería → persistencia), y que faltan solo Node-RED del lado de alarmas visuales y el dashboard web.
