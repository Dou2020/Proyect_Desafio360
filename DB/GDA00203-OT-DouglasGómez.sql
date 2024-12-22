-- Active: 1734408453252@@127.0.0.1@1433@GDA00203OTDouglasGomez
-- Crea la base de datos
CREATE DATABASE GDA00203OTDouglasGomez;

-- Tabla Estados
CREATE TABLE estados (
    id INT IDENTITY PRIMARY KEY,
    nombre VARCHAR(45) NOT NULL
);

INSERT INTO estados (nombre) VALUES 
('Activo'), 
('Inactivo'), 
('Pendiente');


-- Tabla Rol
CREATE TABLE rol (
    id INT IDENTITY PRIMARY KEY,
    nombre VARCHAR(45) NOT NULL
);

INSERT INTO rol (nombre) VALUES 
('Cliente'), 
('Operador');


-- Tabla Clientes
CREATE TABLE Clientes (
    id INT IDENTITY PRIMARY KEY,
    razon_social VARCHAR(245) NOT NULL,
    nombre_comercial VARCHAR(245),
    direccion_entrega VARCHAR(255),
    telefono VARCHAR(15),
    email VARCHAR(100) UNIQUE
);

INSERT INTO Clientes (razon_social, nombre_comercial, direccion_entrega, telefono, email) VALUES
('Empresa XYZ', 'Comercial XYZ', 'Calle Principal 123', '123456789', 'contacto@xyz.com'),
('Tienda ABC', 'ABC Store', 'Avenida Secundaria 456', '987654321', 'ventas@abc.com'),
('Corporación DEF', 'DEF Corp', 'Carretera 789', '112233445', 'info@def.com');


-- Tabla Usuarios
CREATE TABLE usuarios (
    id INT IDENTITY PRIMARY KEY,
    rol_id INT NOT NULL,
    estados_id INT NOT NULL,
    Clientes_id INT NULL,
    correo_electronico VARCHAR(100) NOT NULL UNIQUE,
    nombre_completo VARCHAR(100),
    password VARCHAR(255) NOT NULL,
    telefono VARCHAR(15),
    fecha_nacimiento DATE,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (rol_id) REFERENCES rol(id),
    FOREIGN KEY (estados_id) REFERENCES estados(id),
    FOREIGN KEY (Clientes_id) REFERENCES Clientes(id) ON DELETE SET NULL
);

INSERT INTO usuarios (rol_id, estados_id, Clientes_id, correo_electronico, nombre_completo, password, telefono, fecha_nacimiento) VALUES
(1, 1, 1, 'cliente1@xyz.com', 'Administrador General', '1234', '5551234567', '1980-01-01'),
(1, 1, 1, 'cliente2@xyz.com', 'Juan Pérez', '1234', '5559876543', '1990-05-20'),
(2, 1, NULL, 'operador1@xyz.com', 'Ana López', '1234', '5555678910', '1985-08-15');

-- SELECT Usuarios
SELECT a.password, a.correo_electronico, b.nombre, c.nombre 
    FROM usuarios a 
    JOIN rol b 
    ON a.rol_id = b.id 
    JOIN estados c 
    ON c.id = a.estados_id;

SELECT a.password, a.correo_electronico, b.nombre
    FROM usuarios a 
    JOIN rol b 
    ON a.rol_id = b.id 
    WHERE a.estados_id = 1;


-- Tabla CategoriaProductos
CREATE TABLE CategoriaProductos (
    idCategoriaProductos INT IDENTITY PRIMARY KEY,
    usuarios_idusuarios INT NOT NULL,
    estados_idestados INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuarios_idusuarios) REFERENCES usuarios(idusuarios),
    FOREIGN KEY (estados_idestados) REFERENCES estados(idestados)
);

