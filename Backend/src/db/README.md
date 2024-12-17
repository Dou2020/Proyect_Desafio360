## Conexión con Variables de entorno
```
const sql = require('mssql')

const sqlConfig = {
  user: process.env.DB_USER,
  password: process.env.DB_PWD,
  database: process.env.DB_NAME,
  server: 'localhost',
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000
  },
  options: {
    encrypt: true, // for azure
    trustServerCertificate: false // change to true for local dev / self-signed certs
  }
}

(async () => {
 try {
  // make sure that any items are correctly URL encoded in the connection string
  await sql.connect(sqlConfig)
  const result = await sql.query`select * from mytable where id = ${value}`
  console.dir(result)
 } catch (err) {
  // ... error checks
 }
})()
```
## Conexión con Windows Authetication
```
const sql = require('mssql/msnodesqlv8');

const config = {
  server: "MyServer",
  database: "MyDatabase",
  options: {
    trustedConnection: true, // Set to true if using Windows Authentication
    trustServerCertificate: true, // Set to true if using self-signed certificates
  },
  driver: "msnodesqlv8", // Required if using Windows Authentication
};

(async () => {
  try {
    await sql.connect(config);
    const result = await sql.query`select TOP 10 * from MyTable`;
    console.dir(result);
  } catch (err) {
    console.error(err);
  }
})();
```