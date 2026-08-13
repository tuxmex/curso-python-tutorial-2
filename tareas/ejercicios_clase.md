# Ejercicios de Clase — Curso 2

## Guía simple para el docente: qué hacer en cada sesión, explicado en fácil

> Estos son ejercicios cortos para hacer **durante la clase** (15–25 minutos cada uno), diferentes de las tareas para la casa. La idea es que cada docente los resuelva mientras el instructor explica, para "aprender haciendo" y no solo escuchando. Cada ejercicio está explicado como si fuera la primera vez que se ve el tema — sin dar por hecho vocabulario técnico.

---

## Módulo 01 — Preparar el terreno

### 🧩 Idea de este módulo, en una frase
Vamos a preparar la "cocina" (el entorno de trabajo) antes de empezar a cocinar (programar). Sin esto, nada de lo que sigue va a funcionar bien.

### Ejercicio en clase 1.1 — Instalar y comprobar herramientas (10 min)

**¿Qué vamos a hacer?** Verificar que las 4 herramientas del curso están instaladas: Python, Docker, Node.js y Git. Es como revisar que la estufa, el refrigerador, la licuadora y los trastes estén en la cocina antes de empezar a cocinar.

**Pasos:**
1. Abre una terminal (línea de comandos).
2. Escribe cada uno de estos comandos, uno por uno, y dale Enter:
   ```
   python3 --version
   docker --version
   node -v
   git --version
   ```
3. Cada comando debe responder con un número de versión (por ejemplo `Python 3.11.4`). Si en vez de eso dice "comando no encontrado", esa herramienta falta por instalar.

**¿Cómo sé que salió bien?** Los 4 comandos muestran un número de versión, sin errores en rojo.

### Ejercicio en clase 1.2 — Levantar los "servicios" con un solo comando (10 min)

**¿Qué es esto?** Docker es como un conjunto de aparatos ya armados y listos para usar, en vez de tener que instalarlos uno por uno a mano. Con un solo comando, "encendemos" dos aparatos: el mensajero (Mosquitto) y el archivero (PostgreSQL).

**Pasos:**
1. En la carpeta que el instructor comparta, ejecuta:
   ```
   docker compose up -d
   ```
2. Espera unos segundos y escribe:
   ```
   docker ps
   ```
3. Debes ver **dos** líneas: una dice `mosquitto` y otra `postgres`.

**¿Cómo sé que salió bien?** El comando `docker ps` muestra los dos contenedores con la palabra `Up` (arriba/encendido) junto a ellos.

**Analogía para recordar:** `docker compose up` es como apretar el botón de encendido general de una fábrica en miniatura: prende varias máquinas a la vez, ya conectadas entre sí.

---

## Módulo 02 — MQTT: la mensajería de las máquinas

### 🧩 Idea de este módulo, en una frase
MQTT es como un grupo de WhatsApp para máquinas: una máquina "publica" un mensaje en un grupo (tópico), y todas las demás que estén suscritas a ese grupo lo reciben al instante.

### Ejercicio en clase 2.1 — Tu primer mensaje entre máquinas (15 min)

**¿Qué vamos a hacer?** Simular una conversación entre dos máquinas usando dos ventanas de terminal: una que "escucha" y otra que "habla".

**Pasos:**
1. Abre **dos** ventanas de terminal, una al lado de la otra.
2. En la ventana **izquierda** (la que va a "escuchar"), escribe:
   ```
   mosquitto_sub -h localhost -t "saludo" -v
   ```
   Esto la deja esperando mensajes, como alguien viendo el WhatsApp sin escribir nada.
3. En la ventana **derecha** (la que va a "hablar"), escribe:
   ```
   mosquitto_pub -h localhost -t "saludo" -m "Hola desde la ventana derecha"
   ```
4. Mira la ventana izquierda: el mensaje debe aparecer ahí de inmediato.

**¿Cómo sé que salió bien?** El texto "Hola desde la ventana derecha" aparece en la ventana que estaba escuchando, sin que tú lo hayas escrito ahí.

**Palabra clave explicada fácil:**
- **Tópico** = el "nombre del grupo" (en el ejemplo, `saludo`). Solo quien esté escuchando ese mismo nombre recibe el mensaje.
- **Publicar** = enviar un mensaje al grupo.
- **Suscribirse** = "unirte" a un grupo para recibir lo que se publique ahí.

