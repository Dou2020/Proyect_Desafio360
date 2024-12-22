import sql from "mssql"
process.loadEnvFile()

export const dbSettings = {
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  server: process.env.DB_SERVER,
  database: process.env.DB_DATABASE,
  options: {
    encrypt: false, // for azure
    trustServerCertificate: true, // change to true for local dev / self-signed certs
  },
};

export const getConnection = async () => {
  try {
    const pool = await sql.connect(dbSettings)
    console.log("-----conexion realizada-----")
    //const result = await pool.request().query("SELECT * FROM usuarios")
    //console.log(result);
    return pool
  } catch (error) {
    console.error(error)
  }
};

export { sql };