# Tarea — Módulo 01: Repaso, entorno de trabajo y arquitectura del sistema

**Entrega:** archivo `.md` o `.pdf` con capturas de pantalla + carpeta del proyecto (o repositorio Git) con la estructura solicitada.
**Ponderación sugerida:** 10 puntos.

## Ejercicio 1 — Repaso de Python (2 pts)

Escribe un script `repaso.py` que:

1. Defina una clase `Sensor` con atributos `nombre`, `valor_min`, `valor_max` y un método `en_rango(valor)` que regrese `True`/`False`.
2. Cree una lista de al menos 3 objetos `Sensor` distintos (usa variables de tu propio proceso industrial, ej. temperatura, presión, RPM).
3. Recorra la lista y, usando manejo de excepciones (`try/except`), simule la evaluación de una lectura inválida (por ejemplo, un valor tipo texto) sin que el programa se detenga.

## Ejercicio 2 — Entorno de trabajo (2 pts)

1. Crea un entorno virtual llamado `venv` para este curso.
2. Instala `paho-mqtt` y `psycopg2-binary` (los usarás en módulos posteriores).
3. Genera el archivo `requirements.txt` con `pip freeze`.
4. Adjunta captura de pantalla de la terminal mostrando el entorno activado y el contenido de `requirements.txt`.

## Ejercicio 3 — Infraestructura con Docker (3 pts)

1. Instala Docker (si no lo tienes) y crea tu propio `docker-compose.yml` con los servicios `mosquitto` y `postgres` (puedes basarte en el visto en clase, pero debes escribirlo tú mismo, no copiarlo).
2. Levanta los contenedores con `docker compose up -d`.
3. Adjunta la salida de `docker ps` mostrando ambos contenedores corriendo.

## Ejercicio 4 — Definición del proyecto integrador (3 pts)

Redacta media cuartilla (mínimo 150 palabras) respondiendo:

- ¿Qué proceso industrial o mecatrónico monitorearás durante todo el curso?
- ¿Qué 3 variables de proceso medirás? (ej. temperatura, vibración, nivel, velocidad, presión)
- ¿Por qué es relevante monitorear ese proceso en un entorno real de planta?
- Dibuja (a mano o con herramienta digital) el diagrama de arquitectura de 5 capas aplicado a tu caso específico.

## Criterios de evaluación

| Criterio | Puntos |
|---|---|
| Código funcional y sin errores | 4 |
| Entorno y Docker correctamente configurados (evidencia con capturas) | 3 |
| Claridad y pertinencia del caso de uso elegido | 3 |
