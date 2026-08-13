# Tarea — Módulo 02: Fundamentos de mensajería industrial: MQTT y Mosquitto

**Entrega:** archivo `.md` o `.pdf` con capturas de pantalla y el/los script(s) usados.
**Ponderación sugerida:** 10 puntos.

## Ejercicio 1 — Convención de tópicos (2 pts)

Diseña la convención completa de tópicos MQTT para **tu** proceso industrial (definido en la tarea del módulo 01), siguiendo el patrón `utng/<planta>/<area>/<equipo>/<variable>`. Debe incluir al menos:

- 3 variables de proceso.
- 1 tópico de estado del equipo (ej. `.../estado`).
- 1 tópico de alarma (ej. `.../alarma`).

Preséntalo como una tabla Markdown.

## Ejercicio 2 — Publicación y suscripción manual (3 pts)

1. Levanta Mosquitto (Docker o instalación nativa).
2. Desde la terminal, suscríbete con comodín `#` a la raíz de tu convención de tópicos.
3. Publica manualmente al menos 5 mensajes distintos (uno por variable/tópico) usando `mosquitto_pub`.
4. Adjunta captura de pantalla mostrando ambas terminales (publicador y suscriptor).

## Ejercicio 3 — QoS y Retained (3 pts)

1. Publica un mensaje con `-q 2` y explica, con tus palabras, en qué escenario de tu proceso usarías QoS 2 en lugar de QoS 0.
2. Publica un mensaje con la bandera `-r` (retained). Cierra y vuelve a abrir el suscriptor: documenta con captura de pantalla que el último valor llega inmediatamente al reconectar.
3. Responde: ¿por qué el mensaje de "estado del equipo" es un buen candidato para ser `retained`?

## Ejercicio 4 — Investigación breve (2 pts)

Investiga y redacta un párrafo (mínimo 100 palabras) sobre **Sparkplug B**: ¿qué problema resuelve sobre el uso genérico de MQTT en entornos industriales? Cita la fuente que consultaste.

## Criterios de evaluación

| Criterio | Puntos |
|---|---|
| Convención de tópicos completa y coherente | 2 |
| Evidencia de publicación/suscripción funcional | 3 |
| Explicación correcta de QoS y retained | 3 |
| Investigación de Sparkplug B con fuente citada | 2 |
