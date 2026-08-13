# Guion del docente — Sesión 03
## Python como cliente MQTT: publicación y suscripción

## Ficha técnica de la sesión

| | |
|---|---|
| **Duración total** | 2 horas (120 min) |
| **Objetivo de la sesión** | Que cada docente-alumno programe en Python un publicador y un suscriptor MQTT, simule múltiples sensores con hilos, e implemente el Last Will and Testament. |
| **Material que debes preparar antes** | `modulo_03.pptx`; entorno virtual con `paho-mqtt` ya probado; ejemplo de simulador multi-sensor funcionando en tu máquina para la demo. |
| **Requisito técnico del salón** | Mosquitto corriendo (recordar `docker compose up -d`); entorno virtual de cada equipo con `paho-mqtt` instalado (idealmente ya lo trajeron de la tarea 01). |
| **Documentos de apoyo** | `modulos/modulo_03_python_mqtt.md`, `tareas/ejercicios_clase.md` (Módulo 03), `tareas/tarea_03.md` |

---

## Minuto a minuto

| Tiempo | Bloque | Qué hacer |
|---|---|---|
| 0:00–0:10 | Recuperación | Verificar Docker y entorno virtual |
| 0:10–0:20 | ¿Por qué automatizar con Python? | Conectar con la sesión 2 |
| 0:20–0:40 | Demo publicador simple | Codificar en vivo, línea por línea |
| 0:40–1:00 | Ejercicio en clase 3.1 | Cada quien crea su sensor de mentiras |
| 1:00–1:05 | Descanso | — |
| 1:05–1:25 | Demo suscriptor con callbacks | Codificar en vivo |
| 1:25–1:45 | Explicar threading | Analogía + demo de 2 sensores a la vez |
| 1:45–2:05 | Ejercicio en clase 3.2 + LWT | Multi-sensor con desconexión simulada |
| 2:05–2:15 | Cierre y tarea | Explicar tarea 03 |

---

## Guion narrado

### Apertura (0:00–0:10)

> "La sesión pasada publicaron y se suscribieron a mano, escribiendo comandos en la terminal. Hoy vamos a hacer que Python lo haga por nosotros, de forma automática y repetida — así es como funciona un sensor real: nadie está ahí escribiendo `mosquitto_pub` cada 3 segundos."

### Bloque 1 — Conexión con la sesión anterior (0:10–0:20)

> "Recuerden la analogía del grupo de WhatsApp. Hoy, en vez de que ustedes escriban el mensaje a mano, van a programar un 'bot' que escribe solo, cada cierto tiempo, con un valor inventado."

Pregunta rápida al grupo: "¿Qué necesitamos para que Python 'hable' MQTT?" — deja que respondan libremente, guía hacia "una librería que sepa el protocolo" y presenta `paho-mqtt`.

### Bloque 2 — Demo: publicador simple (0:20–0:40)

**Codifica en vivo, explicando cada línea antes de escribirla — no copies y pegues todo de golpe:**

```python
import time, random, json
import paho.mqtt.client as mqtt
```
> "Estas son las herramientas que vamos a usar: `time` para esperar entre mensajes, `random` para inventar valores, `json` para empaquetar varios datos en un solo mensaje, y `paho.mqtt.client` que es quien sabe 'hablar' MQTT."

```python
cliente = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, client_id="sensor_horno_01")
cliente.connect("localhost", 1883, keepalive=60)
cliente.loop_start()
```
> "Esto es como 'entrar al grupo de WhatsApp': nos conectamos al broker. El `client_id` es el nombre con el que nos identificamos — como tu nombre de usuario."

```python
while True:
    lectura = {"sensor": "horno_01", "valor": round(random.uniform(60, 95), 2), "timestamp": time.time()}
    cliente.publish("utng/planta1/linea3/horno/temperatura", json.dumps(lectura), qos=1)
    time.sleep(3)
```
> "Aquí está el corazón del programa: cada 3 segundos, inventamos un valor, lo empaquetamos como JSON —para poder mandar varios datos en un solo mensaje— y lo publicamos."

