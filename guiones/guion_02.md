# Guion del docente — Sesión 02
## Fundamentos de mensajería industrial: MQTT y Mosquitto

## Ficha técnica de la sesión

| | |
|---|---|
| **Duración total** | 2 horas (120 min) |
| **Objetivo de la sesión** | Que cada docente-alumno entienda el modelo publicador/suscriptor, sepa publicar y suscribirse desde la terminal, y diseñe su propia convención de tópicos. |
| **Material que debes preparar antes** | `modulo_02.pptx` proyectada; Mosquitto corriendo en tu máquina (vía Docker, ya visto en la sesión 1); MQTT Explorer instalado para la demo visual. |
| **Requisito técnico del salón** | Cada equipo con Mosquitto corriendo (contenedor de la sesión 1 debe seguir activo o volver a levantarse). |
| **Documentos de apoyo** | `modulos/modulo_02_mqtt_mosquitto.md`, `tareas/ejercicios_clase.md` (Módulo 02), `tareas/tarea_02.md` |

---

## Minuto a minuto

| Tiempo | Bloque | Qué hacer |
|---|---|---|
| 0:00–0:10 | Recuperación de la sesión anterior | Verificar que Docker sigue corriendo en todos los equipos |
| 0:10–0:25 | ¿Por qué MQTT? | Explicar HTTP vs. MQTT con analogía |
| 0:25–0:45 | Conceptos clave | Broker, tópico, QoS, retained, LWT |
| 0:45–1:05 | Ejercicio en clase 2.1 | Publicar/suscribir en pareja |
| 1:05–1:10 | Descanso | — |
| 1:10–1:25 | Demo MQTT Explorer | Visualizar el árbol de tópicos |
| 1:25–1:45 | Ejercicio en clase 2.2 | Tópicos con comodines |
| 1:45–2:05 | Diseño de convención propia | Cada quien diseña su tabla de tópicos |
| 2:05–2:15 | Cierre y tarea | Explicar tarea 02 |

---

## Guion narrado

### Apertura (0:00–0:10)

> "Antes de avanzar, verifiquen con `docker ps` que Mosquitto sigue corriendo de la sesión pasada. Si no, levántenlo de nuevo con `docker compose up -d` — esto lo vamos a repetir al inicio de cada sesión, así que más vale que se vuelva automático para ustedes."

### Bloque 1 — ¿Por qué MQTT? (0:10–0:25)

> "Todos ustedes ya usaron una página web, y una página web funciona así: tú pides algo (una petición), y el servidor te responde. Eso es HTTP. Pero imaginen que tienen 500 sensores en una planta, y cada uno tiene que estar preguntando '¿hay algo nuevo? ¿hay algo nuevo?' cada segundo. Eso satura la red rapidísimo."

**Analogía central de la sesión — repítela varias veces:**
> "MQTT funciona como un grupo de WhatsApp. Tú no le preguntas al grupo '¿hay mensajes nuevos?' cada segundo — el grupo te avisa solo, en cuanto alguien escribe algo. Eso es publicar/suscribirse, y es muchísimo más eficiente para miles de sensores."

**Acción:** proyecta la tabla comparativa HTTP vs. MQTT (diapositiva correspondiente) y coménta cada fila con la analogía del WhatsApp.

### Bloque 2 — Conceptos clave (0:25–0:45)

Explica cada concepto en este orden, con una frase de una línea cada uno **antes** de dar la definición técnica:

1. **Broker** — "Es el servidor de WhatsApp: todos los mensajes pasan por ahí." → Mosquitto es el broker que usamos.
2. **Tópico** — "Es el nombre del grupo." → Ejemplo en vivo: escribe en el pizarrón `planta1/linea3/horno/temperatura`.
3. **QoS** — "Es qué tan seguro quieres que llegue el mensaje: 0 es 'mándalo y ya', 2 es 'asegúrate de que llegue exactamente una vez'." Usa el ejemplo de una alarma crítica (QoS 2) vs. una lectura rutinaria (QoS 0).
4. **Retained** — "Es como fijar un mensaje en la parte de arriba del grupo, para que quien entre después lo vea de inmediato sin tener que hacer scroll."
5. **LWT (Last Will and Testament)** — "Es como dejarle dicho al grupo: 'si dejo de responder de repente, avísenle a todos que me desconecté'." Este concepto suele costar más trabajo — dedícale un ejemplo extra: "Imaginen que el sensor de temperatura del horno se desconecta por un cable suelto. Sin LWT, el sistema simplemente deja de recibir datos nuevos y nadie lo nota hasta que alguien revisa manualmente. Con LWT, el broker avisa solo, de inmediato."

