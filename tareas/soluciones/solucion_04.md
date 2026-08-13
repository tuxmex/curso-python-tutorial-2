# Solución de referencia — Tarea Módulo 04

> **Nota para el revisor:** Node-RED se evalúa principalmente por evidencia visual (capturas del editor y del dashboard) y por el archivo `flows_tarea.json` exportado. Aquí se describe la solución esperada nodo por nodo.

## Ejercicio 1 — Flujo completo para las 3 variables

**Estructura esperada por cada variable** (repetida 3 veces, una por sensor):

```
[mqtt in: utng/planta1/.../variable]
        │
        ▼
[function: "Parsear lectura"]
   msg.payload = JSON.parse(msg.payload).valor
        │
        ▼
[switch: 3 salidas]
   1) msg.payload > umbral_alto      -> salida "Alto"
   2) msg.payload < umbral_bajo      -> salida "Bajo"
   3) otherwise                      -> salida "Normal"
        │
   ┌────┼────────────────┐
   ▼    ▼                ▼
[gauge] [chart]     (Alto/Bajo) → [change: arma mensaje de alarma] → [mqtt out: .../alarma]
```

**Código de referencia — nodo `function` "Parsear lectura":**

```javascript
let datos;
try {
    datos = JSON.parse(msg.payload);
} catch (e) {
    node.warn("Payload inválido: " + msg.payload);
    return null;
}
msg.payload = datos.valor;
msg.sensor = datos.sensor;
return msg;
```

**Código de referencia — nodo `change` "Armar alarma":**

```
Set msg.payload = {"sensor": {{msg.sensor}}, "valor": {{msg.payload}}, "tipo": "alta"}
```

(o el equivalente usando un `function` node si el estudiante prefiere JavaScript explícito).

**Revisar en la evidencia:**
- Los 3 flujos completos (uno por variable), cada uno con `mqtt in → function → switch → gauge/chart` y rama de alarma.
- El `Tab` del dashboard nombrado según el proceso del estudiante (no genérico).
- Captura del dashboard mostrando los 3 gauges/charts actualizándose en tiempo real (alimentados por su simulador del módulo 03).
- Al menos un mensaje de alarma efectivamente publicado (verificable con `mosquitto_sub` en paralelo).

## Ejercicio 2 — Subflujo reutilizable

**Pasos esperados en la evidencia:**
1. Seleccionar los nodos `function` (parseo) + `switch` (evaluación) + `change` (armado de alarma).
2. Clic derecho → "Selection → Convert to subflow".
3. Definir dos propiedades de entrada del subflujo: `umbral_alto` y `umbral_bajo` (para que sea reutilizable con distintos rangos por variable).
4. Reemplazar la instancia repetida en al menos 2 de las 3 variables por el subflujo, configurando sus propiedades particulares.

**Revisar:** que el subflujo exista como definición única y se use al menos 2 veces con parámetros distintos (no solo copiado y pegado como nodos sueltos).

## Ejercicio 3 — Documentación del flujo

**Ejemplo de párrafo esperado:**

> Para cada variable definí un umbral alto y uno bajo basados en el rango operativo normal del equipo (por ejemplo, para el horno consideré normal 60–85 °C, alerta 85–95 °C y crítico fuera de ese rango). Elegí estos valores para dar margen de reacción antes de llegar al límite físico del equipo, en vez de esperar a que la variable ya esté en un valor peligroso. El flujo publica la alarma en un tópico separado (`.../alarma`) en lugar de mezclarla con el tópico de la variable, para que cualquier sistema que quiera suscribirse solo a eventos críticos (como el colector del módulo 06) pueda hacerlo sin tener que filtrar cada lectura normal.

**Revisar:** presencia de nodos `comment` explicando cada sección, y que el párrafo (80+ palabras) justifique los rangos elegidos con criterio técnico, no solo los liste.

## Rúbrica de calificación rápida

| Criterio | Máx. | Indicadores de logro completo |
|---|---|---|
| Flujo funcional con dashboard (3 variables) | 5 | Los 3 flujos operan, dashboard actualiza en vivo, alarma se publica |
| Subflujo reutilizable | 3 | Subflujo definido y usado 2+ veces con parámetros propios |
| Documentación | 2 | Comentarios en el flujo + párrafo con justificación técnica |
