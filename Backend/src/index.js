import app from "./app.js";
import { getConnection } from "./db/connection.js"

// Iniciar el servidor en el puerto 3000
app.listen(3000)

console.log("Iniciando el servidor y recargando el servidor");

getConnection()