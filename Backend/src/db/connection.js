import sql from "mssql/msnodesqlv8";

const config = {
    server: "Dou-Basic",
    database: "Prueba",
    options: {
      trustedConnection: true, // Set to true if using Windows Authentication
      trustServerCertificate: true, // Set to true if using self-signed certificates
    },
    driver: "msnodesqlv8", // Required if using Windows Authentication
  };