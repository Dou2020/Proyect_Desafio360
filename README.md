## DATABASE
**SQL SERVER en Docker(Linux)**
- Descargar la imagen de SQL SERVER.
```docker
docker pull mcr.microsoft.com/mssql/server:2022-latest
```
- Correr la imagen
```docker
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=<Desafio360.>" \
   -p 1433:1433 --name sql1 --hostname sql1 \
   -d \
   mcr.microsoft.com/mssql/server:2022-latest
```
- verificar que el contener este corriendo.
```
docker ps -a
```

## Backend
- Node V22.12.0 LTS 
- npm  V10.9.0

**Packaghe.json**
se inserto la opcion para importar los module "type:module"

**install Module**
- [Express](https://www.npmjs.com/package/express) -> Nos proporcionar las routes para la comuniciacion con el servidor.
- mssql -> Modulo para conectarse a SQL SERVE 
-- LINK: https://www.npmjs.com/package/mssql 
- cors -> mildware nos servira para verificar que dispositivos se pueden conectar al servidor
-- LINK: https://www.npmjs.com/package/cors 
- morgan -> 

***Ejecutar el SCRIPT (nombre del script es dev)***
```
npm run dev 
```

```
npx is-my-node-vulnerable
```
## Referencias
#### Realizar el Backend
- [Guia-Backend](https://www.youtube.com/watch?v=VuQAF-44Lo0)
- [Autenticación-JWT](https://www.youtube.com/watch?v=UqnnhAZxRac)
### Correr Docker SQL-SERVER
- [Contener-SQL-SERVER](https://learn.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-ver16&pivots=cs1-bash&tabs=cli)