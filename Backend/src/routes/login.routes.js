import { Router } from 'express';
import { getautentication } from './../controllers/login.controller.js';

const router = Router()

router.post('/login', getautentication )

export default router;