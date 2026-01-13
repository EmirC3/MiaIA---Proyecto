import 'package:flutter/material.dart';
import 'main_chat.dart'; // Tu pantalla de chat
import 'package:mia_ia_app/services/auth_service.dart'; // Asegúrate de importar tu servicio de autenticación
import 'register_screen.dart'; // Importamos la pantalla de registro (la crearemos si no existe)

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. Controladores
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // 2. Variable de estado para la carga
  bool _isLoading = false;

  // 3. Colores (los mismos de tu diseño)
  final Color backgroundColor = const Color(0xFFEBF5FF);
  final Color primaryBlue = const Color(0xFF5B9EE1);
  final Color darkText = const Color(0xFF1E4E8C);

  // 4. Función para manejar el Login
  void _handleLogin() async {
    // Validar campos vacíos
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, llena todos los campos')),
      );
      return;
    }

    // Activar el "cargando"
    setState(() {
      _isLoading = true;
    });

    // Llamar al servicio (API)
    final result = await AuthService.loginUser(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    // Desactivar el "cargando"
    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      // ÉXITO: Navegar al chat
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainChatScreen()),
      );
    } else {
      // ERROR: Mostrar mensaje del servidor
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Error al iniciar sesión'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      // AppBar transparente
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: darkText),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. CABECERA
              Text(
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
                height: 150,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 30),

              // 3. TÍTULO
              Text(
                'INICIAR SESIÓN',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 20),

              // 4. INPUT: CORREO
              _buildTextField(
                controller: emailController,
                hintText: 'Correo Electrónico',
                primaryColor: primaryBlue,
                icon: Icons.email_outlined,
              ),

              const SizedBox(height: 15),

              // 5. INPUT: CONTRASEÑA
              _buildTextField(
                controller: passwordController,
                hintText: 'Contraseña',
                primaryColor: primaryBlue,
                isPassword: true,
                icon: Icons.lock_outline,
              ),

              const SizedBox(height: 30),

              // 6. BOTÓN CON LÓGICA DE CARGA
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : _handleLogin, // Desactiva si carga
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    disabledBackgroundColor: primaryBlue.withOpacity(0.6),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
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

              // 7. SEPARADOR
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

              // 8. IR A REGISTRO
              TextButton(
                onPressed: () {
                  // Navegar a la pantalla de registro
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Crear nueva cuenta',
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Widget auxiliar mejorado con icono opcional
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required Color primaryColor,
    bool isPassword = false,
    IconData? icon,
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
          prefixIcon: icon != null ? Icon(icon, color: Colors.grey[400]) : null,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400]),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: primaryColor.withOpacity(0.5),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
        ),
      ),
    );
  }
}
