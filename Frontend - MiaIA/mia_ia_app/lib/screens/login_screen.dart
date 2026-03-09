import 'package:flutter/material.dart';
import 'main_chat.dart'; 
import 'package:mia_ia_app/services/auth_service.dart'; 
import 'register_screen.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true; 

  final Color backgroundColor = const Color(0xFFEBF5FF);
  final Color primaryBlue = const Color(0xFF5B9EE1);
  final Color darkText = const Color(0xFF1E4E8C);
  // Color para el contorno sutil de los campos
  final Color borderBlue = const Color.fromRGBO(94, 164, 255, 1);

  void _handleLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showSnackBar('Por favor, llena todos los campos', isError: true);
      return;
    }
    setState(() => _isLoading = true);
    final result = await AuthService.loginUser(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result['success']) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainChatScreen()),
      );
    } else {
      _showSnackBar(result['message'] ?? 'Error al iniciar sesión', isError: true);
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
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 90), 
                
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
                  style: TextStyle(fontSize: 14, color: Colors.black45, fontWeight: FontWeight.w500),
                ),
                
                const SizedBox(height: 30),

                Image.asset(
                  'assets/images/welcome_illustration.png',
                  height: 170, 
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.vpn_key_outlined, 
                    size: 80, 
                    color: primaryBlue.withOpacity(0.4)
                  ),
                ),

                const SizedBox(height: 40),

                _buildTextField(
                  controller: emailController,
                  hintText: 'Usuario',
                  primaryColor: primaryBlue,
                  icon: Icons.person_outline,
                ),

                const SizedBox(height: 18),

                _buildTextField(
                  controller: passwordController,
                  hintText: 'Contraseña',
                  primaryColor: primaryBlue,
                  isPassword: true,
                  obscureText: _obscurePassword,
                  icon: Icons.lock_outline,
                  onSuffixIconPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),

                const SizedBox(height: 35),

                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.65, 
                  height: 52, 
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text(
                            'INICIAR SESIÓN',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                  ),
                ),

                const SizedBox(height: 40), // Espacio controlado antes del divisor

                // --- SECCIÓN INFERIOR SUBIDA ---
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Divider(color: darkText.withOpacity(0.1), indent: 40)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text('o', style: TextStyle(color: darkText.withOpacity(0.2))),
                        ),
                        Expanded(child: Divider(color: darkText.withOpacity(0.1), endIndent: 40)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("¿No tienes cuenta? ", style: TextStyle(color: Colors.black54)),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RegisterScreen()),
                            );
                          },
                          child: Text(
                            "Regístrate",
                            style: TextStyle(color: darkText, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40), // Margen final
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required Color primaryColor,
    bool isPassword = false,
    bool obscureText = false,
    IconData? icon,
    VoidCallback? onSuffixIconPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        // Aplicamos el azulito bajo en el contorno
        border: Border.all(color: borderBlue, width: 1.5), 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? obscureText : false,
        style: const TextStyle(color: Colors.black87, fontSize: 15),
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: primaryColor, size: 20) : null,
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