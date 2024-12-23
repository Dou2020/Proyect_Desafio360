import bcrypt from "bcrypt";

// Función para encriptar la contraseña
export async function encriptarContrasena(contrasena) {
  const saltRounds = 10;  // Número de rondas para generar el "salt"
  const hashedPassword = await bcrypt.hash(contrasena, saltRounds);
  return hashedPassword;
}
