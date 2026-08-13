# Solución de referencia — Tarea Módulo 06

> **Nota para el revisor:** solución modelo con el proceso de ejemplo del curso.

## Ejercicio 1 — Colector robusto

`.env.example` esperado:
```
DB_HOST=localhost
DB_PORT=5432
DB_NAME=procesos_industriales
DB_USER=utng
DB_PASSWORD=cambia_esta_contraseña
```

```python
# colector_tarea.py
import json
import time
import os
import psycopg2
import paho.mqtt.client as mqtt
from dotenv import load_dotenv

load_dotenv()

MAPA_EQUIPOS = {"horno_01": 1, "banda_01": 2, "motor_02": 3}
RANGOS = {1: (60, 95), 2: (0.5, 2.5), 3: (0.1, 4.0)}

def conectar_bd():
    while True:
        try:
            conexion = psycopg2.connect(
                host=os.getenv("DB_HOST", "localhost"),
                port=os.getenv("DB_PORT", "5432"),
                dbname=os.getenv("DB_NAME"),
                user=os.getenv("DB_USER"),
                password=os.getenv("DB_PASSWORD"),
            )
            conexion.autocommit = True
            print("Conectado a PostgreSQL")
            return conexion
        except psycopg2.OperationalError as e:
            print(f"No se pudo conectar a la base de datos ({e}); reintentando en 3s...")
            time.sleep(3)

conexion = conectar_bd()
cursor = conexion.cursor()

def guardar_lectura(id_equipo, valor):
    global conexion, cursor
    try:
        cursor.execute(
            "INSERT INTO lecturas (id_equipo, valor) VALUES (%s, %s);",
            (id_equipo, valor)
        )
        v_min, v_max = RANGOS.get(id_equipo, (None, None))
        if v_min is not None and (valor < v_min or valor > v_max):
            cursor.execute(
                "INSERT INTO alarmas (id_equipo, tipo, valor_registrado) VALUES (%s, %s, %s);",
                (id_equipo, "alta" if valor > v_max else "baja", valor)
            )
    except psycopg2.OperationalError:
        print("Conexión perdida, reconectando...")
        conexion = conectar_bd()
        cursor = conexion.cursor()

def al_conectar(client, userdata, flags, reason_code, properties):
    client.subscribe("utng/#", qos=1)

def al_recibir_mensaje(client, userdata, msg):
    try:
        datos = json.loads(msg.payload.decode())
        id_equipo = MAPA_EQUIPOS.get(datos["sensor"])
        if id_equipo is None:
            return
        guardar_lectura(id_equipo, datos["valor"])
    except (json.JSONDecodeError, KeyError) as e:
        print(f"Mensaje inválido en {msg.topic}: {e}")

cliente = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, client_id="colector_tarea")
cliente.on_connect = al_conectar
cliente.on_message = al_recibir_mensaje
cliente.connect("localhost", 1883, 60)
cliente.loop_forever()
```

**Revisar:**
- Uso de `%s` (nunca f-strings) en todas las consultas.
- Credenciales leídas de `.env`, no escritas en el código.
- Inserción también en `alarmas` cuando el valor está fuera de rango.
- Algún mecanismo de reintento/reconexión (no es indispensable que sea idéntico al mostrado; basta con que no truene el programa).

## Ejercicio 2 — Prueba de resiliencia

**Procedimiento esperado en la evidencia:**
```bash
docker stop utng_postgres
# esperar unos segundos, observar en consola del colector el mensaje de reintento
docker start utng_postgres
# observar que el colector retoma las inserciones sin haberse cerrado
```

**Revisar:** dos capturas — una mostrando el mensaje de error/reintento controlado (sin traceback fatal ni cierre del proceso) y otra mostrando que las inserciones se reanudan tras `docker start`.

## Ejercicio 3 — Comparación técnica

```python
from sqlalchemy import create_engine, Column, Integer, Numeric, DateTime, ForeignKey
from sqlalchemy.orm import declarative_base, sessionmaker

Base = declarative_base()

class Lectura(Base):
    __tablename__ = "lecturas"
    id_lectura = Column(Integer, primary_key=True)
    id_equipo = Column(Integer, ForeignKey("equipos.id_equipo"))
    valor = Column(Numeric(10, 2))

engine = create_engine("postgresql+psycopg2://utng:utng_industrial@localhost:5432/procesos_industriales")
Sesion = sessionmaker(bind=engine)
sesion = Sesion()

def guardar_lectura_orm(id_equipo, valor):
    sesion.add(Lectura(id_equipo=id_equipo, valor=valor))
    sesion.commit()
```

**Ejemplo de párrafo esperado:**
> Para el colector del proyecto integrador usaría `psycopg2` directo, porque el colector hace una sola operación repetitiva (insertar una lectura) con muy baja complejidad, y `psycopg2` es más ligero y rápido de depurar cuando el volumen de mensajes es alto. Reservaría SQLAlchemy para la API REST del módulo 07, donde probablemente necesite consultas más complejas, relaciones entre varias tablas y quizá migraciones futuras del esquema — ahí el costo de la capa adicional del ORM se justifica por la claridad y mantenibilidad del código.

**Revisar:** que el código con SQLAlchemy sea funcional (clase mapeada + sesión), y que el párrafo (80+ palabras) tome una postura justificada, no solo describa ambas herramientas.

## Rúbrica de calificación rápida

| Criterio | Máx. | Indicadores de logro completo |
|---|---|---|
| Colector seguro y con manejo de errores | 5 | Parametrizado, `.env`, reconexión, inserta en `alarmas` |
| Evidencia de resiliencia | 3 | Capturas de caída y recuperación de PostgreSQL |
| Comparación técnica | 2 | Código SQLAlchemy correcto + postura justificada |