-- Tabla Productos
CREATE TABLE Productos (
    idProductos INT IDENTITY PRIMARY KEY,
    CategoriaProductos_idCategoriaProductos INT NOT NULL,
    usuarios_idusuarios INT NOT NULL,
    estados_idestados INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    marca VARCHAR(45),
    codigo VARCHAR(45) UNIQUE,
    stock FLOAT DEFAULT 0 CHECK (stock >= 0),
    precio FLOAT NOT NULL CHECK (precio >= 0),
    foto VARBINARY(MAX),
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CategoriaProductos_idCategoriaProductos) REFERENCES CategoriaProductos(idCategoriaProductos),
    FOREIGN KEY (usuarios_idusuarios) REFERENCES usuarios(idusuarios),
    FOREIGN KEY (estados_idestados) REFERENCES estados(idestados)
);


-- Tabla Orden
CREATE TABLE Orden (
    idOrden INT IDENTITY PRIMARY KEY,
    usuarios_idusuarios INT NOT NULL,
    estados_idestados INT NOT NULL,
    nombre_completo VARCHAR(100) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    telefono VARCHAR(15),
    correo_electronico VARCHAR(100),
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_entrega DATE,
    total_orden FLOAT NOT NULL CHECK (total_orden >= 0),
    FOREIGN KEY (usuarios_idusuarios) REFERENCES usuarios(idusuarios),
    FOREIGN KEY (estados_idestados) REFERENCES estados(idestados)
);

-- Tabla OrdenDetalles
CREATE TABLE OrdenDetalles (
    idOrdenDetalles INT IDENTITY PRIMARY KEY,
    Orden_idOrden INT NOT NULL,
    Productos_idProductos INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio FLOAT NOT NULL CHECK (precio >= 0),
    subtotal FLOAT NOT NULL CHECK (subtotal >= 0),
    FOREIGN KEY (Orden_idOrden) REFERENCES Orden(idOrden),
    FOREIGN KEY (Productos_idProductos) REFERENCES Productos(idProductos)
);

-- Procedimientos almacenados --

-- ===============================
-- Procedimientos para Insertar
-- ===============================

-- Login de Usuario
CREATE PROCEDURE Autenticacion
    @correo VARCHAR(100),
    @password VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    -- Variable para almacenar el rol del usuario
    DECLARE @usuario_rol INT;

    BEGIN TRY
        -- Buscar el rol del usuario si las credenciales son válidas y el estado es activo
        SELECT @usuario_rol = rol_id
        FROM usuarios 
        WHERE correo_electronico = @correo 
            AND password = @password
            AND estados_id = 1;
        
        -- Validar si se encontró el usuario
        IF @usuario_rol IS NOT NULL
        BEGIN
            -- Devolver el rol del usuario
            SELECT 
                'Autenticación exitosa' AS mensaje,
                @usuario_rol AS usuario_rol;
        END
        ELSE
        BEGIN
            -- Generar un error si las credenciales no son válidas
            RAISERROR('Credenciales inválidas.', 16, 1);
        END
    END TRY
    BEGIN CATCH
        -- Manejo de errores inesperados
        SELECT 
            ERROR_MESSAGE() AS error_mensaje,
            ERROR_SEVERITY() AS severidad,
            ERROR_STATE() AS estado;
    END CATCH
END;
-- VALIDAR EL PROCEDIMIENTO autenticacion;
EXEC autenticacion  'cliente1@xyz.com', '1234';;

    SELECT rol_id
    FROM usuarios 
    WHERE estados_id = 1;

-- Insertar en estados
CREATE PROCEDURE InsertarEstado
    @nombre VARCHAR(45)
AS
BEGIN
    INSERT INTO estados (nombre)
    VALUES (@nombre);
END;

-- Insertar en rol
CREATE PROCEDURE InsertarRol
    @nombre VARCHAR(45)
AS
BEGIN
    INSERT INTO rol (nombre)
    VALUES (@nombre);
END;

-- Insertar en Clientes
CREATE PROCEDURE InsertarCliente
    @razon_social VARCHAR(245),
    @nombre_comercial VARCHAR(245),
    @direccion_entrega VARCHAR(255),
    @telefono VARCHAR(15),
    @email VARCHAR(100)