**Pregunta de verificación antes de que ellos lo hagan:** "¿Por qué usamos JSON en vez de mandar solo el número, como hicimos ayer con `mosquitto_pub`?" (Respuesta esperada: porque ahora queremos mandar varios datos juntos: el valor, el nombre del sensor, la hora.)

### Ejercicio en clase 3.1 (0:40–1:00)

Deja que cada quien adapte el código con su propio proceso (variable, rango, tópico definidos en la tarea 02). Circula verificando que:
- El entorno virtual esté activado antes de correr el script.
- El tópico usado coincida con la convención que diseñaron en la sesión 2.

### Descanso (1:00–1:05)

### Bloque 3 — Demo: suscriptor con callbacks (1:05–1:25)

> "Ahora vamos a programar el otro lado: quien escucha. En vez de escribir `mosquitto_sub` en la terminal, Python también puede quedarse escuchando y reaccionar automáticamente a cada mensaje."

Codifica en vivo `on_connect` y `on_message`, explicando la idea de **callback**:

> "Un callback es una función que tú escribes, pero que **no llamas tú** — la llama Python automáticamente cuando pasa algo. `on_message` se ejecuta solo, cada vez que llega un mensaje nuevo. Es como poner una regla automática en tu correo: 'cuando llegue un mensaje de tal persona, haz esto' — tú nunca ejecutas esa regla a mano, se dispara sola."

### Bloque 4 — Threading (1:25–1:45)

> "Un proceso real no tiene un solo sensor, tiene varios midiendo cosas distintas al mismo tiempo. Si escribimos `while True` uno detrás de otro, el segundo sensor nunca empieza porque el primero nunca termina de dar vueltas."

**Analogía:** "Imaginen que tienen que atender 3 llamadas telefónicas a la vez. No pueden estar en una llamada, colgarla, y hasta entonces atender la siguiente — necesitan que las 3 líneas suenen 'al mismo tiempo'. Eso es lo que hace `threading`: le da a cada sensor su propia 'línea telefónica' para que corran en paralelo."

Codifica en vivo el ejemplo de 2–3 hilos del módulo 03, mostrando cómo cada uno usa un intervalo distinto.

### Ejercicio en clase 3.2 + LWT (1:45–2:05)

Guía la implementación de `will_set()` explicando otra vez con la analogía del módulo 02:

> "Recuerden: es como dejar dicho '`si me desconecto de repente, avísenle a todos`'. Vamos a provocar esa desconexión a propósito para verlo funcionar."

**Demo de la "muerte" del sensor:** pide que todos maten su proceso con `Ctrl+C` **fuerte** o cerrando la terminal de golpe (no con un cierre limpio), y que verifiquen en su suscriptor que el mensaje de "desconectado" llegó solo.

### Cierre y tarea (2:05–2:15)

Presenta `tarea_03.md`. Aclara que la tarea pide clasificar valores en NORMAL/ALERTA/CRÍTICO — sugiere pensarlo desde ahora para no dejarlo de última hora.

---

## Preguntas frecuentes anticipadas

| Pregunta típica | Respuesta sugerida |
|---|---|
| "¿`threading` en Python realmente corre las cosas 'al mismo tiempo'?" | Para este curso, la respuesta simple es sí — para publicar mensajes MQTT (que implica esperar en la red) funciona muy bien. (Si quieren profundizar en el GIL de Python, es un tema avanzado que pueden investigar por su cuenta, no es necesario para este curso.) |
| "¿Qué pasa si dos hilos publican exactamente al mismo tiempo?" | El broker los recibe a ambos sin problema — cada publicación es independiente, no chocan entre sí. |
| "Mi script no se conecta, ¿qué reviso primero?" | En este orden: 1) ¿Mosquitto está corriendo? (`docker ps`) 2) ¿el `host` y puerto son correctos? 3) ¿hay algún firewall bloqueando el puerto 1883? |

## Nota pedagógica de cierre

Esta es la sesión más "de código puro" del curso hasta ahora. Si notas que el grupo se atrasa, prioriza que **todos lleguen al Ejercicio 3.1 funcionando** antes del descanso — el threading (bloque 4) se puede repasar rápido al inicio de la sesión 4 si hace falta, pero un publicador básico funcionando es indispensable para todo lo que sigue.
