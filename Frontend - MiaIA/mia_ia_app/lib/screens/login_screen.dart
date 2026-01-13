import 'package:flutter/material.dart';
import 'main_chat.dart'; // Importamos el chat para navegar al entrar

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definimos los mismos colores para mantener consistencia
    const Color backgroundColor = Color(0xFFEBF5FF);
    const Color primaryBlue = Color(0xFF5B9EE1);
    const Color darkText = Color(0xFF1E4E8C);

    // Controladores para capturar el texto (aunque no los usemos aun con backend)
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: backgroundColor,
      // AppBar transparente y sencillo solo para tener la flecha de "Atrás"
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: darkText),
          onPressed: () => Navigator.pop(context), // Volver a la bienvenida
        ),
      ),
      // SingleChildScrollView es VITAL para que el teclado no tape los inputs
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. CABECERA (Logo y Texto)
              const Text(
                'Mia AI',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                  fontFamily: 'Roboto',
                ),
              ),
              const Text(
                'Mi IA, Mi apoyo',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),

              const SizedBox(height: 20),

              // 2. IMAGEN
              Image.asset(
                'assets/images/welcome_illustration.png',
                height: 150, // Un poco más pequeña que en la bienvenida
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 30),

              // 3. TÍTULO "INICIAR SESIÓN"
              const Text(
                'INICIAR SESIÓN',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 20),

              // 4. INPUT: CORREO ELECTRÓNICO
              _buildTextField(
                controller: emailController,
                hintText: 'Correo Electrónico',
                primaryColor: primaryBlue,
              ),

              const SizedBox(height: 15),

              // 5. INPUT: CONTRASEÑA
              _buildTextField(
                controller: passwordController,
                hintText: 'Contraseña',
                primaryColor: primaryBlue,
                isPassword: true, // Para que salgan puntitos ****
              ),

              const SizedBox(height: 30),

              // 6. BOTÓN GRANDE
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // AQUÍ IRÍA LA LÓGICA DE LOGIN
                    // Por ahora, simulamos éxito y vamos al chat
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainChatScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'INICIAR SESIÓN',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 7. SEPARADOR CON "o"
              Row(
                children: const [
                  Expanded(child: Divider(color: Colors.black26)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('o', style: TextStyle(color: Colors.black54)),
                  ),
                  Expanded(child: Divider(color: Colors.black26)),
                ],
              ),

              const SizedBox(height: 10),

              // 8. TEXTO CREAR NUEVA CUENTA
              TextButton(
                onPressed: () {
                  // TODO: Navegar a RegisterScreen
                  print("Ir a crear cuenta");
                },
                child: const Text(
                  'Crear nueva cuenta',
                  style: TextStyle(
                    color: Colors.black54, // Color gris suave
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 20), // Espacio final
            ],
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para no repetir código en los inputs
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required Color primaryColor,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400]),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ), // Borde invisible por defecto
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: primaryColor,
              width: 1.5,
            ), // Borde azul cuando está quieto
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: primaryColor,
              width: 2,
            ), // Borde más grueso al escribir
          ),
        ),
      ),
    );
  }
}