AS
BEGIN
    INSERT INTO Clientes (razon_social, nombre_comercial, direccion_entrega, telefono, email)
    VALUES (@razon_social, @nombre_comercial, @direccion_entrega, @telefono, @email);
END;

-- Insertar en usuarios
CREATE PROCEDURE InsertarUsuario
    @rol_idrol INT,
    @estados_idestados INT,
    @Clientes_idClientes INT = NULL,
    @correo_electronico VARCHAR(100),
    @nombre_completo VARCHAR(100),
    @password VARCHAR(255),
    @telefono VARCHAR(15),
    @fecha_nacimiento DATE
AS
BEGIN
    INSERT INTO usuarios (rol_idrol, estados_idestados, Clientes_idClientes, correo_electronico, nombre_completo, password, telefono, fecha_nacimiento)
    VALUES (@rol_idrol, @estados_idestados, @Clientes_idClientes, @correo_electronico, @nombre_completo, @password, @telefono, @fecha_nacimiento);
END;

-- Insertar en CategoriaProductos
CREATE PROCEDURE InsertarCategoriaProducto
    @usuarios_idusuarios INT,
    @estados_idestados INT,
    @nombre VARCHAR(100)
AS
BEGIN
    INSERT INTO CategoriaProductos (usuarios_idusuarios, estados_idestados, nombre)
    VALUES (@usuarios_idusuarios, @estados_idestados, @nombre);
END;

-- Insertar en Productos
CREATE PROCEDURE InsertarProducto
    @CategoriaProductos_idCategoriaProductos INT,
    @usuarios_idusuarios INT,
    @estados_idestados INT,
    @nombre VARCHAR(100),
    @marca VARCHAR(45),
    @codigo VARCHAR(45),
    @stock FLOAT,
    @precio FLOAT,
    @foto VARBINARY(MAX)
AS
BEGIN
    INSERT INTO Productos (CategoriaProductos_idCategoriaProductos, usuarios_idusuarios, estados_idestados, nombre, marca, codigo, stock, precio, foto)
    VALUES (@CategoriaProductos_idCategoriaProductos, @usuarios_idusuarios, @estados_idestados, @nombre, @marca, @codigo, @stock, @precio, @foto);
END;

-- Insertar en Orden
CREATE PROCEDURE InsertarOrden
    @usuarios_idusuarios INT,
    @estados_idestados INT,
    @nombre_completo VARCHAR(100),
    @direccion VARCHAR(255),
    @telefono VARCHAR(15),
    @correo_electronico VARCHAR(100),
    @fecha_entrega DATE,
    @total_orden FLOAT
AS
BEGIN
    INSERT INTO Orden (usuarios_idusuarios, estados_idestados, nombre_completo, direccion, telefono, correo_electronico, fecha_entrega, total_orden)
    VALUES (@usuarios_idusuarios, @estados_idestados, @nombre_completo, @direccion, @telefono, @correo_electronico, @fecha_entrega, @total_orden);
END;

-- Insertar en OrdenDetalles
CREATE PROCEDURE InsertarOrdenDetalle
    @Orden_idOrden INT,
    @Productos_idProductos INT,
    @cantidad INT,
    @precio FLOAT,
    @subtotal FLOAT
AS
BEGIN
    INSERT INTO OrdenDetalles (Orden_idOrden, Productos_idProductos, cantidad, precio, subtotal)
    VALUES (@Orden_idOrden, @Productos_idProductos, @cantidad, @precio, @subtotal);
END;

-- ===============================
-- Procedimientos para Actualizar
-- ===============================

-- Actualizar estados
CREATE PROCEDURE ActualizarEstado
    @idestados INT,
    @nombre VARCHAR(45)
AS
BEGIN
    UPDATE estados
    SET nombre = @nombre
    WHERE idestados = @idestados;
END;

-- Actualizar rol
CREATE PROCEDURE ActualizarRol
    @idrol INT,
    @nombre VARCHAR(45)
