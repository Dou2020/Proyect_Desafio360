import cors from "cors";
import express from "express";
import morgan from "morgan";

const app =  express()


app.use(cors());
//app.use(morgan("dev"));
app.use(express.urlencoded({ extended: false }));
app.use(express.json());

// Exportamos la configuracion de express
export default app;