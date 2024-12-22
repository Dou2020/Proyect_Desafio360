import cors from "cors";
import express from "express";
import morgan from "morgan";
import loginRoute from './routes/login.routes.js';

const app =  express()


app.use(cors());
//app.use(morgan("dev"));
app.use(express.urlencoded({ extended: false }));
app.use(express.json());

//Routes
app.use('/api',loginRoute)

// Exportamos la configuracion de express
export default app;