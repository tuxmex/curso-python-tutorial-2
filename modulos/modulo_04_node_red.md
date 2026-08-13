# Módulo 04 — Automatización visual de flujos con Node-RED

## Objetivos de aprendizaje

- Comprender el modelo de programación por flujos (flow-based programming).
- Construir flujos que consuman datos MQTT, los transformen y disparen alarmas.
- Usar `node-red-dashboard` para crear un panel de control instantáneo.
- Preparar el flujo que escribirá datos hacia PostgreSQL (se completa en el módulo 05–06).

## 4.1 ¿Qué es Node-RED y por qué se usa en la industria?

Node-RED es una herramienta de programación visual basada en Node.js, creada originalmente por IBM para IoT. Permite conectar "nodos" (bloques funcionales) arrastrando cables entre ellos, en lugar de escribir todo el código de integración a mano. Es ampliamente adoptada en automatización industrial porque:

- Se integra nativamente con MQTT, HTTP, bases de datos, OPC-UA (con nodos adicionales) y Modbus.
- Permite a técnicos sin programación avanzada modificar flujos.
- Facilita crear dashboards rápidos para el piso de planta.

## 4.2 Instalación y primer arranque

```bash
npm install -g --unsafe-perm node-red
node-red
```

Abre el editor en `http://localhost:1880`.

Instala los paletas necesarias desde **Menú → Manage palette → Install**:
- `node-red-dashboard`
- `node-red-contrib-postgresql` (se usará en el módulo 06)

## 4.3 Anatomía de un flujo básico: MQTT → Debug

1. Arrastra un nodo **mqtt in**, configúralo con:
   - Server: `localhost:1883`
   - Topic: `utng/planta1/#`
2. Arrastra un nodo **debug** y conéctalo a la salida del nodo MQTT.
3. Da clic en **Deploy**.
4. Corre tu simulador de Python del módulo 03 y observa los mensajes en el panel de depuración lateral.

## 4.4 Transformar el payload con un nodo `function`

El payload que llega es un string JSON; conviene parsearlo dentro del flujo:

```javascript
// Nodo function: "Parsear lectura"
let datos;
try {
    datos = JSON.parse(msg.payload);
} catch (e) {
    node.warn("Payload no válido: " + msg.payload);
    return null;
}

msg.payload = datos.valor;
msg.topic = msg.topic;          // se conserva el tópico original
msg.sensor = datos.sensor;
msg.timestamp = datos.timestamp;

return msg;
```

## 4.5 Lógica de alarmas con nodo `switch`

Usa un nodo **switch** después del `function` para separar el flujo según rangos:

- Regla 1: `msg.payload > 90` → salida "Alarma alta"
- Regla 2: `msg.payload < 60` → salida "Alarma baja"
- Regla 3 (default/else): salida "Normal"

Conecta la salida "Alarma alta" a un nodo **change** que arma un mensaje de alerta, y de ahí a un nodo **mqtt out** que publique en `utng/planta1/linea3/horno/alarma`.

## 4.6 Dashboard instantáneo con `node-red-dashboard`

Agrega, después del nodo `function` de la sección 4.4:

- Un nodo **gauge** (medidor tipo velocímetro) — ideal para temperatura.
- Un nodo **chart** — para ver la tendencia de los últimos minutos.
- Un nodo **text** — para mostrar el último valor con etiqueta.

Configura cada uno con el mismo **Group** (ej. "Horno Línea 3") dentro de un **Tab** llamado "Planta 1". Accede al dashboard en `http://localhost:1880/ui`.

> **Nota pedagógica:** este dashboard de Node-RED es excelente para prototipar rápido, pero en el módulo 07 construiremos un dashboard **propio en JavaScript puro** para que los docentes entiendan qué ocurre "bajo el capó" y puedan personalizarlo completamente (Node-RED dashboard limita el control de diseño).

## 4.7 Buenas prácticas para flujos mantenibles

- Agrupa nodos relacionados con **comentarios** (`Ctrl+clic` para arrastrar múltiples nodos a la vez).
- Usa **subflujos** cuando repitas la misma lógica para varios sensores (ej. "Validar rango + Alarma" como subflujo reutilizable).
- Exporta el flujo regularmente: **Menú → Export → Clipboard/File** — el archivo resultante es JSON y debe versionarse en Git.
- Nunca dejes credenciales de PostgreSQL o MQTT escritas directamente en nodos `function`; usa las credenciales encriptadas de Node-RED (`flows_cred.json`, que **no** se sube al repositorio).

## 🧪 Práctica 4.1 — Flujo completo de una variable de proceso

1. Construye el flujo: `mqtt in` → `function` (parseo) → `switch` (umbral) → `gauge` + `chart` en el dashboard, y una rama de alarma → `mqtt out`.
2. Usa el simulador del módulo 03 para alimentar el flujo.
3. Provoca manualmente una condición de alarma (ajusta el rango del simulador) y confirma que el mensaje de alarma se publica correctamente.
4. Exporta el flujo como `flows/modulo04_flujo_basico.json` para tu proyecto integrador.

## ✅ Autoevaluación

- [ ] Puedo construir un flujo MQTT → transformación → dashboard sin apoyo.
- [ ] Entiendo cuándo usar un nodo `function` vs un nodo `switch`.
- [ ] Sé exportar e importar flujos como JSON versionable en Git.
- [ ] Tengo un flujo funcional para al menos una variable de mi proceso industrial elegido.
