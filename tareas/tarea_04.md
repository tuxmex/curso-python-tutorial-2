# Tarea — Módulo 04: Automatización visual de flujos con Node-RED

**Entrega:** archivo `flows_tarea.json` exportado de Node-RED + capturas de pantalla del flujo y del dashboard.
**Ponderación sugerida:** 10 puntos.

## Ejercicio 1 — Flujo completo para las 3 variables (5 pts)

Construye en Node-RED un flujo que, para **cada una** de las 3 variables de tu proceso:

1. Reciba los datos vía `mqtt in`.
2. Los parsee con un nodo `function`.
3. Evalúe el valor con un nodo `switch` de al menos 3 salidas (alto / normal / bajo).
4. Muestre el valor en un `gauge` y su tendencia en un `chart`, agrupados en un `Tab` llamado con el nombre de tu proceso.
5. Publique un mensaje de alarma (`mqtt out`) cuando el valor esté fuera de rango.

## Ejercicio 2 — Subflujo reutilizable (3 pts)

Convierte la lógica de "parseo + evaluación de rango + alarma" en un **subflujo** reutilizable, y reemplázalo en al menos 2 de tus 3 variables. Adjunta captura de pantalla mostrando el subflujo definido y su uso repetido.

## Ejercicio 3 — Documentación del flujo (2 pts)

Agrega comentarios (`comment` nodes) explicando cada sección del flujo, y escribe un párrafo breve (mínimo 80 palabras) explicando la lógica de alarmas que implementaste (qué rangos elegiste y por qué).

## Criterios de evaluación

| Criterio | Puntos |
|---|---|
| Flujo funcional para las 3 variables con dashboard | 5 |
| Uso correcto de subflujos | 3 |
| Documentación clara del flujo | 2 |
