# Tarea — Módulo 03: Python como cliente MQTT

**Entrega:** repositorio o carpeta con el/los script(s) `.py` + captura de ejecución.
**Ponderación sugerida:** 10 puntos.

## Ejercicio 1 — Simulador multi-sensor (4 pts)

Escribe `simulador_tarea.py` que, usando `threading`, publique **simultáneamente** las 3 variables de tu proceso industrial (definidas en tareas anteriores), cada una:

- En su propio tópico (según tu convención del módulo 02).
- Con payload JSON incluyendo al menos `sensor`, `valor`, `unidad` y `timestamp`.
- Con un intervalo de publicación distinto para cada variable (ej. una cada 2s, otra cada 4s, otra cada 7s).

## Ejercicio 2 — Suscriptor con clasificación (3 pts)

Escribe `monitor_tarea.py` que se suscriba a todos los tópicos de tu proceso y, al recibir cada mensaje:

- Imprima el mensaje formateado y legible (no el JSON crudo).
- Clasifique el valor como `"NORMAL"`, `"ALERTA"` o `"CRÍTICO"` según rangos que tú definas para cada variable, e imprima la clasificación junto al valor.

## Ejercicio 3 — Simulación de falla de comunicación (3 pts)

1. Agrega `will_set()` a tu simulador para publicar un mensaje de "desconectado" si el proceso termina abruptamente.
2. Demuestra el comportamiento: ejecuta el simulador, mátalo de forma abrupta (`Ctrl+C` o `kill`), y muestra en tu suscriptor que el mensaje de desconexión llegó automáticamente. Adjunta captura de pantalla.
3. Explica en 3–4 líneas qué ventaja da este mecanismo frente a que el operador tenga que notar "a simple vista" que un sensor dejó de reportar.

## Criterios de evaluación

| Criterio | Puntos |
|---|---|
| Simulador multi-hilo funcional con payload JSON completo | 4 |
| Suscriptor con clasificación de rangos correcta | 3 |
| Demostración funcional del Last Will and Testament | 3 |
