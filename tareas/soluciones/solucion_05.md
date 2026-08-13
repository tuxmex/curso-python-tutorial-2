# Solución de referencia — Tarea Módulo 05

> **Nota para el revisor:** solución modelo con el proceso de ejemplo del curso, incluyendo una tabla adicional (`mantenimientos`) como ejemplo de lo solicitado en el Ejercicio 1.

## Ejercicio 1 — Esquema propio

```sql
-- schema_tarea.sql

CREATE TABLE equipos (
    id_equipo       SERIAL PRIMARY KEY,
    nombre          VARCHAR(100) NOT NULL,
    area            VARCHAR(100) NOT NULL,
    tipo_variable   VARCHAR(50) NOT NULL,
    unidad          VARCHAR(20) NOT NULL,
    valor_minimo    NUMERIC(10,2),
    valor_maximo    NUMERIC(10,2)
);

CREATE TABLE lecturas (
    id_lectura      BIGSERIAL PRIMARY KEY,
    id_equipo       INTEGER NOT NULL REFERENCES equipos(id_equipo),
    valor           NUMERIC(10,2) NOT NULL,
    marca_tiempo    TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_lecturas_equipo_tiempo ON lecturas (id_equipo, marca_tiempo DESC);

CREATE TABLE alarmas (
    id_alarma       SERIAL PRIMARY KEY,
    id_equipo       INTEGER NOT NULL REFERENCES equipos(id_equipo),
    tipo            VARCHAR(20) NOT NULL,
    valor_registrado NUMERIC(10,2),
    marca_tiempo    TIMESTAMPTZ NOT NULL DEFAULT now(),
    atendida        BOOLEAN NOT NULL DEFAULT false
);

-- Tabla adicional propuesta: mantenimientos.
-- Justificación: permite correlacionar caídas de rendimiento o aumento de
-- alarmas con la fecha del último mantenimiento preventivo de cada equipo,
-- lo cual es información que un supervisor de planta pediría de inmediato
-- al ver una alarma recurrente.
CREATE TABLE mantenimientos (
    id_mantenimiento SERIAL PRIMARY KEY,
    id_equipo        INTEGER NOT NULL REFERENCES equipos(id_equipo),
    tipo             VARCHAR(50) NOT NULL,   -- preventivo, correctivo
    descripcion      TEXT,
    fecha            DATE NOT NULL DEFAULT CURRENT_DATE
);
```

**Revisar:** las 3 tablas base correctas + 1 tabla adicional con FK a `equipos` y una justificación coherente en comentario SQL (no necesariamente `mantenimientos`; cualquier tabla bien justificada es válida — `turnos`, `operadores`, `paradas_de_planta`, etc.).

## Ejercicio 2 — Carga de datos de prueba

```sql
INSERT INTO equipos (nombre, area, tipo_variable, unidad, valor_minimo, valor_maximo) VALUES
  ('horno_01', 'linea3', 'temperatura', 'C', 60, 95),
  ('banda_01', 'linea1', 'velocidad', 'm/s', 0.5, 2.5),
  ('motor_02', 'linea2', 'vibracion', 'mm/s', 0.1, 4.0);

-- 30+ lecturas distribuidas en al menos 3 marcas de tiempo distintas
INSERT INTO lecturas (id_equipo, valor, marca_tiempo)
SELECT
  (ARRAY[1,2,3])[1 + floor(random()*3)],
  round((random()*40 + 55)::numeric, 2),
  now() - (floor(random()*3) || ' hours')::interval - (floor(random()*59) || ' minutes')::interval
FROM generate_series(1, 30);

INSERT INTO alarmas (id_equipo, tipo, valor_registrado) VALUES
  (1, 'alta', 97.2),
  (2, 'baja', 0.3),
  (3, 'alta', 4.5);
```

**Revisar:** que existan 30+ filas en `lecturas` con al menos 3 `marca_tiempo` distintos (verificable con `SELECT DISTINCT date_trunc('hour', marca_tiempo) FROM lecturas;`) y 3+ filas en `alarmas`.

## Ejercicio 3 — Consultas de reporte

```sql
-- 1. Promedio, mínimo y máximo por variable, últimas 8 horas
SELECT e.nombre, ROUND(AVG(l.valor),2) AS promedio, MIN(l.valor) AS minimo, MAX(l.valor) AS maximo
FROM lecturas l JOIN equipos e ON e.id_equipo = l.id_equipo
WHERE l.marca_tiempo >= now() - INTERVAL '8 hours'
GROUP BY e.nombre;

-- 2. Últimas 5 lecturas fuera de rango
SELECT e.nombre, l.valor, l.marca_tiempo
FROM lecturas l JOIN equipos e ON e.id_equipo = l.id_equipo
WHERE l.valor < e.valor_minimo OR l.valor > e.valor_maximo
ORDER BY l.marca_tiempo DESC
LIMIT 5;

-- 3. Equipo con más alarmas
SELECT e.nombre, COUNT(*) AS total_alarmas
FROM alarmas a JOIN equipos e ON e.id_equipo = a.id_equipo
GROUP BY e.nombre
ORDER BY total_alarmas DESC
LIMIT 1;

-- 4. Consulta propuesta por el estudiante — ejemplo: variable con mayor variabilidad
SELECT e.nombre, ROUND(STDDEV(l.valor)::numeric, 2) AS desviacion_estandar
FROM lecturas l JOIN equipos e ON e.id_equipo = l.id_equipo
GROUP BY e.nombre
ORDER BY desviacion_estandar DESC;
-- Justificación: una alta desviación estándar puede indicar un proceso
-- inestable que amerita revisión, incluso si el promedio está dentro de rango.
```

**Revisar:** las 3 primeras consultas deben ser esencialmente equivalentes a las anteriores (permitir variaciones de sintaxis); la 4ª debe ser una consulta original del estudiante, correctamente ejecutable, con una justificación de negocio razonable (no solo "porque sí").

## Rúbrica de calificación rápida

| Criterio | Máx. | Indicadores de logro completo |
|---|---|---|
| Esquema + tabla adicional justificada | 4 | 4 tablas, FKs correctas, justificación coherente |
| Datos de prueba | 2 | 30+ lecturas en 3+ timestamps, 3+ alarmas |
| Consultas de reporte | 4 | Las 4 consultas ejecutan y responden correctamente a la pregunta |