AS
BEGIN
    UPDATE rol
    SET nombre = @nombre
    WHERE idrol = @idrol;
END;

-- Actualizar Clientes
CREATE PROCEDURE ActualizarCliente
    @idClientes INT,
    @razon_social VARCHAR(245),
    @nombre_comercial VARCHAR(245),
    @direccion_entrega VARCHAR(255),
    @telefono VARCHAR(15),
    @email VARCHAR(100)
AS
BEGIN
    UPDATE Clientes
    SET razon_social = @razon_social,
        nombre_comercial = @nombre_comercial,
        direccion_entrega = @direccion_entrega,
        telefono = @telefono,
        email = @email
    WHERE idClientes = @idClientes;
END;

-- Actualizar usuarios
CREATE PROCEDURE ActualizarUsuario
    @idusuarios INT,
    @rol_idrol INT,
    @estados_idestados INT,
    @Clientes_idClientes INT = NULL,
    @correo_electronico VARCHAR(100),
    @nombre_completo VARCHAR(100),
    @password VARCHAR(255),
    @telefono VARCHAR(15),
    @fecha_nacimiento DATE
AS
BEGIN
    UPDATE usuarios
    SET rol_idrol = @rol_idrol,
        estados_idestados = @estados_idestados,
        Clientes_idClientes = @Clientes_idClientes,
        correo_electronico = @correo_electronico,
        nombre_completo = @nombre_completo,
        password = @password,
        telefono = @telefono,
        fecha_nacimiento = @fecha_nacimiento
    WHERE idusuarios = @idusuarios;
END;

-- Actualizar CategoriaProductos
CREATE PROCEDURE ActualizarCategoriaProducto
    @idCategoriaProductos INT,
    @usuarios_idusuarios INT,
    @estados_idestados INT,
    @nombre VARCHAR(100)
AS
BEGIN
    UPDATE CategoriaProductos
    SET usuarios_idusuarios = @usuarios_idusuarios,
        estados_idestados = @estados_idestados,
        nombre = @nombre
    WHERE idCategoriaProductos = @idCategoriaProductos;
END;

-- Actualizar Productos
CREATE PROCEDURE ActualizarProducto
    @idProductos INT,
    @CategoriaProductos_idCategoriaProductos INT,
    @usuarios_idusuarios INT,
    @estados_idestados INT,
    @nombre VARCHAR(100),
    @marca VARCHAR(45),
    @codigo VARCHAR(45),
    @stock FLOAT,
    @precio FLOAT,
    @foto VARBINARY(MAX)
AS
BEGIN
    UPDATE Productos
    SET CategoriaProductos_idCategoriaProductos = @CategoriaProductos_idCategoriaProductos,
        usuarios_idusuarios = @usuarios_idusuarios,
        estados_idestados = @estados_idestados,
        nombre = @nombre,
        marca = @marca,
        codigo = @codigo,
        stock = @stock,
        precio = @precio,
        foto = @foto
    WHERE idProductos = @idProductos;
END;

-- Actualizar Orden
CREATE PROCEDURE ActualizarOrden
    @idOrden INT,
    @usuarios_idusuarios INT,
    @estados_idestados INT,
    @nombre_completo VARCHAR(100),
    @direccion VARCHAR(255),
    @telefono VARCHAR(15),
    @correo_electronico VARCHAR(100),
    @fecha_entrega DATE,
    @total_orden FLOAT
AS
BEGIN
    UPDATE Orden
    SET usuarios_idusuarios = @usuarios_idusuarios,
        estados_idestados = @estados_idestados,
        nombre_completo = @nombre_completo,
        direccion = @direccion,
        telefono = @telefono,
        correo_electronico = @correo_electronico,
        fecha_entrega = @fecha_entrega,
        total_orden = @total_orden
    WHERE idOrden = @idOrden;
END;

