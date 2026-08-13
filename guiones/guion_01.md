# Guion del docente — Sesión 01
## Repaso, entorno de trabajo y arquitectura del sistema

## Ficha técnica de la sesión

| | |
|---|---|
| **Duración total** | 2 horas (120 min) |
| **Objetivo de la sesión** | Que cada docente-alumno tenga su entorno funcionando (Python, Docker, Node.js, Git) y entienda, con sus propias palabras, la arquitectura completa que se construirá durante el curso. |
| **Material que debes preparar antes** | Presentación `modulo_01.pptx` proyectada; Docker Desktop y Node.js ya descargados (idealmente en una USB/enlace, por si la red del laboratorio es lenta); tu propia máquina con el sistema completo ya armado, para poder mostrarlo funcionando al final. |
| **Requisito técnico del salón** | Todos los equipos con acceso a internet para instalar paquetes, o paquetes descargados previamente si el internet es limitado. |
| **Documentos de apoyo** | `modulos/modulo_01_repaso_entorno.md`, `tareas/ejercicios_clase.md` (sección Módulo 01), `tareas/tarea_01.md` |

---

## Minuto a minuto

| Tiempo | Bloque | Qué hacer |
|---|---|---|
| 0:00–0:10 | Apertura | Bienvenida, panorama del curso completo, mostrar el sistema final funcionando |
| 0:10–0:25 | Diapositivas 1–2 | Explicar arquitectura de 5 capas |
| 0:25–0:35 | Repaso de Python | Autoevaluación rápida en grupo |
| 0:35–0:55 | Demo + instalación guiada | Verificar Python, Docker, Node, Git |
| 0:55–1:15 | Ejercicio en clase 1.1 | Todos verifican sus versiones |
| 1:15–1:20 | Descanso | — |
| 1:20–1:45 | Demo docker-compose | Explicar y levantar Mosquitto + PostgreSQL |
| 1:45–2:05 | Ejercicio en clase 1.2 | Todos levantan sus contenedores |
| 2:05–2:15 | Cierre y tarea | Explicar tarea 01, resolver dudas |

---

## Guion narrado

### Apertura (0:00–0:10)

> "Buenos días/tardes a todos. Antes de empezar a instalar nada, quiero que vean a dónde vamos a llegar en 8 sesiones."

**Acción:** muestra tu propio sistema ya armado — el dashboard web con las gráficas moviéndose en tiempo real, aunque sea por 2 minutos, sin explicar todavía cómo funciona.

> "Esto que están viendo — una máquina 'hablando' por internet, guardando su historial y mostrándolo en una pantalla bonita — es exactamente lo que ustedes van a construir, pieza por pieza, con sus propias manos, en las próximas 8 sesiones. Hoy no vamos a programar casi nada: hoy vamos a preparar el terreno, porque sin esto, nada de lo demás funciona."

### Bloque 1 — Arquitectura de 5 capas (0:10–0:25)

**Apóyate en la diapositiva 3 (el diagrama de flujo).**

> "Piensen en una fábrica real. Hay una máquina que mide algo — temperatura, vibración, lo que sea. Ese dato tiene que viajar hasta la pantalla de un operador. En medio de ese viaje hay 4 paradas, y cada una de nuestras próximas sesiones construye una de esas paradas."

Explica cada capa señalando el diagrama, usando **siempre la misma metáfora** a lo largo del curso (recomendado: "el viaje del dato"):

1. **Sensor/simulador** — "Aquí nace el dato."
2. **Mosquitto (MQTT)** — "Aquí el dato se convierte en un mensaje que viaja, como un WhatsApp entre máquinas."
3. **Node-RED** — "Aquí revisamos el mensaje: ¿está bien? ¿hay que avisar de algo raro?"
4. **PostgreSQL** — "Aquí el dato se queda guardado para siempre, como una libreta."
5. **Dashboard web** — "Aquí el operador humano finalmente lo ve."

**Pregunta para lanzar al grupo:** "¿Alguien ya usa algo parecido a esto en su taller o laboratorio, aunque sea con otro nombre?" (Deja 2–3 respuestas, conecta con lo que digan.)

### Bloque 2 — Repaso rápido de Python (0:25–0:35)

**Acción:** proyecta el bloque de código de la sección 1.2 del módulo (clases, `*args/**kwargs`, `try/except`).

