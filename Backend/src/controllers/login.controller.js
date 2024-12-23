import { getConnection } from './../db/connection.js';
import sql from "mssql"

export const getautentication = async (req,res) =>{

    // Value: user and password
    const { email, password } = req.body;
    
    try {
        const pool = await getConnection()
        const request = pool.request()
        // variables de entrada para el procedimiento almacenado
        await request.input('correo', sql.NVarChar, email);
        await request.input('password',sql.NVarChar, password);

        // Procedimiento almacenado autenticacion
        await request.execute('autenticacion', async (err, result) => {
            // salida de los usuarios
            console.log(result.recordset);
        })
        
        
        res.send({email: email, password: password})
    } catch (error) {
        console.log(error);
    }
}