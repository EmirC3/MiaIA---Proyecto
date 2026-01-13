import 'package:flutter/material.dart';
import 'package:mia_ia_app/screens/login_screen.dart';
import 'package:mia_ia_app/screens/register_screen.dart';
import 'main_chat.dart'; // Mantengo la referencia por si quieres probar navegación directa

class HomeBienvenida extends StatelessWidget {
  const HomeBienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    // Definición de la Paleta de Colores
    const Color backgroundColor = Color(0xFFEBF5FF); // Fondo general
    const Color primaryBlue = Color(
      0xFF5B9EE1,
    ); // Azul principal (Botones/Iconos)
    const Color darkText = Color(0xFF1E4E8C); // Azul oscuro para títulos

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // 1. HEADER (Igual que antes)
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
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),

              const SizedBox(height: 30),

              // 2. IMAGEN CENTRAL (Más pequeña como pediste)
              // Asegúrate de que la imagen siga en assets/images/welcome_illustration.png
              SizedBox(
                height: 180, // Reduje la altura para dar espacio a las tarjetas
                child: Image.asset(
                  'assets/images/welcome_illustration.png',
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 30),

              // 3. TARJETAS DE INFORMACIÓN (Aquí usamos el widget personalizado)
              const InfoCard(
                icon: Icons.hearing_rounded,
                title: 'Escucha incondicional',
                subtitle: 'desahógate sin miedo o juicios.',
                primaryColor: primaryBlue,
              ),
              const SizedBox(height: 16), // Espacio entre tarjetas

              const InfoCard(
                icon: Icons.nightlight_round,
                title: 'Disponible 24/7',
                subtitle: '¿Ansiedad a las 3 AM? Mia está aquí.',
                primaryColor: primaryBlue,
              ),
              const SizedBox(height: 16),

              const InfoCard(
                icon: Icons.lock_rounded,
                title: '100% Privado',
                subtitle: 'Lo que dices aquí, se queda aquí.',
                primaryColor: primaryBlue,
              ),

              const Spacer(), // Empuja los botones al final
              // 4. BOTONES DE ACCIÓN (Crear cuenta / Iniciar sesión)
              Row(
                children: [
                  // Botón "Crear cuenta" (Outlined - Borde)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Navegar a pantalla de Registro
                        print("Ir a Registro");

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        side: const BorderSide(color: primaryBlue, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Crear cuenta',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: darkText, // Texto oscuro para contraste
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 15), // Espacio entre botones
                  // Botón "Iniciar sesión" (Filled - Relleno)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Navegar a pantalla de Login
                        print("Ir a Login");

                        // Por ahora te llevo al chat para probar
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Iniciar sesión',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// --- WIDGET PERSONALIZADO PARA LAS TARJETAS ---
// Esto va en el mismo archivo, abajo de la clase principal
class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color primaryColor;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        // Sombra suave para dar efecto de elevación como en la imagen
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ícono circular
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.2), // Fondo azul clarito
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: primaryColor, // Ícono azul fuerte
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          // Textos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.2, // Altura de línea para mejor lectura
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
