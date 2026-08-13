# Tarea — Módulo 07: JavaScript para tableros web industriales

**Entrega:** carpeta del proyecto `dashboard_tarea/` (backend + frontend) + capturas de pantalla del dashboard funcionando.
**Ponderación sugerida:** 10 puntos.

## Ejercicio 1 — API REST (3 pts)

Implementa en Express al menos dos endpoints:

1. `GET /api/lecturas/:idEquipo` — últimas N lecturas de un equipo (parametrizable con `?limite=`).
2. `GET /api/alarmas/activas` — lista de alarmas no atendidas (`atendida = false`), ordenadas por fecha descendente.

Ambos deben usar consultas parametrizadas hacia PostgreSQL.

## Ejercicio 2 — Puente MQTT-WebSocket (2 pts)

Implementa el puente que reenvía por WebSocket los mensajes MQTT de **las 3 variables** de tu proceso (no solo una, como en el ejemplo de clase).

## Ejercicio 3 — Dashboard con 3 gráficas simultáneas (4 pts)

Construye una página HTML que muestre, en tiempo real (vía WebSocket), **tres** gráficas de Chart.js simultáneas — una por cada variable de tu proceso — y que:

- Cambien visualmente (ej. color del borde de la gráfica o de un indicador) cuando el valor esté fuera de rango.
- Incluyan un contador visible de "alarmas activas" que se actualice en tiempo real.

## Ejercicio 4 — Vista de histórico (1 pt)

Agrega un botón o selector en la página que, al presionarse, consulte `/api/lecturas/:idEquipo` y dibuje el histórico de las últimas 50 lecturas guardadas en PostgreSQL (no solo las que llegan en vivo).

## Criterios de evaluación

| Criterio | Puntos |
|---|---|
| Endpoints REST correctos y seguros | 3 |
| Puente MQTT-WebSocket funcional para las 3 variables | 2 |
| Dashboard en tiempo real con indicador de alarmas | 4 |
| Vista de histórico funcional | 1 |
