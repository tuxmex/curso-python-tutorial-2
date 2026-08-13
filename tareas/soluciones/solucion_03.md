# Solución de referencia — Tarea Módulo 03

> **Nota para el revisor:** solución modelo con el proceso de ejemplo del curso. El estudiante debe aplicar la misma lógica con su propio proceso y sus propios rangos.

## Ejercicio 1 — Simulador multi-sensor

```python
# simulador_tarea.py
import threading
import time
import random
import json
import paho.mqtt.client as mqtt

BROKER = "localhost"

def simular(client, sensor, topico, rango, intervalo, unidad):
    while True:
        valor = round(random.uniform(*rango), 2)
        payload = json.dumps({
            "sensor": sensor,
            "valor": valor,
            "unidad": unidad,
            "timestamp": time.time(),
        })
        client.publish(topico, payload, qos=1)
        time.sleep(intervalo)

cliente = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, client_id="simulador_tarea")
cliente.will_set(
    "utng/planta1/linea3/horno/estado",
    payload=json.dumps({"estado": "desconectado"}),
    qos=1, retain=True,
)
cliente.connect(BROKER, 1883, 60)
cliente.loop_start()
cliente.publish("utng/planta1/linea3/horno/estado", json.dumps({"estado": "conectado"}), retain=True)

variables = [
    ("horno_01", "utng/planta1/linea3/horno/temperatura", (60, 95), 2, "C"),
    ("banda_01", "utng/planta1/linea1/banda/velocidad", (0.5, 2.5), 4, "m/s"),
    ("motor_02", "utng/planta1/linea2/motor/vibracion", (0.1, 4.0), 7, "mm/s"),
]

for sensor, topico, rango, intervalo, unidad in variables:
    threading.Thread(
        target=simular, args=(cliente, sensor, topico, rango, intervalo, unidad), daemon=True
    ).start()

input("Simulador corriendo. Presiona ENTER para detener...\n")
```

**Revisar:** 3 hilos con intervalos distintos, payload JSON completo (`sensor`, `valor`, `unidad`, `timestamp`), tópicos según la convención del módulo 02.

## Ejercicio 2 — Suscriptor con clasificación

```python
# monitor_tarea.py
import json
import paho.mqtt.client as mqtt

RANGOS = {
    "horno_01": {"normal": (60, 85), "alerta": (85, 95)},        # >95 => crítico
    "banda_01": {"normal": (0.8, 2.0), "alerta": (0.5, 2.5)},
    "motor_02": {"normal": (0.1, 2.5), "alerta": (2.5, 4.0)},
}

def clasificar(sensor, valor):
    r = RANGOS.get(sensor)
    if not r:
        return "DESCONOCIDO"
    n_min, n_max = r["normal"]
    a_min, a_max = r["alerta"]
    if n_min <= valor <= n_max:
        return "NORMAL"
    if a_min <= valor <= a_max:
        return "ALERTA"
    return "CRÍTICO"

def al_conectar(client, userdata, flags, reason_code, properties):
    client.subscribe("utng/#", qos=1)

def al_recibir_mensaje(client, userdata, msg):
    try:
        datos = json.loads(msg.payload.decode())
        estado = clasificar(datos["sensor"], datos["valor"])
        print(f"[{estado:9}] {datos['sensor']}: {datos['valor']} {datos.get('unidad','')}")
    except (json.JSONDecodeError, KeyError):
        print(f"[{msg.topic}] payload no reconocido: {msg.payload}")

cliente = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, client_id="monitor_tarea")
cliente.on_connect = al_conectar
cliente.on_message = al_recibir_mensaje
cliente.connect("localhost", 1883, 60)
cliente.loop_forever()
```

**Revisar:** clasificación en 3 niveles con rangos propios definidos por el estudiante (no es necesario que coincidan con los del ejemplo), formato de salida legible.

## Ejercicio 3 — Simulación de falla de comunicación

- El `will_set()` ya está incluido en el simulador del Ejercicio 1.
- Para la demostración: ejecutar el simulador, y en otra terminal ejecutar `kill -9 <PID>` (obtenido con `ps aux | grep simulador_tarea`) o cerrar la terminal abruptamente (no con `Ctrl+C`, que sí permite un cierre "limpio" en algunos casos — lo ideal es simular una caída real).
- El suscriptor (Ejercicio 2, o `mosquitto_sub -t "utng/#" -v`) debe mostrar el mensaje `{"estado": "desconectado"}` publicado automáticamente por el broker.

**Respuesta esperada (ventaja del LWT):**
> Sin LWT, un sensor caído simplemente deja de enviar datos, y el sistema no tiene forma de distinguir entre "no hay cambios que reportar" y "el sensor está muerto" — un operador podría tardar minutos u horas en notarlo. Con LWT, el broker publica automáticamente un mensaje de desconexión en cuanto detecta la pérdida de la conexión TCP, permitiendo que Node-RED dispare una alarma de inmediato, sin depender de que un humano esté observando el dashboard.

## Rúbrica de calificación rápida

| Criterio | Máx. | Indicadores de logro completo |
|---|---|---|
| Simulador multi-hilo con JSON completo | 4 | 3 variables, intervalos distintos, payload correcto |
| Suscriptor con clasificación | 3 | 3 niveles, rangos propios coherentes |
| Demostración del LWT | 3 | Captura del mensaje automático + explicación correcta |
