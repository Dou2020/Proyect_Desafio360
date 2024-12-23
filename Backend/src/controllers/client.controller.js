import { getConnection } from './../db/connection.js';
import sql from "mssql"

export const insertClient = async (req, res)=>{
    const {razonSocial, nombreComercial, direccionEntrega, telefonoCliente, email, password} = req.body;

    try {
        //conexion con la base de datos
        const pool = await getConnection()
        const request = pool.request()

        // variables de entrada para el procediento almacenado
        request.input('razon_social', sql.NVarChar, razonSocial);
        request.input('nombre_comercial',sql.NVarChar, nombreComercial);
        request.input('direccion_entrega',sql.NVarChar, direccionEntrega);
        request.input('telefono_cliente', sql.NVarChar,telefonoCliente);

        // Procedimiento almacenado
        await request.execute('InsertarClienteUsuario', async(err, result)=>{
            if (err) {
                console.log(err);
            } else {
                // salida de los usuarios
                console.log(result.recordset);
            }
            
        });

    } catch (error) {
        console.log(error);
    }
}

export const updateUsuario = async (req,res) => {

}

export const updateClient = async (req,res) => {
    
}