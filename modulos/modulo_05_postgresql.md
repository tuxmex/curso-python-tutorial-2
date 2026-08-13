# Módulo 05 — Modelado de datos industriales con PostgreSQL

## Objetivos de aprendizaje

- Instalar y administrar PostgreSQL (local y Docker).
- Diseñar un esquema relacional simple para datos de proceso tipo serie de tiempo.
- Escribir consultas SQL de agregación útiles para reportes industriales (promedios por turno, máximos, detección de fuera de rango).
- Usar pgAdmin como herramienta de administración visual.

## 5.1 ¿Por qué PostgreSQL para este curso?

PostgreSQL es open-source, robusto, y ampliamente usado como backend de sistemas SCADA/históricos ligeros y de plataformas como Node-RED, Grafana y Home Assistant. Aunque en la industria real se usan bases de series de tiempo especializadas (InfluxDB, TimescaleDB), PostgreSQL:

- Es más que suficiente para el volumen de datos de un laboratorio educativo.
- Enseña SQL relacional estándar, transferible a cualquier motor.
- Puede evolucionar a **TimescaleDB** (extensión de PostgreSQL) si se desea profundizar después.

## 5.2 Instalación

### Docker (recomendado, ya definido en `recursos/docker-compose.yml` del módulo 01)

```bash
docker compose up -d postgres
```

### Verificar conexión

```bash
docker exec -it <nombre_contenedor> psql -U utng -d procesos_industriales
```

## 5.3 Diseño del esquema

```sql
-- Catálogo de equipos/sensores
CREATE TABLE equipos (
    id_equipo       SERIAL PRIMARY KEY,
    nombre          VARCHAR(100) NOT NULL,
    area            VARCHAR(100) NOT NULL,
    tipo_variable   VARCHAR(50) NOT NULL,   -- temperatura, vibracion, velocidad, etc.
    unidad          VARCHAR(20) NOT NULL,
    valor_minimo    NUMERIC(10,2),
    valor_maximo    NUMERIC(10,2)
);

-- Histórico de lecturas (tabla de mayor crecimiento)
CREATE TABLE lecturas (
    id_lectura      BIGSERIAL PRIMARY KEY,
    id_equipo       INTEGER NOT NULL REFERENCES equipos(id_equipo),
    valor           NUMERIC(10,2) NOT NULL,
    marca_tiempo    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Índice para acelerar consultas por equipo y rango de tiempo
CREATE INDEX idx_lecturas_equipo_tiempo ON lecturas (id_equipo, marca_tiempo DESC);

-- Registro de alarmas disparadas (alimentado desde Node-RED)
CREATE TABLE alarmas (
    id_alarma       SERIAL PRIMARY KEY,
    id_equipo       INTEGER NOT NULL REFERENCES equipos(id_equipo),
    tipo            VARCHAR(20) NOT NULL,   -- alta, baja, desconexion
    valor_registrado NUMERIC(10,2),
    marca_tiempo    TIMESTAMPTZ NOT NULL DEFAULT now(),
    atendida        BOOLEAN NOT NULL DEFAULT false
);
```

**Decisión de diseño clave:** separar `equipos` (catálogo, cambia poco) de `lecturas` (crece constantemente) es la base de cualquier modelo de series de tiempo relacional: evita repetir texto (nombre, unidad) en millones de filas.

## 5.4 Insertar datos de prueba

```sql
INSERT INTO equipos (nombre, area, tipo_variable, unidad, valor_minimo, valor_maximo)
VALUES
  ('horno_01', 'linea3', 'temperatura', 'C', 60, 95),
  ('banda_01', 'linea1', 'velocidad', 'm/s', 0.5, 2.5),
  ('motor_02', 'linea2', 'vibracion', 'mm/s', 0.1, 4.0);
```

## 5.5 Consultas de reporte industrial

```sql
-- Última lectura de cada equipo
SELECT e.nombre, l.valor, l.marca_tiempo
FROM lecturas l
JOIN equipos e ON e.id_equipo = l.id_equipo
WHERE l.id_lectura IN (
    SELECT MAX(id_lectura) FROM lecturas GROUP BY id_equipo
);

-- Promedio, mínimo y máximo por turno (últimas 8 horas)
SELECT e.nombre,
       ROUND(AVG(l.valor), 2) AS promedio,
       MIN(l.valor) AS minimo,
       MAX(l.valor) AS maximo,
       COUNT(*) AS num_lecturas
FROM lecturas l
JOIN equipos e ON e.id_equipo = l.id_equipo
WHERE l.marca_tiempo >= now() - INTERVAL '8 hours'
GROUP BY e.nombre;

-- Lecturas fuera de rango (comparando contra el catálogo de equipos)
SELECT e.nombre, l.valor, l.marca_tiempo
FROM lecturas l
JOIN equipos e ON e.id_equipo = l.id_equipo
WHERE l.valor < e.valor_minimo OR l.valor > e.valor_maximo
ORDER BY l.marca_tiempo DESC;

-- Conteo de alarmas por tipo, últimas 24 horas
SELECT tipo, COUNT(*) AS total
FROM alarmas
WHERE marca_tiempo >= now() - INTERVAL '24 hours'
GROUP BY tipo
ORDER BY total DESC;
```

## 5.6 pgAdmin: administración visual

pgAdmin permite explorar tablas, ejecutar consultas y ver planes de ejecución sin memorizar comandos `psql`. Instálalo como contenedor adicional en `docker-compose.yml`:

```yaml
  pgadmin:
    image: dpage/pgadmin4
    environment:
      PGADMIN_DEFAULT_EMAIL: docente@utng.edu.mx
      PGADMIN_DEFAULT_PASSWORD: utng_industrial
    ports:
      - "5050:80"
```

## 🧪 Práctica 5.1 — Esquema para tu proceso

1. Adapta el esquema `equipos` / `lecturas` / `alarmas` a las variables de tu proceso industrial elegido.
2. Inserta manualmente 10 lecturas de prueba con distintos `marca_tiempo`.
3. Escribe una consulta que identifique el equipo con más lecturas fuera de rango.
4. Documenta el esquema final (diagrama entidad-relación, aunque sea dibujado a mano y fotografiado) en tu bitácora técnica.

## ✅ Autoevaluación

- [ ] Puedo justificar por qué se separan las tablas `equipos` y `lecturas`.
- [ ] Escribo consultas SQL con `JOIN`, `GROUP BY` y funciones de agregación sin apoyo.
- [ ] Tengo PostgreSQL corriendo y accesible desde pgAdmin.
- [ ] Adapté el esquema a mi propio caso de uso industrial.
