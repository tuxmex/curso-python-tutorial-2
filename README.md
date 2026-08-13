# 🏭 Curso 2: Python Aplicado a Sistemas Industriales IoT

## Integración de Python, Node-RED, PostgreSQL, JavaScript y MQTT (Mosquitto) para Mecatrónica y Procesos Industriales

Bienvenido al repositorio del **Curso 2**, continuación de *Fundamentos de Python*. Este curso está diseñado para docentes de Mecatrónica y Procesos Industriales de la UTNG que ya dominan las bases de Python (módulos 1–10 del Curso 1) y que ahora construirán **sistemas completos de monitoreo y control industrial**, integrando adquisición de datos, mensajería, persistencia y visualización web.

## Instructor

**M.T.I. Anastacio Rodríguez García**
División de Tecnologías de la Información y Comunicación — UTNG

## 🎯 Objetivo general

Al finalizar el curso, el docente será capaz de diseñar, implementar y desplegar un **sistema de monitoreo industrial de extremo a extremo**: sensores/actuadores → protocolo MQTT (Mosquitto) → automatización de flujos (Node-RED) → base de datos relacional (PostgreSQL) → panel web interactivo (JavaScript), aplicable directamente a prácticas de mecatrónica y procesos industriales.

## 🧩 Prerrequisitos

- Haber cursado o dominar el contenido del Curso 1 (Fundamentos de Python: módulos 01–10)
- Nociones básicas de redes (IP, puertos) y electrónica digital (útil, no indispensable)
- Equipo con Docker o instalación local de Python 3.11+, Node.js 18+, PostgreSQL 15+ y Mosquitto

## 📚 Contenido del curso

| Módulo | Tema | Herramientas clave |
|--------|------|---------------------|
| 01 | Repaso, entorno de trabajo y arquitectura del sistema | Python venv, Git, Docker |
| 02 | Fundamentos de mensajería industrial: MQTT y Mosquitto | Mosquitto, MQTT Explorer |
| 03 | Python como cliente MQTT: publicación y suscripción | paho-mqtt |
| 04 | Automatización visual de flujos con Node-RED | Node-RED, node-red-dashboard |
| 05 | Modelado de datos industriales con PostgreSQL | PostgreSQL, SQL, pgAdmin |
| 06 | Persistencia de datos desde Python | psycopg2, SQLAlchemy |
| 07 | JavaScript para tableros web industriales | Node.js, Express, Chart.js, WebSockets |
| 08 | Proyecto integrador: Sistema SCADA ligero | Todo lo anterior |

---

## 🚀 Cómo empezar

### 1. Clona el repositorio

```bash
git clone https://github.com/tuxmex/curso-python-tutorial-2.git
cd curso-python-tutorial-2
```

### 2. Levanta los servicios de infraestructura (Mosquitto + PostgreSQL) con Docker

```bash
docker compose up -d
```

### 3. Crea el entorno virtual de Python

```bash
python3 -m venv venv
source venv/bin/activate   # En Windows: venv\Scripts\activate
pip install -r requirements.txt
```

### 4. Instala Node-RED y Node.js

```bash
npm install -g --unsafe-perm node-red
node-red
```

## 🗂️ Estructura del repositorio

```
curso2/
├── README.md
├── modulos/            # Contenido teórico-práctico de cada módulo (Markdown)
├── presentaciones/      # Diapositivas .pptx por módulo
├── guiones/             # Guion completo del docente por sesión (minuto a minuto + narración)
├── tareas/              # Ejercicios de tarea por sesión/módulo (Markdown)
│   ├── ejercicios_clase.md  # Ejercicios cortos para resolver en sesión, explicados en fácil
│   └── soluciones/       # Guías de solución para revisión docente
├── recursos/            # docker-compose.yml, requirements.txt, datasets de ejemplo
└── src/                 # Código fuente de ejemplos y del proyecto integrador
```

## 📏 Evaluación sugerida

| Rubro | Ponderación |
|-------|-------------|
| Prácticas por módulo (01–07) | 50% |
| Proyecto integrador (módulo 08) | 40% |
| Participación y documentación técnica | 10% |