-- Actualizar OrdenDetalles
CREATE PROCEDURE ActualizarOrdenDetalle
    @idOrdenDetalles INT,
    @Orden_idOrden INT,
    @Productos_idProductos INT,
    @cantidad INT,
    @precio FLOAT,
    @subtotal FLOAT
AS
BEGIN
    UPDATE OrdenDetalles
    SET Orden_idOrden = @Orden_idOrden,
        Productos_idProductos = @Productos_idProductos,
        cantidad = @cantidad,
        precio = @precio,
        subtotal = @subtotal
    WHERE idOrdenDetalles = @idOrdenDetalles;
END;

-- ===============================
-- Vista: Usuarios con Roles y Estados
-- ===============================
CREATE VIEW VistaUsuariosConRolesEstados AS
SELECT 
    u.idusuarios,
    u.nombre_completo,
    u.correo_electronico,
    u.telefono,
    u.fecha_nacimiento,
    u.fecha_creacion,
    r.nombre AS rol_nombre,
    e.nombre AS estado_nombre
FROM 
    usuarios u
JOIN 
    rol r ON u.rol_idrol = r.idrol
JOIN 
    estados e ON u.estados_idestados = e.idestados;

-- ===============================
-- Vista: Productos con Categoría y Estado
-- ===============================
CREATE VIEW VistaProductosConCategoriaEstado AS
SELECT 
    p.idProductos,
    p.nombre AS producto_nombre,
    p.marca,
    p.codigo,
    p.stock,
    p.precio,
    cp.nombre AS categoria_nombre,
    e.nombre AS estado_nombre
FROM 
    Productos p
JOIN 
    CategoriaProductos cp ON p.CategoriaProductos_idCategoriaProductos = cp.idCategoriaProductos
JOIN 
    estados e ON p.estados_idestados = e.idestados;

-- ===============================
-- Vista: Órdenes con Detalles
-- ===============================
CREATE VIEW VistaOrdenesConDetalles AS
SELECT 
    o.idOrden,
    o.nombre_completo,
    o.direccion,
    o.telefono,
    o.correo_electronico,
    o.fecha_creacion,
    o.fecha_entrega,
    o.total_orden,
    od.idOrdenDetalles,
    od.cantidad,
    od.precio,
    od.subtotal,
    p.nombre AS producto_nombre,
    p.marca
FROM 
    Orden o
JOIN 
    OrdenDetalles od ON o.idOrden = od.Orden_idOrden
JOIN 
    Productos p ON od.Productos_idProductos = p.idProductos;

-- ===============================
-- Vista: Clientes con Órdenes Asociadas
-- ===============================
CREATE VIEW VistaClientesConOrdenes AS
SELECT 
    c.idClientes,
    c.razon_social,
    c.nombre_comercial,
    c.telefono,
    c.email,
    o.idOrden,
    o.fecha_creacion AS orden_fecha_creacion,
    o.total_orden
FROM 
    Clientes c
LEFT JOIN 
    usuarios u ON c.idClientes = u.Clientes_idClientes
LEFT JOIN 
    Orden o ON u.idusuarios = o.usuarios_idusuarios;

-- ===============================
-- Vista: Categorías con Total de Productos
-- ===============================
CREATE VIEW VistaCategoriasConTotalProductos AS
SELECT 
    cp.idCategoriaProductos,
    cp.nombre AS categoria_nombre,
    COUNT(p.idProductos) AS total_productos
FROM 
    CategoriaProductos cp
LEFT JOIN 
    Productos p ON cp.idCategoriaProductos = p.CategoriaProductos_idCategoriaProductos
GROUP BY 
    cp.idCategoriaProductos, cp.nombre;

-- ===============================
-- Vista: Órdenes con Usuario Responsable y Estado
-- ===============================
CREATE VIEW VistaOrdenesConUsuarioEstado AS
SELECT 
    o.idOrden,
    o.fecha_creacion,
    o.fecha_entrega,
    o.total_orden,
    u.nombre_completo AS usuario_responsable,
    e.nombre AS estado_orden
