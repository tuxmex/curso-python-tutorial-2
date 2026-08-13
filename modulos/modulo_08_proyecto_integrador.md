# Módulo 08 — Proyecto integrador: Sistema SCADA ligero

## Objetivo

Integrar todos los componentes construidos en los módulos 01–07 en un sistema funcional de monitoreo industrial de extremo a extremo, aplicado al proceso de mecatrónica o procesos industriales que cada docente eligió desde el módulo 01.

## Arquitectura final esperada

```
┌─────────────────┐      MQTT       ┌────────────┐
│ Sensores reales  │ ───────────────►│            │
│ (ESP32) o        │                 │  Mosquitto │
│ Simulador Python │ ───────────────►│  (broker)  │
└─────────────────┘                 └─────┬──────┘
                                            │
                    ┌───────────────────────┼───────────────────────┐
                    ▼                       ▼                       ▼
             ┌─────────────┐        ┌──────────────┐       ┌──────────────────┐
             │  Node-RED    │        │  Colector    │       │ Puente MQTT-WS    │
             │  (alarmas +  │        │  Python      │       │ (Node.js/Express) │
             │  dashboard   │        │  → PostgreSQL│       │                   │
             │  rápido)     │        └──────┬───────┘       └────────┬──────────┘
             └─────────────┘                │                        │
                                             ▼                        ▼
                                     ┌──────────────┐        ┌──────────────────┐
                                     │ PostgreSQL   │◄───────┤ API REST (Express)│
                                     │ (histórico)  │        └────────┬──────────┘
                                     └──────────────┘                 │
                                                                       ▼
                                                          ┌──────────────────────┐
                                                          │ Dashboard Web         │
                                                          │ (HTML + Chart.js +    │
                                                          │  WebSocket)           │
                                                          └──────────────────────┘
```

## Requisitos mínimos del proyecto

1. **Adquisición**: al menos 3 variables de proceso, simuladas en Python (módulo 03) o, si el docente cuenta con hardware, leídas desde un ESP32/PLC real vía MQTT.
2. **Mensajería**: Mosquitto configurado con convención de tópicos documentada (módulo 02).
3. **Automatización**: al menos un flujo de Node-RED que detecte condiciones fuera de rango y publique una alarma (módulo 04).
4. **Persistencia**: esquema PostgreSQL con catálogo de equipos, histórico de lecturas y registro de alarmas (módulo 05), alimentado por un colector Python robusto ante desconexiones (módulo 06).
5. **Visualización**: dashboard web propio (no solo el de Node-RED) con al menos:
   - Una vista en tiempo real (WebSocket) de al menos una variable.
   - Una vista de histórico (API REST + PostgreSQL) con selección de rango de tiempo.
   - Indicador visual de alarmas activas.
6. **Documentación técnica**: README del proyecto con diagrama de arquitectura, instrucciones de instalación/ejecución, y justificación de las decisiones de diseño (por qué esos rangos de alarma, esa convención de tópicos, ese esquema de base de datos).

## Guía de desarrollo sugerida (por sesiones)

| Sesión | Entregable |
|--------|------------|
| 1 | `docker-compose.yml` funcional (Mosquitto + PostgreSQL) + simulador Python de las 3 variables |
| 2 | Esquema PostgreSQL creado y colector MQTT → PostgreSQL corriendo de forma estable |
| 3 | Flujo Node-RED con detección de alarmas y publicación en tópico de alarma |
| 4 | Backend Express: endpoint REST + puente WebSocket |
| 5 | Frontend: gráficas en tiempo real + vista de histórico |
| 6 | Integración final, pruebas de estrés (desconectar y reconectar cada componente), documentación |

## Rúbrica de evaluación sugerida

| Criterio | Insuficiente | Suficiente | Sobresaliente |
|---|---|---|---|
| Adquisición y mensajería (25%) | Un solo sensor simulado, sin convención de tópicos | 3 variables, convención de tópicos documentada | Convención escalable + manejo de LWT/desconexión |
| Automatización (Node-RED) (15%) | Flujo básico sin alarmas | Detección de alarmas funcional | Subflujos reutilizables, múltiples reglas |
| Persistencia (20%) | Inserciones manuales o inconsistentes | Colector automático estable | Colector con reconexión y manejo robusto de errores |
| Visualización web (25%) | Solo dashboard de Node-RED | Dashboard propio con tiempo real o histórico | Dashboard propio con tiempo real **y** histórico, con alarmas visibles |
| Documentación (15%) | README mínimo | README completo con instrucciones | Incluye diagrama de arquitectura y justificación de decisiones técnicas |

## Extensiones opcionales (para docentes que quieran ir más allá)

- Sustituir el simulador Python por un **ESP32 real** con sensores DHT22 (temperatura/humedad) o un potenciómetro, publicando por MQTT vía WiFi (MicroPython, ya cubierto en el curso de IoT Applications).
- Añadir autenticación básica en Mosquitto (usuario/contraseña, TLS).
- Migrar el histórico a **TimescaleDB** para practicar consultas de series de tiempo optimizadas.
- Generar reportes PDF automáticos del turno usando Python (`reportlab` o similar) a partir de las consultas del módulo 05.
- Contenerizar todo el sistema (Python, Node.js, Node-RED) con `docker-compose` para despliegue de un clic en el laboratorio.

## ✅ Entregable final

Repositorio Git del proyecto con:
- `docker-compose.yml`
- `python/` (simulador + colector)
- `node-red/flows.json`
- `dashboard/` (backend Express + frontend)
- `sql/schema.sql`
- `README.md` con diagrama de arquitectura y guía de instalación
