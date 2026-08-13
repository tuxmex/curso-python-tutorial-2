# Tarea — Módulo 08: Proyecto integrador (entrega final)

**Entrega:** repositorio Git completo (o carpeta comprimida) con todos los componentes, más un video corto (3–5 min) mostrando el sistema funcionando de extremo a extremo.
**Ponderación sugerida:** 40 puntos (equivale al proyecto integrador del curso; ver rúbrica detallada en el módulo 08).

## Ejercicio integrador — Sistema SCADA ligero completo

Integra en un solo repositorio todos los componentes desarrollados en las tareas de los módulos 01–07, aplicados de forma **consistente** al mismo proceso industrial que definiste desde el módulo 01:

1. **`docker-compose.yml`** con Mosquitto y PostgreSQL (y opcionalmente pgAdmin).
2. **`python/simulador.py`** — o lectura real desde hardware (ESP32/PLC) si tienes acceso a él.
3. **`python/colector.py`** — robusto ante desconexiones, con variables de entorno.
4. **`node-red/flows.json`** — con al menos un subflujo reutilizable y lógica de alarmas.
5. **`sql/schema.sql`** — esquema completo, con la tabla adicional que propusiste en la tarea del módulo 05.
6. **`dashboard/`** — backend Express + frontend con las 3 gráficas en tiempo real, histórico y contador de alarmas.
7. **`README.md`** del proyecto, con:
   - Diagrama de arquitectura (imagen o ASCII).
   - Instrucciones de instalación y ejecución paso a paso.
   - Justificación de las decisiones técnicas (rangos de alarma, convención de tópicos, por qué esa tabla adicional en la base de datos, etc.).

## Video de demostración (obligatorio)

Graba un video de 3 a 5 minutos donde:

1. Levantes el sistema desde cero (`docker compose up`, colector, Node-RED, dashboard).
2. Muestres datos llegando en tiempo real al dashboard.
3. Provoques manualmente una condición de alarma y muestres cómo se refleja en Node-RED **y** en el dashboard web.
4. Consultes el histórico desde la interfaz web.

## Rúbrica de evaluación

*(idéntica a la presentada en el módulo 08 — ver también `modulos/modulo_08_proyecto_integrador.md`)*

| Criterio | Ponderación |
|---|---|
| Adquisición y mensajería | 25% |
| Automatización (Node-RED) | 15% |
| Persistencia | 20% |
| Visualización web | 25% |
| Documentación | 15% |
