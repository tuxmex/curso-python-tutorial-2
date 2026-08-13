# Solución de referencia — Tarea Módulo 02

> **Nota para el revisor:** solución modelo con el proceso de ejemplo del curso. Verificar que el estudiante haya aplicado la misma lógica a su propio proceso.

## Ejercicio 1 — Convención de tópicos

| Tópico | Descripción |
|---|---|
| `utng/planta1/linea3/horno/temperatura` | Temperatura del horno (°C) |
| `utng/planta1/linea1/banda/velocidad` | Velocidad de la banda (m/s) |
| `utng/planta1/linea2/motor/vibracion` | Vibración del motor (mm/s) |
| `utng/planta1/linea3/horno/estado` | Estado de conexión del equipo (retained) |
| `utng/planta1/linea3/horno/alarma` | Alarma disparada por Node-RED |

**Revisar:** que existan mínimo 3 tópicos de variable + 1 de estado + 1 de alarma, y que la jerarquía sea consistente con `utng/<planta>/<area>/<equipo>/<variable>`.

## Ejercicio 2 — Publicación y suscripción manual

```bash
# Terminal 1 (suscriptor)
mosquitto_sub -h localhost -t "utng/#" -v

# Terminal 2 (publicador) — al menos 5 mensajes
mosquitto_pub -h localhost -t "utng/planta1/linea3/horno/temperatura" -m "82.1"
mosquitto_pub -h localhost -t "utng/planta1/linea1/banda/velocidad" -m "1.8"
mosquitto_pub -h localhost -t "utng/planta1/linea2/motor/vibracion" -m "2.3"
mosquitto_pub -h localhost -t "utng/planta1/linea3/horno/estado" -m "conectado"
mosquitto_pub -h localhost -t "utng/planta1/linea3/horno/alarma" -m "temperatura alta"
```

**Revisar:** captura mostrando ambas terminales, con los 5 mensajes recibidos correctamente en el suscriptor.

## Ejercicio 3 — QoS y Retained

```bash
mosquitto_pub -h localhost -t "utng/planta1/linea3/horno/temperatura" -m "88.5" -q 2
mosquitto_pub -h localhost -t "utng/planta1/linea3/horno/estado" -m "conectado" -r
```

**Respuesta esperada — ¿cuándo usar QoS 2?**
> Usaría QoS 2 para el tópico de alarma crítica (ej. sobre-temperatura del horno), porque ahí es inaceptable tanto perder el mensaje como recibirlo duplicado (un duplicado podría, por ejemplo, disparar dos veces una parada de emergencia). Para lecturas rutinarias de temperatura cada pocos segundos, QoS 0 es suficiente porque perder una lectura aislada no es crítico y llegará otra en segundos.

**Respuesta esperada — ¿por qué "retained" para el estado del equipo?**
> Porque un cliente que se conecta después (ej. un nuevo dashboard) necesita saber inmediatamente si el equipo está conectado o no, sin tener que esperar a que se publique un nuevo mensaje. Con `retain`, el broker le entrega el último estado conocido apenas se suscribe.

**Revisar:** captura mostrando que, al reconectar el suscriptor, el valor retenido llega de inmediato sin necesidad de una nueva publicación.

## Ejercicio 4 — Investigación: Sparkplug B

**Ejemplo de respuesta esperada:**
> Sparkplug B es una especificación construida sobre MQTT que estandariza la estructura de los payloads y añade metadatos de estado de sesión (mensajes NBIRTH/NDEATH/DBIRTH/DDATA) para que un sistema SCADA sepa, sin ambigüedad, cuándo un dispositivo entró o salió de línea y cuál es el "estado conocido" completo de todas sus variables. MQTT por sí solo no define un formato de payload ni un mecanismo estándar de sincronización de estado; cada integrador termina inventando su propia convención, lo cual dificulta la interoperabilidad entre proveedores. Sparkplug B resuelve ese problema en entornos industriales con múltiples PLCs y sistemas de distintos fabricantes. (Fuente: especificación Sparkplug de la Eclipse Foundation / Cirrus Link.)

**Revisar:** que el párrafo tenga 100+ palabras, mencione el problema de interoperabilidad/estado que resuelve, y cite una fuente (no necesariamente la misma, pero verificable).

## Rúbrica de calificación rápida

| Criterio | Máx. | Indicadores de logro completo |
|---|---|---|
| Convención de tópicos | 2 | 3 variables + estado + alarma, jerarquía consistente |
| Evidencia pub/sub | 3 | Captura clara con 5+ mensajes recibidos |
| QoS y retained | 3 | Explicación correcta y evidencia de retained funcionando |
| Investigación Sparkplug B | 2 | 100+ palabras, fuente citada, concepto correcto |
