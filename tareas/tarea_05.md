# Tarea — Módulo 05: Modelado de datos industriales con PostgreSQL

**Entrega:** archivo `schema_tarea.sql` + archivo con las consultas solicitadas + capturas de pgAdmin o `psql`.
**Ponderación sugerida:** 10 puntos.

## Ejercicio 1 — Esquema propio (4 pts)

Diseña y crea (con sentencias `CREATE TABLE`) el esquema `equipos` / `lecturas` / `alarmas` adaptado a **tu** proceso industrial:

- `equipos` debe reflejar las 3 variables reales que elegiste (nombre, área, unidad, rango válido).
- Agrega **una tabla adicional** que no esté en el ejemplo visto en clase y que aporte valor a tu caso (por ejemplo: `turnos`, `operadores`, `mantenimientos`, `paradas_de_planta`). Justifica en un comentario SQL por qué la agregaste.

## Ejercicio 2 — Carga de datos de prueba (2 pts)

Inserta al menos 30 registros en `lecturas`, distribuidos en al menos 3 marcas de tiempo distintas (simulando distintos momentos del día), y al menos 3 registros en `alarmas`.

## Ejercicio 3 — Consultas de reporte (4 pts)

Escribe y documenta (con el resultado obtenido) las siguientes consultas SQL sobre tu propio esquema:

1. Promedio, mínimo y máximo de cada variable en las últimas 8 horas.
2. Las 5 lecturas más recientes que estuvieron fuera de rango.
3. El equipo con mayor número de alarmas registradas.
4. Una consulta que tú mismo propongas y que sea útil para un supervisor de planta (ej. "variable con mayor variabilidad", "hora del día con más alarmas", etc.). Explica por qué la elegiste.

## Criterios de evaluación

| Criterio | Puntos |
|---|---|
| Esquema completo, correcto y con tabla adicional justificada | 4 |
| Datos de prueba suficientes y coherentes | 2 |
| Consultas correctas y bien documentadas | 4 |