### Ejercicio en clase 2.2 — Un grupo con "subgrupos" (10 min)

**¿Qué vamos a hacer?** Ver cómo un tópico puede tener niveles, como carpetas dentro de carpetas.

**Pasos:**
1. En la ventana que escucha, cambia el comando para escuchar **todo** lo que empiece con `planta1/`:
   ```
   mosquitto_sub -h localhost -t "planta1/#" -v
   ```
   El símbolo `#` significa "y todo lo que venga después", como decir "avísame de cualquier cosa que pase en la fábrica".
2. En la otra ventana, publica en distintos "subgrupos":
   ```
   mosquitto_pub -h localhost -t "planta1/horno/temperatura" -m "82"
   mosquitto_pub -h localhost -t "planta1/banda/velocidad" -m "1.5"
   ```
3. Observa que **ambos** mensajes llegan a la ventana que escucha, aunque son de "subgrupos" distintos.

**¿Cómo sé que salió bien?** Los dos mensajes aparecen en la ventana izquierda, cada uno con su tópico completo.

---

## Módulo 03 — Python hablando MQTT

### 🧩 Idea de este módulo, en una frase
En vez de escribir mensajes a mano en la terminal, ahora hacemos que Python los escriba solo, automáticamente, una y otra vez — como un sensor real haría.

### Ejercicio en clase 3.1 — Tu primer "sensor" de mentiras (15 min)

**¿Qué vamos a hacer?** Un programa de Python que se hace pasar por un sensor de temperatura, inventando un número cada 3 segundos y publicándolo por MQTT.

**Pasos:**
1. Crea un archivo `mi_sensor.py` con este contenido (el instructor lo proyecta, tú lo copias y lo entiendes línea por línea):
   ```python
   import time, random
   import paho.mqtt.client as mqtt

   cliente = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
   cliente.connect("localhost", 1883)
   cliente.loop_start()

   while True:
       temperatura = round(random.uniform(60, 95), 1)
       cliente.publish("mi_horno/temperatura", str(temperatura))
       print("Envié:", temperatura)
       time.sleep(3)
   ```
2. Ejecútalo con `python mi_sensor.py`.
3. En otra terminal, escucha con:
   ```
   mosquitto_sub -h localhost -t "mi_horno/temperatura" -v
   ```

**¿Cómo sé que salió bien?** Cada 3 segundos aparece un número nuevo, tanto en la ventana donde corre el sensor como en la que escucha.

**Explicación línea por línea (en fácil):**
- `random.uniform(60, 95)` = "dame un número al azar entre 60 y 95", igual que tirar un dado pero con decimales.
- `cliente.publish(...)` = "manda este mensaje al grupo llamado mi_horno/temperatura".
- `time.sleep(3)` = "espérate 3 segundos antes de seguir", para no mandar mil mensajes por segundo.
- `while True:` = "repite esto para siempre", hasta que tú lo detengas con Ctrl+C.

### Ejercicio en clase 3.2 — Dos sensores a la vez (10 min)

**¿Qué vamos a hacer?** Agregar un segundo "sensor de mentiras" al mismo programa, para simular dos máquinas reportando al mismo tiempo.

**Pasos:**
1. Copia tu archivo del ejercicio anterior y agrega, antes del `while True`, una segunda variable de tópico.
2. Reto: usando lo que el instructor explique de `threading`, haz que ambos sensores publiquen "al mismo tiempo" sin que uno tenga que esperar al otro.

**¿Cómo sé que salió bien?** Al escuchar con `mosquitto_sub -t "#" -v` ves mensajes intercalados de ambos sensores.

---

## Módulo 04 — Node-RED: conectar cosas sin escribir tanto código

### 🧩 Idea de este módulo, en una frase
Node-RED es como armar un diagrama de flujo con piezas de LEGO: cada pieza hace una cosa (recibir, revisar, mostrar) y tú solo las conectas con líneas, casi sin escribir código.

### Ejercicio en clase 4.1 — Ver llegar tus datos en una pantalla (15 min)

**¿Qué vamos a hacer?** Conectar Node-RED para que reciba los datos de tu sensor del módulo 03 y los muestre en pantalla, sin escribir ni una línea de Python nueva.

