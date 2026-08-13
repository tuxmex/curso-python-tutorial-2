# Módulo 06 — Persistencia de datos desde Python (y desde Node-RED)

## Objetivos de aprendizaje

- Conectar Python a PostgreSQL con `psycopg2` y con el ORM `SQLAlchemy`.
- Construir un **puente MQTT → PostgreSQL** en Python: el "colector" que alimentará el histórico.
- Configurar el nodo `postgresql` de Node-RED como alternativa/complemento sin código.
- Aplicar buenas prácticas de seguridad: variables de entorno, `.env`, parametrización de consultas.

## 6.1 Instalación

```bash
pip install psycopg2-binary sqlalchemy python-dotenv
```

## 6.2 Conexión básica con `psycopg2`

```python
import psycopg2
import os
from dotenv import load_dotenv

load_dotenv()

conexion = psycopg2.connect(
    host=os.getenv("DB_HOST", "localhost"),
    port=os.getenv("DB_PORT", "5432"),
    dbname=os.getenv("DB_NAME", "procesos_industriales"),
    user=os.getenv("DB_USER", "utng"),
    password=os.getenv("DB_PASSWORD"),
)

cursor = conexion.cursor()
cursor.execute("SELECT nombre, tipo_variable FROM equipos;")
for fila in cursor.fetchall():
    print(fila)

cursor.close()
conexion.close()
```

`.env` (nunca se sube al repositorio — agrégalo a `.gitignore`):
```
DB_HOST=localhost
DB_PORT=5432
DB_NAME=procesos_industriales
DB_USER=utng
DB_PASSWORD=utng_industrial
```

> **Nunca** concatenes valores directamente en el SQL (`f"...{valor}..."`) — es la causa más común de *SQL injection*. Usa siempre parámetros con `%s`, como en el ejemplo siguiente.

## 6.3 Insertar lecturas de forma segura (consultas parametrizadas)

```python
def insertar_lectura(cursor, id_equipo, valor):
    cursor.execute(
        "INSERT INTO lecturas (id_equipo, valor) VALUES (%s, %s);",
        (id_equipo, valor)
    )
```

## 6.4 El "colector": puente MQTT → PostgreSQL

Este es el componente central que conecta lo aprendido en los módulos 03 y 05:

```python
import json
import psycopg2
import paho.mqtt.client as mqtt
import os
from dotenv import load_dotenv

load_dotenv()

conexion = psycopg2.connect(
    host=os.getenv("DB_HOST", "localhost"),
    dbname=os.getenv("DB_NAME"),
    user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
)
conexion.autocommit = True
cursor = conexion.cursor()

# Mapeo simple nombre de sensor -> id_equipo (en un sistema real, se consulta a la tabla equipos)
MAPA_EQUIPOS = {"horno_01": 1, "banda_01": 2, "motor_02": 3}

def al_conectar(client, userdata, flags, reason_code, properties):
    print("Colector conectado, suscribiendo a utng/#")
    client.subscribe("utng/#", qos=1)

def al_recibir_mensaje(client, userdata, msg):
    try:
        datos = json.loads(msg.payload.decode())
        id_equipo = MAPA_EQUIPOS.get(datos["sensor"])
        if id_equipo is None:
            print(f"Sensor desconocido: {datos['sensor']}")
            return
        cursor.execute(
            "INSERT INTO lecturas (id_equipo, valor) VALUES (%s, %s);",
            (id_equipo, datos["valor"])
        )
        print(f"Guardado: equipo={id_equipo} valor={datos['valor']}")
    except (json.JSONDecodeError, KeyError) as e:
        print(f"Mensaje inválido en {msg.topic}: {e}")

cliente = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, client_id="colector_postgres")
cliente.on_connect = al_conectar
cliente.on_message = al_recibir_mensaje
cliente.connect("localhost", 1883, 60)
cliente.loop_forever()
```

Este script es, en esencia, un **microservicio de integración**: se ejecuta de forma continua e independiente del dashboard.

## 6.5 Alternativa: guardar directamente desde Node-RED

Para prototipos rápidos, el nodo `postgresql` (paquete `node-red-contrib-postgresql`) permite ejecutar SQL directamente desde el flujo, sin escribir Python:

```javascript
// Nodo function antes del nodo postgresql: preparar el query parametrizado
msg.query = "INSERT INTO lecturas (id_equipo, valor) VALUES ($1, $2)";
msg.payload = [msg.id_equipo, msg.payload];
return msg;
```

**Discusión pedagógica:** ¿cuándo conviene el colector en Python (módulo 06) y cuándo el nodo de Node-RED? El colector en Python es más fácil de probar unitariamente, versionar y desplegar como servicio; el nodo de Node-RED es más rápido de prototipar y visualizar. En el proyecto integrador (módulo 08) se recomienda usar el colector Python como componente formal del sistema.

## 6.6 Introducción a SQLAlchemy (ORM)

```python
from sqlalchemy import create_engine, Column, Integer, Numeric, DateTime, ForeignKey
from sqlalchemy.orm import declarative_base, sessionmaker
from datetime import datetime

Base = declarative_base()

class Lectura(Base):
    __tablename__ = "lecturas"
    id_lectura = Column(Integer, primary_key=True)
    id_equipo = Column(Integer, ForeignKey("equipos.id_equipo"))
    valor = Column(Numeric(10, 2))
    marca_tiempo = Column(DateTime, default=datetime.utcnow)

engine = create_engine("postgresql+psycopg2://utng:utng_industrial@localhost:5432/procesos_industriales")
Sesion = sessionmaker(bind=engine)
sesion = Sesion()

nueva_lectura = Lectura(id_equipo=1, valor=82.3)
sesion.add(nueva_lectura)
sesion.commit()
```

SQLAlchemy es más verboso para casos simples, pero facilita mucho el trabajo cuando el modelo de datos crece (consultas complejas, migraciones con Alembic, relaciones múltiples).

## 🧪 Práctica 6.1 — Colector completo para tu proceso

1. Adapta `MAPA_EQUIPOS` a los equipos que definiste en el módulo 05.
2. Corre simultáneamente: tu simulador (módulo 03) + el colector de este módulo.
3. Verifica en pgAdmin (o `psql`) que las lecturas se están insertando en tiempo real.
4. Añade manejo de reconexión: si PostgreSQL no está disponible al insertar, el colector debe reintentar sin caerse (usa `try/except` alrededor del `cursor.execute`).

## ✅ Autoevaluación

- [ ] Sé por qué usar consultas parametrizadas en vez de f-strings para SQL.
- [ ] Construí un colector MQTT → PostgreSQL funcional en Python.
- [ ] Entiendo la diferencia práctica entre `psycopg2` directo y un ORM como SQLAlchemy.
- [ ] Mi colector no se detiene si hay un error temporal de conexión a la base de datos.
