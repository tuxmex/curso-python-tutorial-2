# Módulo 03 — Python como cliente MQTT: publicación y suscripción

## Objetivos de aprendizaje

- Usar la librería `paho-mqtt` para publicar y suscribirse desde Python.
- Simular sensores industriales (temperatura, vibración, nivel) con datos realistas.
- Estructurar el payload como JSON para transportar múltiples variables y metadatos.
- Implementar reconexión automática y manejo de errores de red.

## 3.1 Instalación

```bash
pip install paho-mqtt
```

> Este curso usa `paho-mqtt` versión 2.x. La API cambió respecto a la 1.x (el callback `on_connect` ahora recibe un parámetro `properties` adicional); los ejemplos siguientes usan la API `VERSION2`.

## 3.2 Publicador simple

```python
import time
import random
import json
import paho.mqtt.client as mqtt

BROKER = "localhost"
PUERTO = 1883
TOPICO = "utng/planta1/linea3/horno/temperatura"

cliente = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, client_id="sensor_horno_01")
cliente.connect(BROKER, PUERTO, keepalive=60)
cliente.loop_start()

try:
    while True:
        lectura = {
            "sensor": "horno_01",
            "valor": round(random.uniform(60, 95), 2),
            "unidad": "C",
            "timestamp": time.time(),
        }
        cliente.publish(TOPICO, json.dumps(lectura), qos=1)
        print(f"Publicado: {lectura}")
        time.sleep(3)
except KeyboardInterrupt:
    cliente.loop_stop()
    cliente.disconnect()
```

**¿Por qué JSON en el payload?** MQTT solo transporta bytes; no impone formato. Usar JSON permite enviar varios campos (valor, unidad, timestamp, id de sensor) en un solo mensaje, que Node-RED y PostgreSQL podrán interpretar fácilmente más adelante.

## 3.3 Suscriptor con callbacks

```python
import json
import paho.mqtt.client as mqtt

def al_conectar(client, userdata, flags, reason_code, properties):
    print(f"Conectado con código: {reason_code}")
    client.subscribe("utng/planta1/#", qos=1)

def al_recibir_mensaje(client, userdata, msg):
    try:
        datos = json.loads(msg.payload.decode())
        print(f"[{msg.topic}] {datos}")
    except json.JSONDecodeError:
        print(f"[{msg.topic}] payload no-JSON: {msg.payload}")

cliente = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, client_id="monitor_planta1")
cliente.on_connect = al_conectar
cliente.on_message = al_recibir_mensaje

cliente.connect("localhost", 1883, 60)
cliente.loop_forever()
```

## 3.4 Simulando múltiples sensores con hilos (threading)

En un laboratorio real, necesitarás simular varios sensores a la vez sin bloquear el programa principal.

```python
import threading
import time
import random
import json
import paho.mqtt.client as mqtt

def simular_sensor(client, nombre, topico, rango):
    while True:
        valor = round(random.uniform(*rango), 2)
        payload = json.dumps({"sensor": nombre, "valor": valor, "timestamp": time.time()})
        client.publish(topico, payload, qos=1)
        time.sleep(random.uniform(2, 5))

cliente = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, client_id="simulador_multi")
cliente.connect("localhost", 1883, 60)
cliente.loop_start()

sensores = [
    ("horno_01", "utng/planta1/linea3/horno/temperatura", (60, 95)),
    ("banda_01", "utng/planta1/linea1/banda/velocidad", (0.5, 2.5)),
    ("vibra_01", "utng/planta1/linea2/motor/vibracion", (0.1, 4.0)),
]

for nombre, topico, rango in sensores:
    hilo = threading.Thread(target=simular_sensor, args=(cliente, nombre, topico, rango), daemon=True)
    hilo.start()

input("Presiona ENTER para detener...\n")
```

## 3.5 Manejo de desconexiones (LWT) desde Python

```python
cliente.will_set(
    "utng/planta1/linea3/horno/estado",
    payload=json.dumps({"estado": "desconectado"}),
    qos=1,
    retain=True,
)
```

Si el proceso del sensor muere o pierde red, el broker publicará automáticamente ese mensaje — así Node-RED podrá disparar una alarma de "sensor sin comunicación" en el módulo 04.

## 🧪 Práctica 3.1 — Simulador de proceso industrial propio

Usando el caso de uso que definiste en el módulo 01:

1. Identifica 2–3 variables de proceso relevantes (ej. temperatura, presión, RPM, nivel de tanque, vibración).
2. Escribe un script `simulador.py` que publique cada variable en su propio tópico, con payload JSON, cada 2–5 segundos.
3. Agrega `will_set` para simular una alarma de "equipo desconectado".
4. Verifica con `mosquitto_sub -t "utng/#" -v` que los datos llegan correctamente.

## ✅ Autoevaluación

- [ ] Puedo publicar y suscribirme desde Python usando `paho-mqtt` v2.
- [ ] Sé por qué se usa JSON como formato de payload y cómo decodificarlo con `json.loads`.
- [ ] Implementé un simulador multi-sensor usando `threading`.
- [ ] Entiendo para qué sirve el Last Will and Testament (LWT) en un contexto industrial.