**Pasos:**
1. Abre Node-RED en el navegador: `http://localhost:1880`.
2. Del panel izquierdo, arrastra una pieza llamada **mqtt in** al lienzo.
3. Haz doble clic en ella y en "Topic" escribe `mi_horno/temperatura` (el mismo que usaste en el módulo 03).
4. Arrastra una pieza llamada **debug** y conéctala con una línea a la salida de `mqtt in` (arrastrando desde el circulito de un lado al circulito del otro).
5. Da clic en el botón **Deploy** (arriba a la derecha).
6. Corre tu `mi_sensor.py` del módulo 03 si no está corriendo.
7. Abre el panel de depuración (el icono de "bug" a la derecha) y observa.

**¿Cómo sé que salió bien?** Ves los números de temperatura apareciendo solos en el panel derecho de Node-RED, cada 3 segundos.

**Analogía para recordar:** cada pieza (nodo) es como una estación de una banda transportadora: la primera "recibe la caja" (el dato), y tú decides a qué otra estación se va después, solo conectando un cable.

### Ejercicio en clase 4.2 — Un medidor tipo velocímetro (10 min)

**¿Qué vamos a hacer?** En vez de solo ver números en texto, mostrar la temperatura en un medidor visual, como el tablero de un coche.

**Pasos:**
1. Del panel izquierdo, busca la sección "dashboard" y arrastra una pieza llamada **gauge**.
2. Conéctala también a la salida de `mqtt in` (puedes tener dos cables saliendo del mismo nodo).
3. Haz doble clic en `gauge` y ajusta el mínimo en 60 y el máximo en 95 (el rango de tu sensor).
4. Da clic en **Deploy**.
5. Abre `http://localhost:1880/ui` en otra pestaña del navegador.

**¿Cómo sé que salió bien?** Ves una aguja o medidor circular moviéndose en vivo con cada nuevo dato.

---

## Módulo 05 — PostgreSQL: la libreta donde guardamos todo

### 🧩 Idea de este módulo, en una frase
Hasta ahora, los datos aparecen y desaparecen (como un mensaje de voz que se borra al escucharlo). PostgreSQL es la libreta donde los anotamos para siempre, y luego poder consultarlos.

### Ejercicio en clase 5.1 — Crear tu primera "libreta" de datos (15 min)

**¿Qué vamos a hacer?** Crear una tabla (como una hoja de Excel con columnas fijas) para guardar lecturas de temperatura.

**Pasos:**
1. Conéctate a la base de datos (el instructor muestra cómo, con pgAdmin o `psql`).
2. Escribe y ejecuta:
   ```sql
   CREATE TABLE mis_lecturas (
       id SERIAL PRIMARY KEY,
       valor NUMERIC(10,2),
       momento TIMESTAMPTZ DEFAULT now()
   );
   ```
3. Ahora inserta un par de datos "a mano" para probar:
   ```sql
   INSERT INTO mis_lecturas (valor) VALUES (82.5);
   INSERT INTO mis_lecturas (valor) VALUES (79.1);
   ```
4. Pide ver todo lo que guardaste:
   ```sql
   SELECT * FROM mis_lecturas;
   ```

**¿Cómo sé que salió bien?** El último comando muestra una tabla con 2 filas: un número de id, el valor y la fecha/hora en que se guardó (puesta automáticamente).

**Explicación en fácil:**
- `CREATE TABLE` = "crea una hoja nueva con estas columnas".
- `SERIAL PRIMARY KEY` = una columna que se numera sola (1, 2, 3...) para identificar cada fila, como el número de folio de un documento.
- `DEFAULT now()` = "si no me dices la fecha, pon automáticamente la fecha y hora de ahora mismo".
- `INSERT INTO` = "agrega una fila nueva".
- `SELECT * FROM` = "muéstrame todo lo que hay en esta hoja".

### Ejercicio en clase 5.2 — Preguntarle cosas a tu libreta (10 min)

**¿Qué vamos a hacer?** Practicar 3 preguntas típicas que un supervisor de planta haría, usando SQL.

**Pasos — ejecuta una por una y observa el resultado:**
```sql
-- ¿Cuál es el promedio de todas mis lecturas?
SELECT AVG(valor) FROM mis_lecturas;

-- ¿Cuál fue el valor más alto?
SELECT MAX(valor) FROM mis_lecturas;

-- ¿Cuántas lecturas llevo guardadas en total?
SELECT COUNT(*) FROM mis_lecturas;
```

**¿Cómo sé que salió bien?** Cada consulta responde con un solo número, y ese número tiene sentido con los datos que insertaste (por ejemplo, si insertaste 82.5 y 79.1, el promedio debe estar entre esos dos valores).