FROM 
    Orden o
JOIN 
    usuarios u ON o.usuarios_idusuarios = u.idusuarios
JOIN 
    estados e ON o.estados_idestados = e.idestados;

-- ===============================
-- Vista: Productos con Stock Bajo
-- ===============================
CREATE VIEW VistaProductosStockBajo AS
SELECT 
    p.idProductos,
    p.nombre AS producto_nombre,
    p.marca,
    p.stock,
    cp.nombre AS categoria_nombre
FROM 
    Productos p
JOIN 
    CategoriaProductos cp ON p.CategoriaProductos_idCategoriaProductos = cp.idCategoriaProductos
WHERE 
    p.stock < 10;

-- ===============================
-- Vista: Ingresos Totales por Cliente
-- ===============================
CREATE VIEW VistaIngresosPorCliente AS
SELECT 
    c.idClientes,
    c.razon_social,
    c.telefono,
    c.email,
    SUM(o.total_orden) AS total_ingresos
FROM 
    Clientes c
LEFT JOIN 
    usuarios u ON c.idClientes = u.Clientes_idClientes
LEFT JOIN 
    Orden o ON u.idusuarios = o.usuarios_idusuarios
GROUP BY 
    c.idClientes, c.razon_social, c.telefono, c.email;

-- ===============================
-- Vista: Detalles de una Orden
-- ===============================
CREATE VIEW VistaDetallesOrden AS
SELECT 
    o.idOrden,
    o.nombre_completo,
    o.fecha_creacion,
    p.nombre AS producto_nombre,
    od.cantidad,
    od.precio,
    od.subtotal
FROM 
    Orden o
JOIN 
    OrdenDetalles od ON o.idOrden = od.Orden_idOrden
JOIN 
    Productos p ON od.Productos_idProductos = p.idProductos;

-- ===============================
-- Vista: Historial de Estados de Usuarios
-- ===============================
CREATE VIEW VistaHistorialEstadosUsuarios AS
SELECT 
    u.idusuarios,
    u.nombre_completo,
    e.nombre AS estado_actual,
    u.fecha_creacion AS fecha_registro
FROM 
    usuarios u
JOIN 
    estados e ON u.estados_idestados = e.idestados;

-- a. Total de Productos activos que tenga en stock mayor a 0 
CREATE VIEW VistaTotalProductosActivosConStock AS
SELECT 
    COUNT(p.idProductos) AS total_productos_activos
FROM 
    Productos p
JOIN 
    estados e ON p.estados_idestados = e.idestados
WHERE 
    e.nombre = 'Activo' AND p.stock > 0;

-- b Total de Quetzales en ordenes ingresadas en el mes de Agosto 2024
CREATE VIEW VistaTotalOrdenesAgosto2024 AS
SELECT 
    SUM(o.total_orden) AS total_quetzales
FROM 
    Orden o
WHERE 
    YEAR(o.fecha_creacion) = 2024 AND MONTH(o.fecha_creacion) = 8;

-- Top 10 de clientes con mayor consumo de órdenes (histórico)
CREATE VIEW VistaTop10ProductosMasVendidos AS
SELECT TOP 10
    p.idProductos,
    p.nombre AS producto_nombre,
    SUM(od.cantidad) AS total_vendidos
FROM 
    Productos p
JOIN 
    OrdenDetalles od ON p.idProductos = od.Productos_idProductos
GROUP BY 
    p.idProductos, p.nombre
ORDER BY 
    total_vendidos ASC;

-- d. Top 10 de productos más vendidos en orden ascendente

CREATE VIEW VistaTop10ProductosMasVendidos AS
SELECT TOP 10
    p.idProductos,
    p.nombre AS producto_nombre,
    SUM(od.cantidad) AS total_vendidos
FROM 
    Productos p
JOIN 
    OrdenDetalles od ON p.idProductos = od.Productos_idProductos
GROUP BY 
    p.idProductos, p.nombre
ORDER BY 
    total_vendidos ASC;




