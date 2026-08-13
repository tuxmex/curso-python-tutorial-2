# Guion del docente — Sesión 08
## Proyecto integrador: Sistema SCADA ligero

## Ficha técnica de la sesión

| | |
|---|---|
| **Duración total** | 2 horas (120 min) — primera de varias sesiones de taller/asesoría, según la guía de desarrollo del módulo 08 |
| **Objetivo de la sesión** | Que cada docente-alumno integre todos los componentes construidos en las sesiones 01–07 en un sistema funcional aplicado a su propio proceso, y entienda cómo diagnosticar el sistema completo cuando algo falla. |
| **Material que debes preparar antes** | `modulo_08.pptx`; tu propio sistema integrado corriendo de principio a fin, ensayado al menos una vez completo antes de la clase; la rúbrica de evaluación impresa o proyectada. |
| **Requisito técnico del salón** | Todos los componentes de las sesiones 1–7 ya funcionando de forma individual en cada equipo (este módulo no enseña código nuevo, integra lo existente). |
| **Documentos de apoyo** | `modulos/modulo_08_proyecto_integrador.md`, `tareas/ejercicios_clase.md` (Módulo 08), `tareas/tarea_08.md`, `tareas/soluciones/solucion_08.md` (checklist de revisión) |

---

## Minuto a minuto

| Tiempo | Bloque | Qué hacer |
|---|---|---|
| 0:00–0:15 | Apertura | Recordar la arquitectura completa, mostrar tu sistema integrado |
| 0:15–0:30 | Presentar requisitos y rúbrica | Explicar los 6 requisitos mínimos del proyecto |
| 0:30–0:50 | Demo: encendido en orden | Levantar todo el sistema paso a paso, en vivo |
| 0:50–1:10 | Ejercicio en clase 8.1 | Cada quien enciende su sistema completo, en orden |
| 1:10–1:15 | Descanso | — |
| 1:15–1:45 | Taller guiado de integración | Circular resolviendo problemas de conexión entre piezas |
| 1:45–2:00 | Ejercicio en clase 8.2 | Diagnóstico oral en parejas ("¿Qué pasa si...?") |
| 2:00–2:15 | Cierre y hoja de ruta | Explicar tarea 08, calendario de sesiones de taller restantes |

---

## Guion narrado

### Apertura (0:00–0:15)

> "Llegamos a la última sesión formal de contenido nuevo del curso. A partir de hoy, ya no van a aprender piezas nuevas — van a **conectar** las 5 piezas que ya construyeron: sensor, mensajería, automatización, base de datos y dashboard."

**Acción:** enciende tu propio sistema completo frente al grupo, de principio a fin, narrando cada paso sin entrar en detalle técnico todavía — es una demostración, no una explicación de código.

> "Esto que están viendo es la suma exacta de las sesiones 1 a 7. No hay nada nuevo aquí — es todo lo que ya saben hacer, funcionando junto."

### Bloque 1 — Requisitos y rúbrica (0:15–0:30)

Proyecta la tabla de "Requisitos mínimos del proyecto" del módulo 08 y la rúbrica de evaluación. Ve requisito por requisito, señalando **en qué sesión ya lo construyeron**:

> "Adquisición y mensajería — eso ya lo tienen de la sesión 3. Automatización con alarmas — sesión 4. Persistencia — sesión 6. Visualización — sesión 7. Lo único genuinamente nuevo de hoy es la **documentación** del sistema completo, que vamos a trabajar también."

> "La ponderación de la rúbrica no es arbitraria: fíjense que 'visualización web' y 'adquisición y mensajería' valen más (25% cada una) porque son las partes que un supervisor de planta vería primero. Pero ninguna parte vale cero — un sistema que se ve bonito pero no persiste datos, o que persiste datos pero nunca avisa de una alarma, no está completo."

### Bloque 2 — Demo: encendido en orden (0:30–0:50)

> "El error más común en este punto del curso no es de código — es de **orden**. Si prenden las piezas en el orden equivocado, algo va a fallar aunque cada pieza esté bien programada."

Repite en vivo, explicando por qué el orden importa:

1. `docker compose up -d` — "si la base de datos y el mensajero no están listos, nada de lo demás tiene con quién hablar."
2. Colector Python — "tiene que estar escuchando *antes* de que empiecen a llegar datos, si no, se pierde lo que pase mientras tanto."
3. Simulador/sensor — "ahora sí, generamos los datos."
4. Node-RED desplegado — "para las alarmas visuales."
5. Dashboard web — "lo último, porque es lo que el operador ve al final de la cadena."