---

## Módulo 06 — El "cartero" que guarda todo automáticamente

### 🧩 Idea de este módulo, en una frase
Hasta ahora guardábamos datos a mano en la libreta (módulo 05). Ahora escribimos un programa "cartero" que toma cada mensaje MQTT que llega y lo anota solo en la libreta, sin que nadie tenga que escribirlo.

### Ejercicio en clase 6.1 — Tu primer "cartero" automático (20 min)

**¿Qué vamos a hacer?** Un programa Python que escucha MQTT y, cada vez que llega un dato, lo guarda automáticamente en PostgreSQL.

**Pasos:**
1. Instala lo necesario (si no lo tienes):
   ```
   pip install psycopg2-binary
   ```
2. Crea `cartero.py` con este contenido (explicado abajo):
   ```python
   import psycopg2
   import paho.mqtt.client as mqtt

   conexion = psycopg2.connect(
       host="localhost", dbname="procesos_industriales",
       user="utng", password="utng_industrial"
   )
   conexion.autocommit = True
   cursor = conexion.cursor()

   def al_recibir_mensaje(client, userdata, msg):
       valor = float(msg.payload.decode())
       cursor.execute(
           "INSERT INTO mis_lecturas (valor) VALUES (%s);", (valor,)
       )
       print("Guardado en la base de datos:", valor)

   cliente = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
   cliente.on_message = al_recibir_mensaje
   cliente.connect("localhost", 1883)
   cliente.subscribe("mi_horno/temperatura")
   cliente.loop_forever()
   ```
3. Corre `cartero.py` en una terminal.
4. Corre tu `mi_sensor.py` del módulo 03 en otra terminal.
5. Regresa a pgAdmin/psql y ejecuta `SELECT * FROM mis_lecturas ORDER BY momento DESC LIMIT 5;`

**¿Cómo sé que salió bien?** Ves filas nuevas aparecer en la tabla cada pocos segundos, sin que tú las hayas escrito a mano.

**Explicación en fácil:**
- `on_message` = "cada vez que llegue un mensaje nuevo, haz esto" — como una regla automática de tu correo ("cuando llegue un email de mi jefe, muéveme a la carpeta Importante").
- `%s` en el `INSERT` = un espacio en blanco que se llena de forma segura con el valor, en vez de "pegarlo" directamente al texto (esto evita errores y problemas de seguridad).

---

## Módulo 07 — JavaScript: la pantalla que ve el operador

### 🧩 Idea de este módulo, en una frase
Todo lo anterior pasa "detrás de cámaras". Este módulo es la vitrina: una página web bonita donde el operador de la máquina ve los números moverse en vivo, sin tener que abrir ninguna terminal.

### Ejercicio en clase 7.1 — Tu primera página que "escucha" datos en vivo (20 min)

**¿Qué vamos a hacer?** Una página HTML muy simple que se conecta al sistema y muestra el último valor recibido, actualizándose solo.

**Pasos (con ayuda del instructor para el puente MQTT-WebSocket ya preparado):**
1. Crea un archivo `pagina.html`:
   ```html
   <!DOCTYPE html>
   <html>
   <body>
     <h1>Temperatura actual: <span id="valor">--</span> °C</h1>
     <script>
       const socket = new WebSocket("ws://localhost:8080");
       socket.onmessage = (evento) => {
         const mensaje = JSON.parse(evento.data);
         document.getElementById("valor").textContent = mensaje.datos.valor;
       };
     </script>
   </body>
   </html>
   ```
2. Ábrelo directamente en tu navegador (doble clic en el archivo, o arrástralo a una pestaña).
3. Asegúrate de que el "puente" que el instructor preparó (el servidor Node.js) esté corriendo, y que tu sensor del módulo 03 siga publicando.

**¿Cómo sé que salió bien?** El número junto a "Temperatura actual" cambia solo cada pocos segundos, sin que tú recargues la página.

**Explicación en fácil:**
- Un **WebSocket** es como dejar una llamada telefónica abierta en vez de colgar y volver a marcar cada vez: el navegador y el servidor se quedan "conectados" y el servidor puede avisarle al navegador en cualquier momento, sin que el navegador tenga que estar preguntando "¿ya hay algo nuevo? ¿ya hay algo nuevo?".
- `JSON.parse(evento.data)` = "convierte el mensaje de texto que llegó en algo que JavaScript pueda leer por partes" (como abrir un sobre y sacar la carta de adentro).

