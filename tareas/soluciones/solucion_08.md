# Solución de referencia — Tarea Módulo 08 (Proyecto integrador)

> **Nota para el revisor:** el proyecto integrador es, por diseño, personalizado a cada proceso industrial elegido por el estudiante desde el módulo 01. No existe un único "código correcto" a comparar línea por línea; esta guía sirve para verificar que **todos los componentes están presentes, integrados y funcionando de extremo a extremo**, reutilizando las soluciones de los módulos 01–07 como referencia de calidad esperada.

## Checklist de revisión del repositorio

| Componente esperado | Dónde revisar | Referencia de solución |
|---|---|---|
| `docker-compose.yml` con Mosquitto + PostgreSQL | Raíz del repo | `solucion_01.md`, Ejercicio 3 |
| `python/simulador.py` (o lectura real desde ESP32/PLC) | `python/` | `solucion_03.md`, Ejercicio 1 |
| `python/colector.py` robusto, con `.env` | `python/` | `solucion_06.md`, Ejercicio 1 |
| `node-red/flows.json` con subflujo y alarmas | `node-red/` | `solucion_04.md`, Ejercicios 1–2 |
| `sql/schema.sql` con tabla adicional justificada | `sql/` | `solucion_05.md`, Ejercicio 1 |
| `dashboard/` (Express + frontend, tiempo real + histórico) | `dashboard/` | `solucion_07.md`, Ejercicios 1–4 |
| `README.md` con diagrama, instalación y justificación | Raíz del repo | Ver plantilla abajo |
| Video de demostración (3–5 min) | Adjunto o enlace en el README | Ver guion sugerido abajo |

## Prueba de integración de extremo a extremo (procedimiento de revisión)

1. `docker compose up -d` — confirmar Mosquitto y PostgreSQL activos (`docker ps`).
2. Ejecutar `python/colector.py` — confirmar en consola que se conecta sin errores.
3. Ejecutar `python/simulador.py` — confirmar con `mosquitto_sub -t "utng/#" -v` que los datos fluyen.
4. Importar y desplegar `node-red/flows.json` — confirmar en el dashboard de Node-RED que las gráficas se mueven y que se dispara al menos una alarma al forzar un valor fuera de rango en el simulador.
5. Verificar en `psql`/pgAdmin que `lecturas` y `alarmas` se están poblando en tiempo real.
6. Levantar `dashboard/` (`node server.js`) — confirmar que el frontend muestra las 3 variables en vivo, que el contador de alarmas reacciona, y que el botón de histórico trae datos reales desde PostgreSQL.
7. Detener y reiniciar el contenedor de PostgreSQL mientras todo corre — confirmar que el colector se recupera sin caerse (criterio ya evaluado en la tarea del módulo 06, pero debe seguir cumpliéndose en el sistema integrado).

**Si cualquiera de estos 7 pasos falla, el criterio correspondiente de la rúbrica (ver tabla siguiente) no puede calificarse como logrado**, independientemente de que el componente exista como archivo.

## Plantilla mínima esperada del README del proyecto

```markdown
# Sistema SCADA ligero — [Nombre del proceso elegido]

## Arquitectura
[Diagrama de las 5 capas aplicado al proceso específico]

## Instalación
1. docker compose up -d
2. python -m venv venv && ...
3. python python/colector.py
4. python python/simulador.py
5. Importar node-red/flows.json en http://localhost:1880
6. cd dashboard && npm install && node server.js

## Decisiones de diseño
- Convención de tópicos: ...
- Rangos de alarma y su justificación: ...
- Tabla adicional en el esquema y su propósito: ...
```

## Guion sugerido para el video de demostración

1. (0:00–1:00) Levantar el sistema desde cero (`docker compose up`, colector, simulador).
2. (1:00–2:30) Mostrar el dashboard web recibiendo datos en tiempo real de las 3 variables.
3. (2:30–3:30) Forzar una condición de alarma (ajustar el rango del simulador) y mostrar cómo se refleja tanto en Node-RED como en el dashboard propio (cambio de color + contador de alarmas).
4. (3:30–4:30) Usar la vista de histórico del dashboard y contrastarla con una consulta directa en pgAdmin/psql sobre la misma tabla.
5. (4:30–5:00) Cierre: mencionar una limitación conocida y una posible extensión futura (de las sugeridas en el módulo 08).

## Rúbrica de evaluación detallada

| Criterio | Ponderación | Se considera logrado cuando... |
|---|---|---|
| Adquisición y mensajería | 25% | 3+ variables reales/simuladas, convención de tópicos documentada y consistente, LWT implementado |
| Automatización (Node-RED) | 15% | Flujo con detección de alarmas funcionando end-to-end, con al menos un subflujo reutilizable |
| Persistencia | 20% | Colector estable, sobrevive una caída/reconexión de PostgreSQL sin intervención manual |
| Visualización web | 25% | Dashboard propio (no solo el de Node-RED) con vista en vivo, histórico y alarmas visibles simultáneamente |
| Documentación | 15% | README completo según la plantilla anterior + video que demuestra los 7 pasos de la prueba de integración |

**Nota de calificación:** un proyecto que solo demuestra los componentes por separado (ej. el colector funciona en aislamiento, pero nunca se probó junto con el dashboard) debe considerarse incompleto en el criterio de "Persistencia" y/o "Visualización web", aun si cada script individual es correcto — el objetivo del módulo 08 es la **integración**, no la suma de partes.
