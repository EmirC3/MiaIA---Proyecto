import 'package:flutter/material.dart';
import 'main_chat.dart'; // Para navegar al chat si el registro es exitoso
import 'login_screen.dart'; // Para volver al login
import 'package:mia_ia_app/services/auth_service.dart'; // <--- IMPORTANTE: Importa tu servicio aquí

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // 1. Controladores
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // 2. Variables de Estado
  String? _selectedGender;
  bool _isTermsAccepted = false;
  bool _isLoading = false; // <--- NUEVO: Para controlar la carga

  // Lista de opciones para el género
  final List<String> _genderOptions = ['Masculino', 'Femenino'];

  // Paleta de colores
  final Color backgroundColor = const Color(0xFFEBF5FF);
  final Color primaryBlue = const Color(0xFF5B9EE1);
  final Color darkText = const Color(0xFF1E4E8C);
  final Color inputBorderColor = const Color(0xFF5B9EE1);

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    usuarioController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // --- LÓGICA DE REGISTRO ---
  Future<void> _handleRegister() async {
    // 1. Validaciones básicas
    if (!_isTermsAccepted) {
      _showSnackBar(
        'Debes aceptar los términos para continuar.',
        isError: true,
      );
      return;
    }
    if (_selectedGender == null) {
      _showSnackBar('Por favor selecciona tu género.', isError: true);
      return;
    }
    if (nombreController.text.isEmpty ||
        apellidoController.text.isEmpty ||
        usuarioController.text.isEmpty ||
        passwordController.text.isEmpty) {
      _showSnackBar('Todos los campos son obligatorios.', isError: true);
      return;
    }

    // 2. Activar estado de carga
    setState(() {
      _isLoading = true;
    });

    // 3. Llamada al AuthService
    final result = await AuthService.registerClient(
      nombreController.text.trim(),
      apellidoController.text.trim(),
      usuarioController.text.trim(),
      _selectedGender!,
      passwordController.text.trim(),
    );

    // 4. Desactivar carga (si el widget sigue montado)
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });

    // 5. Procesar respuesta
    if (result['success']) {
      // Éxito: Navegar al Chat
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainChatScreen()),
      );
    } else {
      // Error: Mostrar mensaje del backend
      _showSnackBar(result['message'] ?? 'Error al registrarse', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : primaryBlue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      // AppBar simple
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
              // --- CABECERA ---
              Text(
                'Mia AI',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
              const Text(
                'Mi IA, Mi apoyo',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),

              Icon(
                Icons.account_circle_rounded,
                size: 80,
                color: primaryBlue.withOpacity(0.6),
              ),

              const SizedBox(height: 10),

              Text(
                'Crear nueva cuenta',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
              const SizedBox(height: 25),

              // --- CAMPOS DE TEXTO ---
              _buildTextField(controller: nombreController, hintText: 'Nombre'),
              const SizedBox(height: 15),
              _buildTextField(
                controller: apellidoController,
                hintText: 'Apellido',
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: usuarioController,
                hintText: 'Nombre de usuario',
              ),
              const SizedBox(height: 15),

              // --- SELECTOR DE GÉNERO ---
              _buildGenderDropdown(),

              const SizedBox(height: 15),
              _buildTextField(
                controller: passwordController,
                hintText: 'Crear contraseña',
                isPassword: true,
              ),

              const SizedBox(height: 20),

              // --- CHECKBOX TÉRMINOS ---
              Row(
                children: [
                  Checkbox(
                    value: _isTermsAccepted,
                    activeColor: primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onChanged: (bool? value) {
                      setState(() {
                        _isTermsAccepted = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isTermsAccepted = !_isTermsAccepted;
                        });
                      },
                      child: Text(
                        'Acepto los términos y condiciones y entiendo que Mia es una IA de apoyo.',
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // --- BOTÓN CREAR CUENTA ---
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    disabledBackgroundColor: primaryBlue.withOpacity(0.6),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'CREAR CUENTA',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // --- DIVIDER "o" ---
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

              // --- FOOTER IR A LOGIN ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "¿Ya tienes cuenta? ",
                    style: TextStyle(color: Colors.black54),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Iniciar sesión",
                      style: TextStyle(
                        color: darkText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // WIDGETS AUXILIARES
  // ==========================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: inputBorderColor, width: 1.5),
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
            vertical: 18,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: inputBorderColor, width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedGender,
          hint: Text("Genero", style: TextStyle(color: Colors.grey[400])),
          icon: Icon(Icons.arrow_drop_down, color: primaryBlue),
          isExpanded: true,
          borderRadius: BorderRadius.circular(20),
          items: _genderOptions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(color: Colors.black87)),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedGender = newValue;
            });
          },
        ),
      ),
    );
  }
}
