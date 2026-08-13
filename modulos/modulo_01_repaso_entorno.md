# Módulo 01 — Repaso, entorno de trabajo y arquitectura del sistema

## Objetivos de aprendizaje

- Repasar los conceptos clave de Python necesarios para el curso (funciones, POO básica, manejo de excepciones, entornos virtuales).
- Comprender la **arquitectura de referencia** que se construirá a lo largo del curso.
- Configurar el entorno de trabajo completo: Python, Docker, Node.js y Git.

## 1.1 ¿Por qué esta arquitectura?

En automatización y procesos industriales es común encontrar sistemas **SCADA** (Supervisory Control and Data Acquisition). A lo largo de este curso construiremos una versión ligera y educativa de un SCADA, con software libre:

```
[Sensores / PLC / ESP32]
        │  (lecturas)
        ▼
   MQTT Broker (Mosquitto)  ◄── protocolo estándar IoT/industrial (también usado por Sparkplug B)
        │
        ▼
     Node-RED  ── flujos visuales: transforma, filtra, enruta y dispara alarmas
        │
        ▼
   PostgreSQL  ── histórico de variables de proceso (series de tiempo simplificadas)
        │
        ▼
  Backend Node.js/Express + WebSockets
        │
        ▼
   Dashboard Web (JavaScript + Chart.js)  ── visualización en tiempo real para el operador
```

Cada módulo del curso agrega una capa de este diagrama, hasta llegar al sistema completo en el módulo 08.

## 1.2 Repaso rápido de Python (autoevaluación)

Antes de continuar, confirma que puedes resolver sin apoyo:

```python
# 1. Funciones con valores por defecto y *args/**kwargs
def leer_sensor(nombre, unidad="°C", **metadata):
    print(f"{nombre}: valor simulado en {unidad}")
    print(metadata)

leer_sensor("Temperatura_Horno", ubicacion="Línea 3", criticidad="alta")

# 2. Clases y encapsulamiento básico
class Sensor:
    def __init__(self, nombre, valor_min, valor_max):
        self.nombre = nombre
        self._valor_min = valor_min
        self._valor_max = valor_max

    def en_rango(self, valor):
        return self._valor_min <= valor <= self._valor_max

# 3. Manejo de excepciones
try:
    valor = float("23.5x")
except ValueError as e:
    print(f"Lectura corrupta del sensor: {e}")
```

Si alguno de estos bloques no es claro, repasa los módulos 04–08 y 10 del Curso 1 antes de avanzar.

## 1.3 Entornos virtuales (buenas prácticas)

```bash
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip freeze > requirements.txt
```

**Regla de oro para el curso:** cada carpeta de proyecto (por módulo) tendrá su propio `requirements.txt`. Nunca instalar librerías del curso en el Python del sistema.

## 1.4 Docker Compose: la infraestructura del curso

Usaremos Docker para levantar Mosquitto y PostgreSQL sin instalarlos manualmente en cada máquina del laboratorio. Archivo `recursos/docker-compose.yml` (se explica a detalle en el módulo 02 y 05):

```yaml
version: "3.9"
services:
  mosquitto:
    image: eclipse-mosquitto:2
    ports:
      - "1883:1883"
      - "9001:9001"
    volumes:
      - ./mosquitto/config:/mosquitto/config
      - ./mosquitto/data:/mosquitto/data
      - ./mosquitto/log:/mosquitto/log

  postgres:
    image: postgres:16
    environment:
      POSTGRES_USER: utng
      POSTGRES_PASSWORD: utng_industrial
      POSTGRES_DB: procesos_industriales
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
```

## 1.5 Instalación de Node.js y Node-RED

```bash
# Verificar versión (se recomienda Node 18 LTS o superior)
node -v
npm -v

npm install -g --unsafe-perm node-red
```

## 1.6 Control de versiones para proyectos multi-lenguaje

Este curso mezcla Python, JavaScript y flujos de Node-RED (JSON). Plantilla de `.gitignore` recomendada:

```
venv/
__pycache__/
node_modules/
*.pyc
.env
flows_cred.json
```

## 🧪 Práctica 1.1

1. Instala Docker Desktop (o Docker Engine en Linux) y confirma con `docker --version`.
2. Crea la estructura de carpetas del proyecto integrador (puede reutilizarse en módulos siguientes):
   ```
   proyecto_scada/
   ├── docker-compose.yml
   ├── mosquitto/config/mosquitto.conf
   ├── python/
   ├── node-red/
   └── dashboard/
   ```
3. Levanta `docker compose up -d` y confirma con `docker ps` que Mosquitto y PostgreSQL están corriendo.
4. Escribe en tu bitácora técnica (Markdown) un diagrama propio (puede ser ASCII) explicando qué proceso industrial de tu especialidad (mecatrónica o procesos industriales) te gustaría monitorear con este sistema.

## ✅ Autoevaluación

- [ ] Puedo explicar con mis palabras las 5 capas de la arquitectura del curso.
- [ ] Tengo Docker, Python 3.11+, Node.js 18+ y Git funcionando.
- [ ] Definí el caso de uso industrial que usaré como hilo conductor del proyecto integrador.
