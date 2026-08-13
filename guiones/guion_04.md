# Guion del docente — Sesión 04
## Automatización visual de flujos con Node-RED

## Ficha técnica de la sesión

| | |
|---|---|
| **Duración total** | 2 horas (120 min) |
| **Objetivo de la sesión** | Que cada docente-alumno construya un flujo completo en Node-RED: recepción MQTT, transformación, lógica de alarmas y visualización en dashboard. |
| **Material que debes preparar antes** | `modulo_04.pptx`; Node-RED instalado y con las paletas `node-red-dashboard` ya agregadas; tu propio flujo de ejemplo ya armado para la demo. |
| **Requisito técnico del salón** | Node-RED instalado en cada equipo (`npm install -g --unsafe-perm node-red`); simulador Python de la sesión 3 funcionando. |
| **Documentos de apoyo** | `modulos/modulo_04_node_red.md`, `tareas/ejercicios_clase.md` (Módulo 04), `tareas/tarea_04.md` |

---

## Minuto a minuto

| Tiempo | Bloque | Qué hacer |
|---|---|---|
| 0:00–0:10 | Recuperación | Verificar Docker + simulador Python de sesión 3 |
| 0:10–0:20 | ¿Qué es Node-RED? | Analogía de LEGO / banda transportadora |
| 0:20–0:35 | Tour del editor | Paletas, lienzo, Deploy |
| 0:35–0:55 | Ejercicio en clase 4.1 | mqtt in → debug |
| 0:55–1:00 | Descanso | — |
| 1:00–1:20 | Demo: function + switch | Codificar el flujo de alarmas en vivo |
| 1:20–1:40 | Ejercicio guiado | Cada quien arma su flujo de alarma |
| 1:40–2:00 | Ejercicio en clase 4.2 | Dashboard con gauge/chart |
| 2:00–2:15 | Cierre y tarea | Explicar tarea 04 (subflujos) |

---

## Guion narrado

### Apertura (0:00–0:10)

> "Levanten Docker como siempre, y corran su simulador de Python de la sesión pasada — lo van a necesitar corriendo de fondo durante toda la sesión de hoy."

### Bloque 1 — ¿Qué es Node-RED? (0:10–0:20)

> "Hasta ahora, todo lo que hicimos fue escribiendo código línea por línea. Hoy vamos a construir algo distinto: en vez de escribir código, vamos a **conectar piezas con el mouse**."

**Analogía central de la sesión:**
> "Imaginen una banda transportadora de una fábrica. Cada estación de la banda hace una sola cosa: una recibe la caja, otra la revisa, otra la etiqueta, otra la manda a un lugar u otro según lo que traiga adentro. Node-RED es exactamente eso, pero con datos en vez de cajas: cada 'nodo' es una estación, y ustedes deciden cómo se conectan."

### Bloque 2 — Tour del editor (0:20–0:35)

**Acción:** proyecta tu Node-RED abierto y recorre, señalando cada zona:
- Panel izquierdo = "la caja de piezas de LEGO disponibles."
- Lienzo central = "la mesa donde armamos."
- Botón Deploy = "el botón que dice 'ya quedó, actívalo de verdad'."
- Panel derecho (debug) = "una ventana para espiar qué está pasando adentro, mientras armamos."

> "Una regla de oro en Node-RED: si hacen un cambio y no le dan clic a Deploy, ese cambio **no existe todavía** para el sistema. Es una de las confusiones más comunes al principio."

### Ejercicio en clase 4.1 (0:35–0:55)

Guía el arrastre del primer nodo `mqtt in` + `debug` en tiempo real, paso a paso, esperando a que todos lo tengan antes de seguir. Este es el primer contacto con la herramienta — ve despacio aquí, aunque parezca simple.

**Verificación antes de avanzar:** pide que todos vean números aparecer en el panel de depuración antes del descanso. Si alguien no ve nada, revisa en este orden: ¿el tópico está bien escrito? ¿el simulador de Python sigue corriendo? ¿le dieron Deploy?

### Descanso (0:55–1:00)

### Bloque 3 — Demo: function + switch (1:00–1:20)

> "Ahora sí, la parte interesante: vamos a hacer que el flujo 'piense' un poco. Primero convertimos el mensaje en un número usable, y luego decidimos qué hacer según ese número."

**Codifica en vivo el nodo `function`:**
```javascript
let datos = JSON.parse(msg.payload);
msg.payload = datos.valor;
return msg;
```
> "Este es el único momento de la sesión donde sí escribimos código — pero es código cortito, JavaScript, dentro de una sola pieza. El resto de las 'decisiones' las vamos a tomar con más piezas, no con más código."

**Arma el nodo `switch` en vivo**, explicando las 3 reglas (alto/normal/bajo) con el rango de tu proceso de ejemplo.

> "Este nodo es como un guardia de tránsito: mira el número que llega y decide por cuál 'carril' de salida lo manda."

### Ejercicio guiado (1:20–1:40)

Deja que cada quien arme su propio `function` + `switch` con los rangos de su proceso (definidos desde la tarea 01/02). Circula resolviendo el error más común: **la sintaxis de JavaScript no es igual a Python** — muchos intentarán escribir `msg.payload = datos["valor"]` con corchetes como en Python; recuérdales que en JavaScript se usa punto: `datos.valor`.

### Ejercicio en clase 4.2 — Dashboard (1:40–2:00)

> "Vamos a cerrar la sesión con algo visual y satisfactorio: un medidor tipo velocímetro, como el tablero de un coche."

Guía la instalación/verificación de `node-red-dashboard` si aún no la tienen, y el armado del nodo `gauge`. Cierra abriendo `http://localhost:1880/ui` en todo el salón al mismo tiempo, para que vean sus medidores moviéndose juntos — es un buen momento de cierre grupal.

### Cierre y tarea (2:00–2:15)

Presenta `tarea_04.md`, enfatizando el concepto de **subflujo**:

> "La tarea les pide convertir su lógica de alarma en un subflujo reutilizable. Piensen en esto como crear su propia pieza de LEGO personalizada, para no tener que armar la misma combinación de piezas 3 veces si tienen 3 variables."

---

## Preguntas frecuentes anticipadas

| Pregunta típica | Respuesta sugerida |
|---|---|
| "¿Node-RED reemplaza a la programación?" | "No — reemplaza la parte de *integración* (conectar piezas ya hechas). Cuando necesitas lógica muy específica, sigues usando código dentro de un nodo `function`, como hicimos hoy." |
| "¿Por qué a veces mi cambio no se refleja aunque ya lo edité?" | "Seguramente falta darle clic a Deploy — es el error más común al empezar con Node-RED." |
| "¿Puedo tener varios flujos (tabs) para cosas distintas?" | "Sí, de hecho es buena práctica: un tab por proceso o por área de la planta, para no saturar un solo lienzo." |

## Nota pedagógica de cierre

Node-RED suele generar mucho entusiasmo por lo visual e inmediato de los resultados — aprovecha ese momentum para el ejercicio del dashboard al final, pero cuida que no se les vaya el tiempo "decorando" el dashboard en vez de completar la lógica de alarmas, que es el objetivo central de la sesión.
