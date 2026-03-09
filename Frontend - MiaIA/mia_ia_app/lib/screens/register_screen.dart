import 'package:flutter/material.dart';
import 'main_chat.dart'; 
import 'login_screen.dart'; 
import 'package:mia_ia_app/services/auth_service.dart'; 

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController emailController = TextEditingController(); 
  final TextEditingController passwordController = TextEditingController();
  

  bool _isTermsAccepted = false;
  bool _isLoading = false; 
  bool _obscurePassword = true; 

  // Colores consistentes con tu UI
  final Color backgroundColor = const Color(0xFFEBF5FF);
  final Color primaryBlue = const Color(0xFF5B9EE1);
  final Color darkText = const Color(0xFF1E4E8C);
  final Color borderBlue = const Color.fromRGBO(94, 164, 255, 1);
  @override
  void dispose() {
    nombreController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_isTermsAccepted) {
      _showSnackBar('Debes aceptar los términos para continuar.', isError: true);
      return;
    }
    
    if (nombreController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      _showSnackBar('Todos los campos son obligatorios.', isError: true);
      return;
    }

    setState(() { _isLoading = true; });

    final result = await AuthService.registerClient(
      nombreController.text.trim(),
      "", 
      emailController.text.trim(),
      "No especificado", 
      passwordController.text.trim(),
    );

    if (!mounted) return;
    setState(() { _isLoading = false; });

    if (result['success']) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainChatScreen()),
      );
    } else {
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
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: darkText, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 80), 
                      
                      // --- TÍTULO ---
                      Text(
                        'Mia',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: darkText,
                        ),
                      ),
                      const Text(
                        'Mi IA, Mi apoyo',
                        style: TextStyle(fontSize: 14, color: Colors.black45),
                      ),
                      
                      const SizedBox(height: 20),

                      // --- ICONO PERFIL ---
                      Icon(
                        Icons.account_circle_rounded,
                        size: 85,
                        color: primaryBlue.withOpacity(0.5),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Crear nueva cuenta',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: darkText),
                      ),
                      
                      const SizedBox(height: 25),

                      // --- FORMULARIO ---
                      _buildTextField(
                        controller: nombreController, 
                        hintText: 'Nombre',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: emailController,
                        hintText: 'Correo electrónico',
                        icon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: passwordController,
                        hintText: 'Contraseña',
                        isPassword: true,
                        icon: Icons.lock_outline,
                        obscureText: _obscurePassword,
                        onSuffixIconPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),

                      const SizedBox(height: 15),

                      // --- TÉRMINOS Y CONDICIONES ---
                      Row(
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: _isTermsAccepted,
                              activeColor: primaryBlue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              onChanged: (bool? value) {
                                setState(() => _isTermsAccepted = value ?? false);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _isTermsAccepted = !_isTermsAccepted),
                              child: Text(
                                'Acepto los términos y condiciones de Mia.',
                                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // --- BOTÓN PRINCIPAL ---
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20, width: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Text(
                                  'REGISTRARSE',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                        ),
                      ),

                      const SizedBox(height: 25), 

                      // --- DIVISOR "O" ---
                      Row(
                        children: [
                          Expanded(child: Divider(color: darkText.withOpacity(0.1), indent: 30)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text('o', style: TextStyle(color: darkText.withOpacity(0.2))),
                          ),
                          Expanded(child: Divider(color: darkText.withOpacity(0.1), endIndent: 30)),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // --- FOOTER / LOGIN ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("¿Ya tienes cuenta? ", style: TextStyle(color: Colors.black54)),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                            },
                            child: Text(
                              "Inicia sesión",
                              style: TextStyle(color: darkText, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // --- WIDGET REUTILIZABLE PARA CAMPOS DE TEXTO ---
 // --- WIDGET CON EL BORDE ACTUALIZADO ---
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
    bool obscureText = false,
    IconData? icon,
    VoidCallback? onSuffixIconPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        // Aquí aplicamos el azul claro (borderBlue)
        border: Border.all(color: borderBlue, width: 1.5), 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? obscureText : false,
        style: const TextStyle(color: Colors.black87, fontSize: 15),
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: primaryBlue, size: 20) : null,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                  onPressed: onSuffixIconPressed,
                )
              : null,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: InputBorder.none,
        ),
      ),
    );
  }
}