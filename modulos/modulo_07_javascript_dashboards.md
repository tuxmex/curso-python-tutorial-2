# Módulo 07 — JavaScript para tableros web industriales

## Objetivos de aprendizaje

- Repasar JavaScript moderno (ES6+) orientado a construir un backend y un frontend simples.
- Construir una API REST con Node.js + Express que exponga datos de PostgreSQL.
- Implementar comunicación en tiempo real con **WebSockets** (los datos llegan sin recargar la página).
- Graficar variables de proceso en el navegador con **Chart.js**.

## 7.1 ¿Por qué JavaScript aquí, si ya tenemos Node-RED?

Node-RED (módulo 04) es excelente para prototipar, pero un dashboard de producción normalmente necesita:
- Diseño visual completamente personalizado (marca institucional, layouts específicos).
- Lógica de negocio más compleja (autenticación de operadores, reportes en PDF, etc.).
- Integración con otros sistemas web existentes de la planta.

Este módulo enseña a construir ese dashboard **desde cero**, para que los docentes entiendan la capa web completa, no solo el prototipo visual de Node-RED.

## 7.2 Repaso rápido de JavaScript moderno

```javascript
// Arrow functions, destructuring, template literals
const formatearLectura = ({ sensor, valor, timestamp }) =>
  `${sensor}: ${valor} (${new Date(timestamp * 1000).toLocaleTimeString()})`;

// Async/await para trabajo asíncrono (equivalente conceptual a Python asyncio)
async function obtenerLecturas() {
  const respuesta = await fetch("/api/lecturas");
  const datos = await respuesta.json();
  return datos;
}

// Módulos ES6
export function calcularPromedio(valores) {
  return valores.reduce((a, b) => a + b, 0) / valores.length;
}
```

## 7.3 Backend con Node.js + Express

```bash
mkdir dashboard && cd dashboard
npm init -y
npm install express pg ws dotenv cors
```

```javascript
// server.js
const express = require("express");
const cors = require("cors");
const { Pool } = require("pg");
require("dotenv").config();

const app = express();
app.use(cors());
app.use(express.static("public"));

const pool = new Pool({
  host: process.env.DB_HOST || "localhost",
  user: process.env.DB_USER || "utng",
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME || "procesos_industriales",
  port: process.env.DB_PORT || 5432,
});

// Endpoint REST: últimas 50 lecturas de un equipo
app.get("/api/lecturas/:idEquipo", async (req, res) => {
  try {
    const { idEquipo } = req.params;
    const resultado = await pool.query(
      "SELECT valor, marca_tiempo FROM lecturas WHERE id_equipo = $1 ORDER BY marca_tiempo DESC LIMIT 50",
      [idEquipo]
    );
    res.json(resultado.rows.reverse());
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al consultar la base de datos" });
  }
});

const PUERTO = process.env.PORT || 3000;
app.listen(PUERTO, () => console.log(`Servidor corriendo en http://localhost:${PUERTO}`));
```

**Nota de seguridad:** igual que en Python, las consultas usan parámetros (`$1`) en vez de interpolar strings — la misma regla contra SQL injection aplica en JavaScript.

## 7.4 Tiempo real con WebSockets (puente MQTT → navegador)

El navegador no puede suscribirse directamente a MQTT sin un puente. Usamos `ws` en el backend, que reenvía lo que llega de MQTT hacia todos los clientes web conectados:

```javascript
// server.js (continuación)
const WebSocket = require("ws");
const mqtt = require("mqtt");

const wss = new WebSocket.Server({ port: 8080 });
const clienteMqtt = mqtt.connect("mqtt://localhost:1883");

clienteMqtt.on("connect", () => {
  console.log("Puente MQTT-WebSocket conectado");
  clienteMqtt.subscribe("utng/#");
});

clienteMqtt.on("message", (topico, payload) => {
  const mensaje = JSON.stringify({ topico, datos: JSON.parse(payload.toString()) });
  wss.clients.forEach((cliente) => {
    if (cliente.readyState === WebSocket.OPEN) {
      cliente.send(mensaje);
    }
  });
});
```

```bash
npm install mqtt
```

## 7.5 Frontend: gráfica en vivo con Chart.js

```html
<!-- public/index.html -->
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Panel Industrial — Línea 3</title>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
  <h1>Temperatura del Horno — Línea 3</h1>
  <canvas id="graficaTemperatura" width="600" height="300"></canvas>

  <script>
    const ctx = document.getElementById("graficaTemperatura");
    const grafica = new Chart(ctx, {
      type: "line",
      data: { labels: [], datasets: [{ label: "°C", data: [], borderColor: "rgb(220,53,69)", tension: 0.2 }] },
      options: { animation: false, scales: { y: { min: 40, max: 100 } } }
    });

    const socket = new WebSocket("ws://localhost:8080");
    socket.onmessage = (evento) => {
      const mensaje = JSON.parse(evento.data);
      if (mensaje.topico.includes("horno/temperatura")) {
        const ahora = new Date(mensaje.datos.timestamp * 1000).toLocaleTimeString();
        grafica.data.labels.push(ahora);
        grafica.data.datasets[0].data.push(mensaje.datos.valor);
        if (grafica.data.labels.length > 30) {
          grafica.data.labels.shift();
          grafica.data.datasets[0].data.shift();
        }
        grafica.update();
      }
    };
  </script>
</body>
</html>
```

## 7.6 Arquitectura resultante de este módulo

```
Mosquitto ──► puente MQTT/WebSocket (Node.js) ──► navegador (Chart.js, tiempo real)
    │
    └────────────────────────────► colector Python (módulo 06) ──► PostgreSQL ──► API REST (Express) ──► navegador (históricos)
```

El dashboard combina **dos fuentes**: WebSocket para lo que ocurre *ahora mismo*, y la API REST para consultar el *histórico* almacenado en PostgreSQL.

## 🧪 Práctica 7.1 — Dashboard mínimo para tu proceso

1. Implementa el endpoint `/api/lecturas/:idEquipo` para al menos un equipo de tu proceso.
2. Implementa el puente WebSocket y confirma que los datos llegan en vivo al abrir la consola del navegador (`console.log`).
3. Agrega una segunda gráfica de Chart.js para una segunda variable.
4. (Opcional, reto) Agrega un indicador visual (cambio de color de fondo) cuando llegue un mensaje de alarma por WebSocket.

## ✅ Autoevaluación

- [ ] Puedo construir un endpoint REST con Express que consulte PostgreSQL de forma segura.
- [ ] Entiendo por qué se necesita un puente MQTT-WebSocket para que el navegador reciba datos en vivo.
- [ ] Tengo una gráfica en tiempo real funcionando con Chart.js.
- [ ] Puedo explicar la diferencia entre el flujo "en vivo" (WebSocket) y el flujo "histórico" (REST + PostgreSQL).
