# Solución de referencia — Tarea Módulo 07

> **Nota para el revisor:** solución modelo con el proceso de ejemplo del curso.

## Ejercicio 1 — API REST

```javascript
// server.js (fragmento relevante)
app.get("/api/lecturas/:idEquipo", async (req, res) => {
  try {
    const { idEquipo } = req.params;
    const limite = parseInt(req.query.limite) || 50;
    const resultado = await pool.query(
      "SELECT valor, marca_tiempo FROM lecturas WHERE id_equipo = $1 ORDER BY marca_tiempo DESC LIMIT $2",
      [idEquipo, limite]
    );
    res.json(resultado.rows.reverse());
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al consultar lecturas" });
  }
});

app.get("/api/alarmas/activas", async (req, res) => {
  try {
    const resultado = await pool.query(
      `SELECT a.id_alarma, e.nombre, a.tipo, a.valor_registrado, a.marca_tiempo
       FROM alarmas a JOIN equipos e ON e.id_equipo = a.id_equipo
       WHERE a.atendida = false
       ORDER BY a.marca_tiempo DESC`
    );
    res.json(resultado.rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al consultar alarmas" });
  }
});
```

**Revisar:** ambos endpoints usan parámetros (`$1`, `$2`), el primero acepta `?limite=` opcional con valor por defecto razonable, el segundo filtra correctamente por `atendida = false`.

## Ejercicio 2 — Puente MQTT-WebSocket para 3 variables

```javascript
const WebSocket = require("ws");
const mqtt = require("mqtt");

const wss = new WebSocket.Server({ port: 8080 });
const clienteMqtt = mqtt.connect("mqtt://localhost:1883");

clienteMqtt.on("connect", () => {
  clienteMqtt.subscribe("utng/#"); // cubre las 3 variables del proceso
});

clienteMqtt.on("message", (topico, payload) => {
  let datos;
  try {
    datos = JSON.parse(payload.toString());
  } catch {
    return;
  }
  const mensaje = JSON.stringify({ topico, datos });
  wss.clients.forEach((cliente) => {
    if (cliente.readyState === WebSocket.OPEN) cliente.send(mensaje);
  });
});
```

**Revisar:** el patrón de suscripción cubre las 3 variables (no solo una), y hay manejo básico de payload no-JSON para que el puente no se caiga.

## Ejercicio 3 — Dashboard con 3 gráficas simultáneas

```html
<canvas id="graficaTemperatura"></canvas>
<canvas id="graficaVelocidad"></canvas>
<canvas id="graficaVibracion"></canvas>
<p>Alarmas activas: <span id="contadorAlarmas">0</span></p>

<script>
let alarmasActivas = 0;
const graficas = {
  "horno/temperatura": crearGrafica("graficaTemperatura", "°C", 40, 100),
  "banda/velocidad": crearGrafica("graficaVelocidad", "m/s", 0, 3),
  "motor/vibracion": crearGrafica("graficaVibracion", "mm/s", 0, 5),
};
const RANGOS = {
  "horno/temperatura": [60, 95],
  "banda/velocidad": [0.5, 2.5],
  "motor/vibracion": [0.1, 4.0],
};

function crearGrafica(id, etiqueta, min, max) {
  const ctx = document.getElementById(id);
  return new Chart(ctx, {
    type: "line",
    data: { labels: [], datasets: [{ label: etiqueta, data: [], borderColor: "green" }] },
    options: { animation: false, scales: { y: { min, max } } },
  });
}

const socket = new WebSocket("ws://localhost:8080");
socket.onmessage = (evento) => {
  const { topico, datos } = JSON.parse(evento.data);
  const clave = Object.keys(graficas).find((k) => topico.includes(k));
  if (!clave) return;

  const grafica = graficas[clave];
  const [min, max] = RANGOS[clave];
  const fueraDeRango = datos.valor < min || datos.valor > max;

  grafica.data.datasets[0].borderColor = fueraDeRango ? "red" : "green";
  grafica.data.labels.push(new Date(datos.timestamp * 1000).toLocaleTimeString());
  grafica.data.datasets[0].data.push(datos.valor);
  if (grafica.data.labels.length > 30) {
    grafica.data.labels.shift();
    grafica.data.datasets[0].data.shift();
  }
  grafica.update();

  if (fueraDeRango) {
    alarmasActivas++;
    document.getElementById("contadorAlarmas").textContent = alarmasActivas;
  }
};
</script>
```

**Revisar:** 3 gráficas actualizándose en vivo (una por variable), cambio visual (color) ante valores fuera de rango, contador de alarmas visible y funcional.

## Ejercicio 4 — Vista de histórico

```javascript
document.getElementById("btnHistorico").addEventListener("click", async () => {
  const respuesta = await fetch("/api/lecturas/1?limite=50");
  const datos = await respuesta.json();
  graficas["horno/temperatura"].data.labels = datos.map(d => new Date(d.marca_tiempo).toLocaleTimeString());
  graficas["horno/temperatura"].data.datasets[0].data = datos.map(d => d.valor);
  graficas["horno/temperatura"].update();
});
```

**Revisar:** al presionar el botón, la gráfica se repuebla con datos reales obtenidos de `/api/lecturas/:idEquipo` (verificable comparando con lo almacenado en PostgreSQL), no con datos simulados en el frontend.

## Rúbrica de calificación rápida

| Criterio | Máx. | Indicadores de logro completo |
|---|---|---|
| Endpoints REST | 3 | Parametrizados, con filtro/límite funcionando |
| Puente MQTT-WebSocket | 2 | Cubre las 3 variables, no se cae con payload inválido |
| Dashboard en tiempo real | 4 | 3 gráficas + indicador visual + contador de alarmas |
| Vista de histórico | 1 | Repuebla la gráfica con datos reales de PostgreSQL |
