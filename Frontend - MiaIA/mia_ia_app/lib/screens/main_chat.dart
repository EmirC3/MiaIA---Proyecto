import 'package:flutter/material.dart';

// Cambiamos a StatefulWidget para poder actualizar el estado (enviar mensajes)
class MainChatScreen extends StatefulWidget {
  const MainChatScreen({super.key});

  @override
  State<MainChatScreen> createState() => _MainChatScreenState();
}

class _MainChatScreenState extends State<MainChatScreen> {
  // Colores (Los defino aquí para usarlos en toda la clase)
  final Color mainBlue = const Color(0xFF5B9EE1);
  final Color bgBlue = const Color(0xFFEBF5FF);
  final Color textGray = const Color(0xFF4A4A4A);

  // Controlador para el campo de texto
  final TextEditingController _textController = TextEditingController();

  // Lista inicial de mensajes
  // 'isUser': true significa que lo escribió el usuario (irá a la derecha)
  // 'isUser': false significa que es la IA (irá a la izquierda)
  List<Map<String, dynamic>> messages = [
    {"isUser": true, "text": "¿Qué tal el ojo?"},
    {"isUser": false, "text": "¡Muy bien, gracias por preguntar!"},
    {"isUser": true, "text": "¿Qué tal el día de hoy?"},
    {"isUser": false, "text": "¡Muy bien! ¿En qué puedo ayudarte hoy?"},
  ];

  // Función para enviar mensaje
  void _sendMessage() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        // Agregamos el mensaje del usuario a la lista
        messages.add({"isUser": true, "text": _textController.text});

        // Simulación: La IA responde algo automáticamente después de 1 segundo (Opcional)
        // Si no quieres esto, borra el Future.delayed
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              messages.add({
                "isUser": false,
                "text": "Entendido, cuéntame más sobre eso.",
              });
            });
          }
        });

        // Limpiamos el campo de texto
        _textController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlue,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // --- CABECERA ---
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.favorite, color: mainBlue, size: 28),
                      const SizedBox(width: 8),
                      Text(
                        'MIA AI',
                        style: TextStyle(
                          color: mainBlue,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?img=5',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '¡Hola, Usuario!',
                        style: TextStyle(color: textGray, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- ILUSTRACIÓN CENTRAL (Reducida) ---
            // Reduje la altura de 180 a 120 para que el chat suba más
            SizedBox(
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 40,
                    top: 10,
                    child: Icon(Icons.cloud, color: Colors.white, size: 35),
                  ),
                  Positioned(
                    right: 50,
                    bottom: 20,
                    child: Icon(
                      Icons.chat_bubble,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(15), // Padding reducido
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: mainBlue.withOpacity(0.2),
                    ),
                    child: Icon(
                      Icons.support_agent,
                      size: 60,
                      color: mainBlue,
                    ), // Icono más pequeño
                  ),
                ],
              ),
            ),

            // --- PANEL DE CHAT ---
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // LISTA DE MENSAJES DINÁMICA
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          if (msg['isUser']) {
                            return _buildUserMessage(msg['text']);
                          } else {
                            return _buildBotMessage(msg['text'], mainBlue);
                          }
                        },
                      ),
                    ),

                    // INPUT DE TEXTO
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: TextField(
                                controller:
                                    _textController, // Conectamos el controlador
                                decoration: const InputDecoration(
                                  hintText: "Escribe tu mensaje...",
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // BOTÓN ENVIAR
                          GestureDetector(
                            onTap: _sendMessage, // Llamamos a la función enviar
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: mainBlue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // BARRA DE NAVEGACIÓN
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey[200]!),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNavItem(
                            Icons.person_outline,
                            "Chat",
                            true,
                            mainBlue,
                          ),
                          _buildNavItem(
                            Icons.access_time,
                            "Actividad",
                            false,
                            Colors.grey,
                          ),
                          _buildNavItem(
                            Icons.list,
                            "Configuración",
                            false,
                            Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // USUARIO: Lado DERECHO (Gris)
  Widget _buildUserMessage(String text) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 15.0,
        left: 50.0,
      ), // Margen izquierdo para que no ocupe toda la pantalla
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end, // Alinea todo a la derecha
        children: [
          Flexible(
            // <--- CAMBIO CLAVE: Usamos Flexible en lugar de Expanded
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment
                    .end, // Alinea el texto a la derecha dentro de la burbuja
                children: [
                  const Text(
                    "Tú",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    text,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // IA: Lado IZQUIERDO (Azul)
  Widget _buildBotMessage(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 15.0,
        right: 50.0,
      ), // Margen derecho para que no llegue al borde
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.start, // Alinea todo a la izquierda
        crossAxisAlignment: CrossAxisAlignment.end, // Alinea el avatar abajo
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.blue[100],
            child: Icon(Icons.support_agent, size: 20, color: color),
          ),
          const SizedBox(width: 8),
          Flexible(
            // <--- CAMBIO CLAVE: Flexible permite que la burbuja se encoja
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "MIA AI:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    text,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isActive,
    Color color,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }
}
