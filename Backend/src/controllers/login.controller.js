import { getConnection } from './../db/connection.js';
import sql from "mssql"

export const getautentication = async (req,res) =>{

    // value: user and password
    const { email, password } = req.body;
    
    try {
        const pool = await getConnection()
        const request = pool.request()
        await request.input('correo', sql.NVarChar, email);
        await request.input('password',sql.NVarChar, password);
        //await request.output('usuario_rol',sql.Int)
        //await request.output('mensaje', sql.NVarChar)
        await request.execute('autenticacion', async (err, result) => {

            //console.log(err);
            //await console.log(result.returnValue);
            console.log(result.recordset);
        })
        
        
        res.send({email: email, password: password})
    } catch (error) {
        console.log(error);
    }
}