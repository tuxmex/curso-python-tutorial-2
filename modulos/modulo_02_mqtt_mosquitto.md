# Módulo 02 — Fundamentos de mensajería industrial: MQTT y Mosquitto

## Objetivos de aprendizaje

- Explicar el modelo publicador/suscriptor y por qué domina el IoT industrial (frente a HTTP request/response).
- Instalar y configurar un broker Mosquitto (local y en Docker).
- Publicar y suscribirse a tópicos usando línea de comandos y herramientas gráficas.
- Diseñar una convención de nombres de tópicos para una planta.

## 2.1 ¿Por qué MQTT en la industria?

| Característica | HTTP | MQTT |
|---|---|---|
| Modelo | Petición/Respuesta | Publicador/Suscriptor |
| Consumo de ancho de banda | Alto (headers grandes) | Muy bajo (cabecera de 2 bytes) |
| Conexiones persistentes | No nativo | Sí (TCP persistente) |
| Calidad de servicio (QoS) | No | Sí (0, 1, 2) |
| Ideal para | Web tradicional | Sensores, dispositivos con batería, redes inestables |

MQTT es el protocolo de facto en IoT industrial (junto con variantes como Sparkplug B) porque un solo broker puede atender miles de dispositivos con mensajes minúsculos.

## 2.2 Conceptos clave

- **Broker**: servidor central que enruta mensajes (Mosquitto es el broker open-source más usado).
- **Tópico (topic)**: cadena jerárquica tipo ruta, ej. `planta1/linea3/horno/temperatura`.
- **Publicador (publisher)**: quien envía datos a un tópico.
- **Suscriptor (subscriber)**: quien recibe datos de un tópico.
- **QoS (Quality of Service)**:
  - `0` — como máximo una vez (fire and forget)
  - `1` — al menos una vez (puede duplicarse)
  - `2` — exactamente una vez (más costoso, para eventos críticos)
- **Retained message**: el broker guarda el último valor de un tópico y lo entrega inmediatamente a nuevos suscriptores.
- **Last Will and Testament (LWT)**: mensaje que el broker publica automáticamente si un cliente se desconecta abruptamente (crítico para saber si un sensor "murió").

## 2.3 Instalación de Mosquitto

### Opción A: Docker (recomendada para el laboratorio)

```bash
docker run -it -p 1883:1883 -p 9001:9001 eclipse-mosquitto:2
```

### Opción B: Instalación nativa (Linux/Debian-Ubuntu)

```bash
sudo apt update
sudo apt install mosquitto mosquitto-clients
sudo systemctl enable mosquitto
sudo systemctl start mosquitto
```

### Archivo de configuración mínimo `mosquitto.conf`

```conf
listener 1883
allow_anonymous true   # Solo para laboratorio; en producción usar autenticación

listener 9001
protocol websockets     # Necesario para que el dashboard web (módulo 07) se conecte por WebSocket
```

## 2.4 Publicar y suscribirse desde la terminal

```bash
# Terminal 1: suscribirse a todo lo que ocurra bajo planta1/
mosquitto_sub -h localhost -t "planta1/#" -v

# Terminal 2: publicar una lectura de temperatura
mosquitto_pub -h localhost -t "planta1/linea3/horno/temperatura" -m "78.4"
```

Comodines útiles:
- `+` sustituye **un** nivel: `planta1/+/horno/temperatura`
- `#` sustituye **todos los niveles restantes**: `planta1/#`

## 2.5 Convención de tópicos para el proyecto del curso

```
utng/<planta>/<area>/<equipo>/<variable>
```

Ejemplos:
```
utng/planta1/linea3/horno/temperatura
utng/planta1/linea3/horno/estado
utng/planta1/linea1/banda/velocidad
utng/planta1/linea1/banda/alarma
```

Diseñar bien esta jerarquía **desde el inicio** evita reescribir todos los flujos de Node-RED más adelante.

## 2.6 Herramientas gráficas recomendadas

- **MQTT Explorer** (multiplataforma) — árbol visual de tópicos en tiempo real, ideal para depurar.
- **MQTTX** — alternativa moderna con soporte de scripts.

## 🧪 Práctica 2.1 — Simulador de sensor por línea de comandos

Crea un script bash o Python sencillo que publique una temperatura aleatoria cada 3 segundos:

```bash
while true; do
  TEMP=$(awk -v min=60 -v max=95 'BEGIN{srand(); print min+rand()*(max-min)}')
  mosquitto_pub -h localhost -t "utng/planta1/linea3/horno/temperatura" -m "$TEMP"
  sleep 3
done
```

En otra terminal, suscríbete y observa los valores llegar. Prueba luego con `-q 1` y `-r` (retained) y explica la diferencia observada al reconectar el suscriptor.

## ✅ Autoevaluación

- [ ] Puedo explicar la diferencia entre QoS 0, 1 y 2 con un ejemplo industrial para cada uno.
- [ ] Diseñé mi propia convención de tópicos para el proceso que elegí en el módulo 01.
- [ ] Mosquitto corre correctamente y puedo publicar/suscribirme desde la terminal.
