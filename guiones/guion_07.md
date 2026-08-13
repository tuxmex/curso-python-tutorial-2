# Guion del docente — Sesión 07
## JavaScript para tableros web industriales

## Ficha técnica de la sesión

| | |
|---|---|
| **Duración total** | 2 horas (120 min) |
| **Objetivo de la sesión** | Que cada docente-alumno construya una API REST con Express, un puente MQTT-WebSocket, y un dashboard con Chart.js que muestre datos en tiempo real e histórico. |
| **Material que debes preparar antes** | `modulo_07.pptx`; proyecto Node.js/Express ya armado y funcionando para la demo; el puente MQTT-WebSocket ya probado (es la parte más propensa a fallar en vivo, pruébala dos veces antes de clase). |
| **Requisito técnico del salón** | Node.js instalado; paquetes `express`, `pg`, `ws`, `mqtt`, `cors`, `dotenv` disponibles (idealmente predescargados si el internet del salón es lento). |
| **Documentos de apoyo** | `modulos/modulo_07_javascript_dashboards.md`, `tareas/ejercicios_clase.md` (Módulo 07), `tareas/tarea_07.md` |

---

## Minuto a minuto

| Tiempo | Bloque | Qué hacer |
|---|---|---|
| 0:00–0:10 | Recuperación | Verificar servicios + colector de sesión 6 |
| 0:10–0:20 | ¿Por qué un dashboard propio? | Conectar con el dashboard de Node-RED (sesión 4) |
| 0:20–0:40 | Demo: API REST con Express | Codificar el endpoint histórico |
| 0:40–1:00 | Ejercicio guiado | Cada quien arma su endpoint |
| 1:00–1:05 | Descanso | — |
| 1:05–1:30 | Demo: puente MQTT-WebSocket | Explicar con la analogía de la llamada abierta |
| 1:30–1:50 | Ejercicio en clase 7.1 | Página web en vivo |
| 1:50–2:05 | Ejercicio en clase 7.2 | Agregar gráfica con Chart.js |
| 2:05–2:15 | Cierre y tarea | Explicar tarea 07 |

---

## Guion narrado

### Apertura (0:00–0:10)

> "En la sesión 4 ya vieron datos en vivo en el dashboard de Node-RED. Hoy van a construir su propio dashboard, desde cero, con HTML y JavaScript — ¿por qué molestarnos si Node-RED ya nos daba uno gratis?"

### Bloque 1 — ¿Por qué un dashboard propio? (0:10–0:20)

> "El dashboard de Node-RED es como comprar un mueble ya armado de catálogo: rápido, funcional, pero todos se ven parecidos y no puedes cambiarle mucho el diseño. Hoy aprenden a construir el mueble a la medida — con el logo de su empresa, el color que quieran, la información organizada exactamente como la necesite su operador."

Pregunta al grupo: "¿En qué situación de su trabajo actual les serviría tener control total del diseño de una pantalla de monitoreo, en vez de una plantilla genérica?"

### Bloque 2 — Demo: API REST con Express (0:20–0:40)

> "Primero construimos la parte que consulta el histórico — esto es JavaScript corriendo del lado del servidor, con Node.js, no en el navegador todavía."

Codifica en vivo el endpoint `/api/lecturas/:idEquipo`, explicando la idea de una API con una analogía:

> "Una API REST es como un mesero en un restaurante: el navegador (el cliente) le pide algo por un 'menú' fijo de direcciones —por ejemplo `/api/lecturas/1`—, el mesero va a la cocina (la base de datos), trae la información, y se la entrega en un formato ordenado (JSON)."

**Señala explícitamente la reutilización de un concepto:**
> "Fíjense que seguimos usando `$1` en vez de pegar el valor directamente en el SQL — es exactamente la misma regla de seguridad que vimos en la sesión 6, solo que ahora en JavaScript en vez de Python."

### Ejercicio guiado (0:40–1:00)

Cada quien adapta el endpoint a su propio equipo/tabla. Verifica que puedan probarlo abriendo la URL directamente en el navegador (`http://localhost:3000/api/lecturas/1`) y viendo el JSON crudo como resultado — es la forma más rápida de confirmar que el backend funciona antes de construir el frontend.

