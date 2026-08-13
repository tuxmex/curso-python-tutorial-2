# Tarea — Módulo 06: Persistencia de datos desde Python y Node-RED

**Entrega:** script(s) `.py`, archivo `.env.example` (sin contraseñas reales) y capturas de la base de datos poblándose en tiempo real.
**Ponderación sugerida:** 10 puntos.

## Ejercicio 1 — Colector robusto (5 pts)

Escribe `colector_tarea.py` que:

1. Se suscriba a los tópicos de tu proceso y almacene cada lectura en tu tabla `lecturas` (módulo 05), usando **consultas parametrizadas**.
2. Use variables de entorno (`.env` + `python-dotenv`) para las credenciales de la base de datos — nunca contraseñas escritas directamente en el código.
3. Maneje errores de conexión a PostgreSQL sin detener el programa (usa `try/except` alrededor de las operaciones de base de datos y reintenta tras un breve `time.sleep`).
4. Inserte también en `alarmas` cuando una lectura esté fuera del rango definido en `equipos`.

## Ejercicio 2 — Prueba de resiliencia (3 pts)

1. Con el colector corriendo, detén el contenedor de PostgreSQL (`docker stop <contenedor>`) durante unos segundos y vuelve a levantarlo.
2. Documenta con capturas de pantalla que el colector no se cayó y que retomó las inserciones al restablecerse la conexión.

## Ejercicio 3 — Comparación técnica (2 pts)

Reescribe el fragmento de inserción de una lectura usando **SQLAlchemy** en lugar de `psycopg2` directo, y redacta un párrafo (mínimo 80 palabras) comparando ambos enfoques para tu propio proyecto: ¿cuál usarías en el proyecto integrador y por qué?

## Criterios de evaluación

| Criterio | Puntos |
|---|---|
| Colector funcional, seguro (parametrizado) y con manejo de errores | 5 |
| Evidencia de resiliencia ante caída de la base de datos | 3 |
| Comparación técnica psycopg2 vs. SQLAlchemy | 2 |
