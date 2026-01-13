import 'package:flutter/material.dart';
import 'main_chat.dart'; // Para navegar al chat si el registro es exitoso
import 'login_screen.dart'; // Para volver al login

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // 1. Controladores para todos los campos de texto
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // 2. Variables de Estado para Género y Términos
  String? _selectedGender; // Puede ser nulo al principio
  bool _isTermsAccepted = false;

  // Lista de opciones para el género
  final List<String> _genderOptions = ['Masculino', 'Femenino'];

  // Paleta de colores consistentes
  final Color backgroundColor = const Color(0xFFEBF5FF);
  final Color primaryBlue = const Color(0xFF5B9EE1);
  final Color darkText = const Color(0xFF1E4E8C);
  final Color inputBorderColor = const Color(
    0xFF5B9EE1,
  ); // Color del borde de los inputs

  @override
  void dispose() {
    // Limpiamos los controladores cuando se cierra la pantalla
    nombreController.dispose();
    apellidoController.dispose();
    usuarioController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      // AppBar simple para la flecha de retroceso
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

              // Ícono de avatar (Usamos uno nativo similar al de la imagen)
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

              // --- CAMPOS DE TEXTO (Según tu imagen) ---

              // 1. Nombre
              _buildTextField(controller: nombreController, hintText: 'Nombre'),
              const SizedBox(height: 15),

              // 2. Apellido
              _buildTextField(
                controller: apellidoController,
                hintText: 'Apellido',
              ),
              const SizedBox(height: 15),

              // 3. Nombre de usuario
              _buildTextField(
                controller: usuarioController,
                hintText: 'Nombre de usuario',
              ),
              const SizedBox(height: 15),

              // --- CAMPO ESPECIAL: SELECTOR DE GÉNERO ---
              _buildGenderDropdown(),

              const SizedBox(height: 15),

              // 5. Contraseña
              _buildTextField(
                controller: passwordController,
                hintText: 'Crear contraseña',
                isPassword: true,
              ),

              const SizedBox(height: 20),

              // --- CHECKBOX DE TÉRMINOS ---
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
                  onPressed: () {
                    // Validación simple
                    if (!_isTermsAccepted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Debes aceptar los términos para continuar.',
                          ),
                        ),
                      );
                      return;
                    }
                    if (_selectedGender == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor selecciona tu género.'),
                        ),
                      );
                      return;
                    }

                    // TODO: Aquí iría la llamada a tu Backend para registrar
                    print(
                      "Registrando: ${usuarioController.text}, Género: $_selectedGender",
                    );

                    // Simulación de éxito: ir al chat
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
              const SizedBox(height: 40), // Espacio extra al final
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // WIDGETS AUXILIARES PARA EL DISEÑO
  // ==========================================

  // 1. Constructor para los campos de texto normales (Estilo de tu imagen)
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: inputBorderColor,
          width: 1.5,
        ), // Borde azul visible siempre
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
          border: InputBorder.none, // Quitamos el borde default del input
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    );
  }

  // 2. Constructor ESPECIAL para el Dropdown de Género
  Widget _buildGenderDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: inputBorderColor,
          width: 1.5,
        ), // Mismo borde azul
      ),
      // DropdownButtonHideUnderline oculta la línea fea que trae el dropdown por defecto
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedGender,
          hint: Text("Genero", style: TextStyle(color: Colors.grey[400])),
          icon: Icon(
            Icons.arrow_drop_down,
            color: primaryBlue,
          ), // Ícono de flechita azul
          isExpanded: true, // Para que ocupe todo el ancho
          borderRadius: BorderRadius.circular(
            20,
          ), // Bordes redondeados al abrir el menú
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
