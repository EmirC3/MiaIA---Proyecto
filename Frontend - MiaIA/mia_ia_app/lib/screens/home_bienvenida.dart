import 'package:flutter/material.dart';
import 'package:mia_ia_app/screens/login_screen.dart';
import 'package:mia_ia_app/screens/register_screen.dart';

class HomeBienvenida extends StatelessWidget {
  const HomeBienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFEBF5FF);
    const Color primaryBlue = Color(0xFF5B9EE1);
    const Color darkText = Color(0xFF1E4E8C);
    const Color secondaryText = Color(0xFF5A7DAE);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        // Eliminamos el Scroll para que la pantalla sea fija
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribuye el contenido
            children: [
              // CABECERA
              Column(
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Mia',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: darkText,
                      letterSpacing: -0.5,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const Text(
                    'Mi IA, Mi apoyo',
                    style: TextStyle(
                      fontSize: 17,
                      color: secondaryText,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),

              // ILUSTRACIÓN (Ajustada para no empujar los botones)
              Expanded(
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 180),
                    child: Image.asset(
                      'assets/images/welcome_illustration.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // TARJETAS DE INFORMACIÓN (Iconos unificados a darkText)
              Column(
                children: [
                  const InfoCard(
                    icon: Icons.hearing,
                    title: 'Escucha incondicional',
                    subtitle: 'Desahógate sin miedo a juicios',
                    primaryColor: darkText, // Unificado
                  ),
                  const SizedBox(height: 12),
                  const InfoCard(
                    icon: Icons.nightlight_round,
                    title: 'Disponible 24/7',
                    subtitle: 'Mia siempre está aquí para ti',
                    primaryColor: darkText, // Unificado
                  ),
                  const SizedBox(height: 12),
                  const InfoCard(
                    icon: Icons.lock_rounded,
                    title: '100% Privado',
                    subtitle: 'Lo que dices aquí, se queda aquí',
                    primaryColor: darkText, // Unificado
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // BOTONES LADO A LADO
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: primaryBlue, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'INICIAR SESIÓN',
                          style: TextStyle(
                            color: darkText,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        ),
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
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 26),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF1E4E8C),
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
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