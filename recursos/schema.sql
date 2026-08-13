-- Esquema base de datos: procesos_industriales
-- Curso 2 - UTNG - M.T.I. Anastacio Rodríguez García

CREATE TABLE IF NOT EXISTS equipos (
    id_equipo       SERIAL PRIMARY KEY,
    nombre          VARCHAR(100) NOT NULL,
    area            VARCHAR(100) NOT NULL,
    tipo_variable   VARCHAR(50) NOT NULL,
    unidad          VARCHAR(20) NOT NULL,
    valor_minimo    NUMERIC(10,2),
    valor_maximo    NUMERIC(10,2)
);

CREATE TABLE IF NOT EXISTS lecturas (
    id_lectura      BIGSERIAL PRIMARY KEY,
    id_equipo       INTEGER NOT NULL REFERENCES equipos(id_equipo),
    valor           NUMERIC(10,2) NOT NULL,
    marca_tiempo    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_lecturas_equipo_tiempo ON lecturas (id_equipo, marca_tiempo DESC);

CREATE TABLE IF NOT EXISTS alarmas (
    id_alarma       SERIAL PRIMARY KEY,
    id_equipo       INTEGER NOT NULL REFERENCES equipos(id_equipo),
    tipo            VARCHAR(20) NOT NULL,
    valor_registrado NUMERIC(10,2),
    marca_tiempo    TIMESTAMPTZ NOT NULL DEFAULT now(),
    atendida        BOOLEAN NOT NULL DEFAULT false
);

INSERT INTO equipos (nombre, area, tipo_variable, unidad, valor_minimo, valor_maximo) VALUES
  ('horno_01', 'linea3', 'temperatura', 'C', 60, 95),
  ('banda_01', 'linea1', 'velocidad', 'm/s', 0.5, 2.5),
  ('motor_02', 'linea2', 'vibracion', 'mm/s', 0.1, 4.0)
ON CONFLICT DO NOTHING;
