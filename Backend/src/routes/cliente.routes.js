import { Router } from 'express';
//controlador de las routes
import { insertClient, updateClient, updateUsuario } from './../controllers/client.controller.js';

const router = Router();
// routes
router.post('/insert/client', insertClient);

router.put('/update/client', updateClient);
router.put('/update/usuario', updateUsuario);

export default router;