### Ejercicio en clase 8.1 (0:50–1:10)

Guía a cada quien a encender su propio sistema completo, en este mismo orden, con sus propios componentes de las sesiones anteriores. **No corrijas de inmediato** cuando algo falle — primero pregunta: "¿en qué paso del orden crees que está el problema?" para que practiquen el diagnóstico, no solo reciban la solución.

### Descanso (1:10–1:15)

### Bloque 3 — Taller guiado de integración (1:15–1:45)

Este bloque es principalmente de circular por el salón resolviendo casos particulares. **Problemas típicos de integración y cómo guiarlos:**

| Síntoma | Dónde revisar primero |
|---|---|
| El dashboard no muestra nada, pero Node-RED sí recibe datos | El puente MQTT-WebSocket de la sesión 7 — ¿está corriendo? ¿el puerto coincide con el que espera la página HTML? |
| PostgreSQL no tiene datos nuevos, pero el simulador sí publica | El colector de la sesión 6 — ¿está suscrito al tópico correcto? ¿tiene las credenciales correctas en `.env`? |
| Node-RED no dispara alarmas | Revisar los rangos del nodo `switch` — ¿coinciden con los rangos reales que genera el simulador? |
| Todo funciona pero se detiene solo después de unos minutos | Revisar manejo de errores/reconexión del colector (sesión 6) |

> "Noten algo: en todos estos casos, el problema nunca estuvo en 'todo el sistema' — siempre estuvo en **una conexión específica entre dos piezas**. Diagnosticar un sistema integrado es, sobre todo, aislar cuál conexión falló, no revisar todo desde cero."

### Ejercicio en clase 8.2 — Diagnóstico oral (1:45–2:00)

Organiza en parejas y lanza las preguntas de `ejercicios_clase.md` (sección 8.2) una por una al grupo completo, pidiendo que las parejas discutan 30 segundos antes de que alguien responda en voz alta.

> "Este ejercicio no es para calificar quién sabe más — es para practicar explicar el sistema con sus propias palabras, que es exactamente lo que van a tener que hacer en el video de su tarea final."

### Cierre y hoja de ruta (2:00–2:15)

Presenta `tarea_08.md` completa, aclarando que es la entrega final del curso (40% de la ponderación total). Comunica con claridad:

- Fecha límite de entrega.
- Que el repositorio debe incluir **todos** los archivos listados en la tarea (no solo el video).
- Que las sesiones de taller siguientes (si las hay, según la guía de desarrollo por sesiones del módulo 08) son para asesoría individual, no para contenido nuevo — anímalos a llegar con dudas específicas, no a esperar que ahí se les enseñe algo que faltó.

> "Todo lo que necesitan para terminar este proyecto ya lo aprendieron. Lo que sigue es tiempo de trabajo y, si se atoran, mi acompañamiento — no material nuevo."

---

## Preguntas frecuentes anticipadas

| Pregunta típica | Respuesta sugerida |
|---|---|
| "¿Es obligatorio usar hardware real (ESP32) para el proyecto final?" | "No, es una extensión opcional. El simulador de Python que ya construyeron es una entrega completa y válida." |
| "Mi compañero y yo elegimos procesos distintos, ¿podemos trabajar juntos?" | Depende de la política de tu institución — pero técnicamente, cada quien necesita su propio esquema, tópicos y dashboard, aunque colaboren y se apoyen mutuamente en la depuración. |
| "¿Qué tanto se penaliza si mi dashboard se ve simple, sin mucho diseño?" | "La rúbrica pondera la funcionalidad (tiempo real, histórico, alarmas visibles) mucho más que la estética. Prioricen que funcione completo antes que se vea elegante." |

## Nota pedagógica de cierre

Esta sesión marca un cambio de rol: de aquí en adelante, tu función pasa de "explicar conceptos nuevos" a "acompañar la integración y resolver bloqueos puntuales". Resiste la tentación de resolver tú los problemas de integración de cada quien — guía con preguntas ("¿qué parte del flujo revisaste primero?") para que la habilidad de diagnóstico, que es el verdadero aprendizaje de este módulo, se quede con ellos y no contigo.