> "No vamos a repasar Python desde cero — eso ya lo vieron en el Curso 1. Pero sí quiero confirmar que estos tres bloques les son familiares, porque los vamos a usar sin explicarlos de nuevo a partir de la sesión 3."

**Dinámica sugerida:** lee el código en voz alta y pregunta "¿qué creen que imprime esta línea?" antes de correrlo. Si más de la mitad del grupo duda, dedica 5 minutos extra a repasar clases y `try/except` con un ejemplo en el pizarrón.

### Bloque 3 — Instalación guiada (0:35–0:55)

> "Vamos a instalar y verificar 4 herramientas. Les voy a pedir que las instalen conmigo, línea por línea, no que se adelanten — así, si algo falla, lo resolvemos juntos antes de que se acumulen los errores."

Ejecuta en tu pantalla, uno por uno, explicando qué es cada herramienta **antes** de pedirles que lo hagan:

- **Python**: "el lenguaje que ya conocen del Curso 1."
- **Docker**: "una caja donde viven programas ya armados, sin que tengamos que instalarlos a mano uno por uno."
- **Node.js**: "el motor que hace correr Node-RED y nuestra página web del módulo 7."
- **Git**: "para guardar y compartir nuestro código, como ya vieron en el curso anterior."

### Ejercicio en clase 1.1 (0:55–1:15)

Da la instrucción tal como está en `ejercicios_clase.md`, pero **camina por el salón** mientras lo hacen — este es el momento de detectar quién tiene problemas de instalación antes de que se acumulen para las próximas sesiones.

**Frase para cerrar el ejercicio:**
> "Si a alguien le faltó una de las 4 herramientas, levante la mano ahora — lo resolvemos entre todos antes del descanso, porque todo lo que sigue depende de esto."

### Descanso (1:15–1:20)

### Bloque 4 — Docker Compose (1:20–1:45)

> "Ya vieron que Docker existe. Ahora vamos a usarlo para encender, con un solo comando, las dos piezas más importantes del curso: el mensajero (Mosquitto) y el archivero (PostgreSQL)."

**Acción:** muestra el archivo `docker-compose.yml` proyectado, leyendo en voz alta qué hace cada bloque (`services:`, `image:`, `ports:`), sin entrar en demasiado detalle técnico todavía — eso se retoma en el módulo 05.

> "No necesitan entender cada línea de este archivo hoy. Solo necesitan saber que `docker compose up -d` es como apretar un botón de 'encender todo'."

### Ejercicio en clase 1.2 (1:45–2:05)

Recorre el salón verificando `docker ps` en cada equipo. **Errores comunes a anticipar:**
- Puerto ocupado (`port is already allocated`) → alguien ya tiene Mosquitto o PostgreSQL corriendo de forma nativa; hay que detenerlo o cambiar el puerto.
- Docker Desktop no iniciado → recordarles que Docker debe estar abierto en segundo plano, no solo instalado.

### Cierre y tarea (2:05–2:15)

> "Para la próxima sesión, la tarea 01 les pide definir el proceso industrial que van a monitorear durante todo el curso — esa elección la van a usar en cada sesión siguiente, así que tómense el tiempo de pensarla bien, no la dejen para el último momento."

Muestra brevemente `tarea_01.md` proyectada y aclara la fecha de entrega.

---

## Preguntas frecuentes anticipadas

| Pregunta típica | Respuesta sugerida |
|---|---|
| "¿Por qué no usamos solo Python para todo, sin Node-RED ni JavaScript?" | "Se podría, pero en la industria real cada herramienta la usa un rol distinto: el de automatización usa Node-RED sin programar tanto, el de datos usa SQL, el de interfaz usa JavaScript. Aprender las 4 los prepara para trabajar en equipo con cualquiera de esos roles." |
| "¿Necesito hardware real (ESP32, PLC) para este curso?" | "No, todo el curso funciona con datos simulados en Python. El hardware real es una extensión opcional del proyecto final, para quien ya tenga acceso a él." |
| "Docker no me deja instalar, mi computadora es muy vieja" | "Anota el caso y ofrece: (a) usar una máquina del laboratorio, o (b) explorar una instalación nativa de Mosquitto/PostgreSQL sin Docker como alternativa — más lenta de configurar pero funcional." |

## Nota pedagógica de cierre

Este módulo es el que más fricción técnica genera (instalaciones, versiones, permisos). Resérvate mentalmente 10–15 minutos de colchón dentro del bloque de instalación — es normal que no alcance el tiempo exacto de la tabla la primera vez que impartas el curso.
