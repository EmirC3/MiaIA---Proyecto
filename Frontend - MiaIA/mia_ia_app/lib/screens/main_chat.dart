import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // <--- Importante para conectar
import 'dart:convert'; // <--- Importante para entender el JSON

class MainChatScreen extends StatefulWidget {
  const MainChatScreen({super.key});

  @override
  State<MainChatScreen> createState() => _MainChatScreenState();
}

class _MainChatScreenState extends State<MainChatScreen> {
  // Colores
  final Color mainBlue = const Color(0xFF5B9EE1);
  final Color bgBlue = const Color(0xFFEBF5FF);
  final Color textGray = const Color(0xFF4A4A4A);

  // Controlador
  final TextEditingController _textController = TextEditingController();

  // Lista de mensajes
  List<Map<String, dynamic>> messages = [
    //{"isUser": true, "text": "¿Qué tal el ojo?"},
    {"isUser": false, "text": "¡Holiii, Como te sientes Hoy?!"},
    //{"isUser": true, "text": "¿Qué tal el día de hoy?"},
    //{"isUser": false, "text": "¡Muy bien! ¿En qué puedo ayudarte hoy?"},
  ];

  // --- FUNCIÓN CONECTADA A N8N ---
  Future<void> _sendMessage() async {
    if (_textController.text.isNotEmpty) {
      String userMessage = _textController.text;

      setState(() {
        // 1. Mostrar mensaje del usuario inmediatamente
        messages.add({"isUser": true, "text": userMessage});
        _textController.clear();
      });

      try {
        // 2. URL Especial para Emulador Android (apunta a tu PC localhost)
        // Asegúrate de que n8n esté mostrando "Waiting for Webhook call..."
        final url = Uri.parse('https://plastometric-pourable-gloria.ngrok-free.dev/webhook/chat');

        // 3. Enviar a n8n
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "message": userMessage, // La llave que lee tu n8n
          }),
        );

        // 4. Procesar respuesta
        if (response.statusCode == 200) {
          // Intentamos decodificar. Si n8n devuelve texto plano o JSON.
          String aiReply = "";
          try {
            final data = jsonDecode(response.body);
            // Si tu n8n devuelve { "text": "..." } usa data['text']
            // Si devuelve solo el texto limpio en el body, usa data.toString()
            aiReply = data.toString();
            // TIP: Si en n8n ves que llega como JSON complejo, ajusta aquí.
          } catch (e) {
            // Si no es JSON, tomamos el texto tal cual
            aiReply = response.body;
          }

          if (mounted) {
            setState(() {
              messages.add({"isUser": false, "text": aiReply});
            });
          }
        } else {
          print("Error del servidor: ${response.statusCode}");
        }
      } catch (e) {
        print("Error de conexión: $e");
        if (mounted) {
          setState(() {
            messages.add({
              "isUser": false,
              "text": "MIA no está disponible en este momento (Revisa n8n).",
            });
          });
        }
      }
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

            // --- ILUSTRACIÓN CENTRAL ---
            SizedBox(
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Nube decorativa (sin cambios)
                  Positioned(
                    left: 40,
                    top: 10,
                    child: Icon(Icons.cloud, color: Colors.white, size: 35),
                  ),
                  // Burbuja de chat decorativa (sin cambios)
                  Positioned(
                    right: 50,
                    bottom: 20,
                    child: Icon(
                      Icons.chat_bubble,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  // --- TU IMAGEN CENTRAL ---
                  Container(
                    // Reduje un poco el padding para que la imagen se vea más grande
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // Mantenemos el fondo azul suave
                      color: mainBlue.withOpacity(0.2),
                    ),
                    child: Image.asset(
                      'assets/agent.png', // Asegúrate de que el nombre coincida
                      height: 70, // Ajusta este tamaño según lo necesites
                      width: 70,
                      fit: BoxFit.contain,
                    ),
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
                    // LISTA DE MENSAJES
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
                                controller: _textController,
                                decoration: const InputDecoration(
                                  hintText: "Escribe tu mensaje...",
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: _sendMessage,
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

  // WIDGETS AUXILIARES (Sin cambios, solo copiados para completar el archivo)
  Widget _buildUserMessage(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0, left: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
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
                crossAxisAlignment: CrossAxisAlignment.end,
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

  Widget _buildBotMessage(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0, right: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.blue[100],
            child: Icon(Icons.support_agent, size: 20, color: color),
          ),
          const SizedBox(width: 8),
          Flexible(
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