### Descanso (1:00–1:05)

### Bloque 3 — Demo: puente MQTT-WebSocket (1:05–1:30)

> "Aquí viene la pieza más nueva de todo el curso: ¿cómo hace una página web para recibir datos 'en vivo', sin que el usuario tenga que recargarla cada vez?"

**Analogía central de la sesión:**
> "Cuando ustedes visitan una página normal, es como mandar una carta por correo: piden algo, esperan la respuesta, y ya. Si quieren algo nuevo, mandan otra carta. Un WebSocket es como dejar una llamada telefónica abierta: el navegador y el servidor se quedan 'en línea', y el servidor puede hablar en cualquier momento sin que el navegador tenga que volver a marcar."

> "Pero hay un problema: el navegador no sabe hablar MQTT directamente. Por eso necesitamos un 'traductor' — un programa en Node.js que sí entiende MQTT, y que retransmite cada mensaje por la llamada telefónica abierta (el WebSocket) hacia el navegador."

Codifica en vivo el puente, deteniéndote a dibujar en el pizarrón el flujo: `Mosquitto → puente Node.js → WebSocket → navegador`, y compáralo con el flujo ya construido `Mosquitto → colector Python → PostgreSQL` de la sesión 6.

> "Noten algo importante: el mismo mensaje MQTT de nuestro sensor ahora viaja por **dos caminos distintos al mismo tiempo** — uno hacia la base de datos para guardarse, y otro hacia el navegador para verse en vivo. Ninguno interfiere con el otro."

### Ejercicio en clase 7.1 (1:30–1:50)

Guía la construcción de la página HTML mínima que muestra el valor en vivo. **Este es el momento de mayor riesgo técnico de la sesión** — si el puente no conecta, revisa en este orden frente al grupo (para que aprendan a depurar, no solo a que tú lo arregles):
1. ¿El puente Node.js está corriendo sin errores en la terminal?
2. ¿El puerto del WebSocket (8080) coincide entre el puente y la página HTML?
3. ¿La consola del navegador (F12) muestra algún error?

### Ejercicio en clase 7.2 (1:50–2:05)

Agrega Chart.js sobre lo ya construido. Si el grupo va atrasado, este ejercicio puede quedar como parte de la tarea sin problema — prioriza que el Ejercicio 7.1 (dato en vivo) quede funcionando para todos antes de terminar la sesión.

### Cierre y tarea (2:05–2:15)

Presenta `tarea_07.md`. Señala que la tarea pide **3 gráficas simultáneas**, no solo una — sugiere que empiecen replicando el patrón de una sola gráfica antes de multiplicarlo.

---

## Preguntas frecuentes anticipadas

| Pregunta típica | Respuesta sugerida |
|---|---|
| "¿Por qué necesitamos un puente en Node.js si el navegador ya puede hacer peticiones HTTP directas?" | "HTTP funciona para pedir el histórico (la API REST), pero no está diseñado para que el servidor 'avise' al navegador sin que se lo pidan. Para eso existe WebSocket, y como el navegador no habla MQTT, necesitamos el puente como traductor." |
| "¿El backend Express y el puente MQTT-WebSocket son el mismo programa?" | "Pueden ser el mismo archivo `server.js` corriendo ambas cosas a la vez, como lo vimos en la demo — Express maneja las peticiones HTTP normales, y en el mismo proceso corre el servidor WebSocket." |
| "¿Qué pasa si cierro la pestaña del navegador, se pierden los datos?" | "No — los datos ya se guardaron en PostgreSQL gracias al colector de la sesión 6, independientemente de si alguien está viendo el dashboard o no. Eso es justo la ventaja de tener las dos rutas (guardar y visualizar) separadas." |

## Nota pedagógica de cierre

De todas las sesiones del curso, esta es la que tiene más piezas moviéndose a la vez (Express, WebSocket, MQTT, el navegador). Antes de la clase, ten un plan B: un ejemplo mínimo ya armado y probado que puedas compartir por archivo a quien se atore, para que nadie se quede sin ver el resultado final funcionando, aunque no les haya dado tiempo de programarlo completo ellos mismos.