### Ejercicio en clase 7.2 — Agregar una gráfica (10 min)

**¿Qué vamos a hacer?** En vez de solo un número, ver la tendencia de los últimos minutos con una línea que sube y baja.

**Pasos:**
1. Agrega antes de `</body>`:
   ```html
   <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
   <canvas id="grafica" width="500" height="250"></canvas>
   ```
2. Con ayuda del instructor, agrega el código de Chart.js que va guardando cada valor nuevo en la gráfica.

**¿Cómo sé que salió bien?** Ves una línea que va creciendo hacia la derecha con cada nuevo dato.

---

## Módulo 08 — Proyecto integrador: uniendo todas las piezas

### 🧩 Idea de este módulo, en una frase
Ya construiste cada pieza por separado (sensor, mensajero, libreta, cartero, pantalla). Ahora las conectamos todas para formar una sola máquina completa, como armar por fin el rompecabezas con todas las piezas que ya tienes.

### Ejercicio en clase 8.1 — Encender el sistema completo, en orden (20 min)

**¿Qué vamos a hacer?** Practicar, paso a paso y en el orden correcto, cómo se enciende todo el sistema construido a lo largo del curso — esto es exactamente lo que harán en su proyecto final.

**Pasos (en este orden, sin saltarse ninguno):**
1. `docker compose up -d` — enciende Mosquitto y PostgreSQL.
2. Confirma con `docker ps` que ambos están arriba.
3. Corre tu `cartero.py` del módulo 06 (el que guarda en la base de datos).
4. Corre tu `mi_sensor.py` del módulo 03 (el que genera los datos).
5. Abre Node-RED (`http://localhost:1880`) y despliega tu flujo del módulo 04.
6. Abre tu `pagina.html` del módulo 07 en el navegador.
7. Revisa, en este orden: ¿los datos llegan a Node-RED? ¿se guardan en PostgreSQL? ¿se ven en la página web?

**¿Cómo sé que salió bien?** Puedes "apagar" cualquier pieza (por ejemplo, cerrar el sensor) y explicar con tus propias palabras qué parte del sistema deja de recibir datos y por qué — eso demuestra que entiendes cómo se conecta todo.

**Analogía para recordar:** es como encender un cine en casa: primero la corriente (Docker), luego el reproductor (el sensor/cartero), luego la pantalla (Node-RED/página web). Si algo no se ve, revisas en ese mismo orden para encontrar dónde está el corte.

### Ejercicio en clase 8.2 — "¿Qué pasa si...?" (10 min, en pareja)

**¿Qué vamos a hacer?** Un ejercicio de diagnóstico oral, en parejas, para reforzar que entienden el flujo completo y no solo lo memorizaron.

**Instrucciones:** El instructor (o tu compañero) plantea una de estas preguntas al azar; respondes en voz alta, sin ver el material:

- "Si apago PostgreSQL, ¿el sensor deja de mandar datos? ¿Por qué sí o por qué no?"
- "Si cierro la página web, ¿se pierden los datos que ya se guardaron?"
- "¿Qué parte del sistema avisa si un sensor se desconectó de repente?"
- "Si quiero agregar una cuarta variable a monitorear, ¿qué archivos/piezas tengo que tocar?"

**¿Cómo sé que salió bien?** Puedes responder señalando qué "pieza" del sistema (sensor, Mosquitto, colector, PostgreSQL, Node-RED o dashboard) es responsable de cada cosa, sin confundirlas entre sí.

---

## 📋 Resumen para el instructor: tiempos sugeridos por sesión

| Módulo | Ejercicios en clase | Tiempo total sugerido |
|---|---|---|
| 01 | 1.1 + 1.2 | 20 min |
| 02 | 2.1 + 2.2 | 25 min |
| 03 | 3.1 + 3.2 | 25 min |
| 04 | 4.1 + 4.2 | 25 min |
| 05 | 5.1 + 5.2 | 25 min |
| 06 | 6.1 | 20 min |
| 07 | 7.1 + 7.2 | 30 min |
| 08 | 8.1 + 8.2 | 30 min |

**Sugerencia pedagógica:** deja que cada docente escriba el código a mano (no copiar/pegar) al menos la primera vez que aparece un patrón nuevo — copiar y pegar no deja el aprendizaje que dejar que se equivoquen y corrijan un error de sintaxis por sí mismos.