**Pausa para preguntas** antes de pasar al ejercicio — este bloque concentra el vocabulario más nuevo de la sesión.

### Ejercicio en clase 2.1 (0:45–1:05)

Organiza en parejas: uno "publica", otro "escucha", y luego intercambian roles. Circula por el salón y, en al menos 2 parejas, pide que expliquen en voz alta qué está pasando "en sus propias palabras, no con los términos técnicos" — esto te dice si de verdad entendieron la analogía o solo copiaron el comando.

### Descanso (1:05–1:10)

### Bloque 3 — Demo con MQTT Explorer (1:10–1:25)

> "Hasta ahora todo lo vimos en texto. Les voy a mostrar una herramienta visual para que 'vean' el árbol de tópicos como quien ve las carpetas de una computadora."

**Acción:** abre MQTT Explorer conectado a tu Mosquitto, publica un par de mensajes desde la terminal y muestra cómo aparecen organizados en árbol. Esto ayuda mucho a quienes son más visuales que quienes prefieren la terminal.

### Ejercicio en clase 2.2 (1:25–1:45)

Antes de comenzar, escribe en el pizarrón:
```
+ = un solo nivel
# = todos los niveles que sigan
```
Y pide ejemplos al grupo antes de que lo hagan en su equipo: "Si quiero escuchar todas las variables de la línea 3, sin importar el equipo, ¿cómo se vería el tópico?" (Respuesta esperada: `planta1/linea3/+/+` o `planta1/linea3/#`, discutir la diferencia entre ambas.)

### Bloque 4 — Diseño de convención propia (1:45–2:05)

> "Ahora, cada quien, con el proceso que definieron en la tarea 01, va a diseñar su propia convención de tópicos. No hay una única respuesta correcta, pero sí hay errores comunes que vamos a evitar."

**Errores comunes a advertir antes de que empiecen:**
- Usar espacios o mayúsculas inconsistentes en los tópicos.
- Tópicos demasiado largos o demasiado genéricos (`datos` no dice nada; `utng/planta1/linea3/horno/temperatura` sí).
- Olvidar el tópico de "estado" (para el LWT) desde el diseño inicial.

Da 15 minutos de trabajo individual, y cierra pidiendo a 2–3 personas que compartan su convención en voz alta para retroalimentación grupal.

### Cierre y tarea (2:05–2:15)

Presenta `tarea_02.md`. Enfatiza el ejercicio de investigación sobre Sparkplug B:
> "Este último ejercicio es para que vean que lo que aprendimos hoy es la base de algo más grande que se usa en la industria real — no se queda aquí."

---

## Preguntas frecuentes anticipadas

| Pregunta típica | Respuesta sugerida |
|---|---|
| "¿MQTT reemplaza a HTTP por completo?" | "No — siguen conviviendo. Nuestra página web del módulo 7 va a usar HTTP para el histórico y MQTT (vía WebSocket) para lo que pasa en vivo. Cada uno tiene su lugar." |
| "¿Qué pasa si dos personas publican al mismo tiempo en el mismo tópico?" | "El broker los recibe a ambos y se los entrega a los suscriptores en el orden en que llegaron — no se pierden ni se mezclan." |
| "¿Los tópicos hay que crearlos antes de usarlos, como una carpeta?" | "No, esa es una diferencia importante con un sistema de archivos: el tópico 'existe' en cuanto alguien publica en él por primera vez. No hay que declararlo antes." |

## Nota pedagógica de cierre

La analogía del "grupo de WhatsApp" es la más efectiva que ha funcionado para este tema — mantenla consistente durante toda la sesión, incluso cuando expliques QoS y retained, para que el grupo construya un solo modelo mental en vez de varios sueltos.
