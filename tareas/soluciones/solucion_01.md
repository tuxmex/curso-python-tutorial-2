# Solución de referencia — Tarea Módulo 01

> **Nota para el revisor:** esta es una solución modelo usando el proceso de ejemplo del curso (horno de línea 3, banda transportadora de línea 1, motor de línea 2). El trabajo del estudiante usará **su propio proceso elegido**; lo que debe evaluarse es que la lógica, estructura y buenas prácticas sean equivalentes — no que los valores coincidan.

## Ejercicio 1 — Repaso de Python

```python
# repaso.py

class Sensor:
    def __init__(self, nombre, valor_min, valor_max):
        self.nombre = nombre
        self.valor_min = valor_min
        self.valor_max = valor_max

    def en_rango(self, valor):
        return self.valor_min <= valor <= self.valor_max


sensores = [
    Sensor("horno_01_temperatura", 60, 95),
    Sensor("banda_01_velocidad", 0.5, 2.5),
    Sensor("motor_02_vibracion", 0.1, 4.0),
]

lecturas_crudas = [82.3, "78x", 1.9, None, 0.4]

for sensor, lectura in zip(sensores * 2, lecturas_crudas):
    try:
        valor = float(lectura)
        estado = "EN RANGO" if sensor.en_rango(valor) else "FUERA DE RANGO"
        print(f"{sensor.nombre}: {valor} -> {estado}")
    except (TypeError, ValueError):
        print(f"{sensor.nombre}: lectura inválida ({lectura!r}), se omite")
```

**Puntos a verificar en la entrega del estudiante:**
- La clase `Sensor` con los 3 atributos y el método `en_rango` correctamente implementado (comparación con `<=` en ambos extremos).
- Al menos 3 objetos `Sensor` con valores propios de su proceso (no copiados del ejemplo de clase).
- Manejo de excepciones que evite que el programa se detenga ante una lectura inválida — cualquier variante razonable de `try/except` (`ValueError`, `TypeError`) es válida.

## Ejercicio 2 — Entorno de trabajo

Comandos esperados en la evidencia (captura de pantalla):

```bash
python3 -m venv venv
source venv/bin/activate
pip install paho-mqtt psycopg2-binary
pip freeze > requirements.txt
```

`requirements.txt` esperado (versiones pueden variar):

```
paho-mqtt==2.1.0
psycopg2-binary==2.9.9
```

**Revisar:** que el prompt de la terminal muestre `(venv)` activo, y que `requirements.txt` contenga ambas librerías con número de versión.

## Ejercicio 3 — Infraestructura con Docker

```yaml
# docker-compose.yml (ejemplo de solución)
version: "3.9"
services:
  mosquitto:
    image: eclipse-mosquitto:2
    ports:
      - "1883:1883"
      - "9001:9001"
    volumes:
      - ./mosquitto/config:/mosquitto/config

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

`docker ps` esperado (2 contenedores, columna `STATUS` en `Up`):

```
CONTAINER ID   IMAGE                    STATUS         PORTS
xxxxxxxx       eclipse-mosquitto:2      Up X minutes   0.0.0.0:1883->1883/tcp...
xxxxxxxx       postgres:16              Up X minutes   0.0.0.0:5432->5432/tcp
```

**Revisar:** que el estudiante haya escrito el archivo por sí mismo (nombres de servicio, variables de entorno coherentes con lo que usará en módulos posteriores) y que la captura confirme ambos contenedores activos.

## Ejercicio 4 — Definición del proyecto integrador

**Ejemplo de respuesta esperada (nivel y extensión de referencia):**

> Monitorearé el proceso de horneado y transporte en la línea de ensamble 3 de una planta metalmecánica simulada. Las tres variables clave son: temperatura del horno de curado (rango normal 60–95 °C, crítico por riesgo de deformación de piezas fuera de este rango), velocidad de la banda transportadora (0.5–2.5 m/s, relevante para sincronizar tiempos de ciclo) y vibración del motor de la línea 2 (0.1–4.0 mm/s, indicador temprano de desgaste mecánico o desbalanceo). Monitorear estas variables en tiempo real permite anticipar fallas antes de que generen paros de producción, y el histórico permite justificar mantenimientos preventivos con datos reales en lugar de calendarios fijos. [...]

**Revisar:**
- Extensión mínima de 150 palabras.
- Las 3 variables están claramente definidas con unidades y justificación.
- El diagrama de arquitectura (aunque sea a mano) refleja las 5 capas vistas en clase, adaptadas al caso propio.

## Rúbrica de calificación rápida

| Criterio | Máx. | Indicadores de logro completo |
|---|---|---|
| Código funcional y sin errores | 4 | Clase `Sensor` correcta + manejo de excepciones robusto |
| Entorno y Docker configurados | 3 | Capturas claras, ambos servicios corriendo |
| Claridad del caso de uso | 3 | 150+ palabras, 3 variables justificadas, diagrama propio |
