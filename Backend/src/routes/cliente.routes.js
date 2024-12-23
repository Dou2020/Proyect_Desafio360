import { Router } from 'express';
//controlador de las routes
import { insertClient } from './../controllers/client.controller.js';

const router = Router();
// routes
router.post('/insert/client', insertClient);

export default router;