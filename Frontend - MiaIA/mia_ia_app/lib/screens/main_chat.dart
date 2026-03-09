import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:mia_ia_app/services/auth_service.dart';

class MainChatScreen extends StatefulWidget {
  const MainChatScreen({super.key});

  @override
  State<MainChatScreen> createState() => _MainChatScreenState();
}

class _MainChatScreenState extends State<MainChatScreen> {
  // --- COLORES (ACTUALIZADOS A LA PALETA) ---
  final Color accentBlue = const Color(0xFF6BAED6); // Azul suave
  final Color bgLightBlue = const Color(0xFFE8F2FA); // Azul claro
  final Color textWarmGray = const Color(0xFF6B7280); // Gris cálido
  final Color textBlack = const Color(
    0xFF1D1D1D,
  ); // Mantenemos para contraste fuerte

  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // NECESARIO PARA ABRIR EL MENU LATERAL
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // --- Iniciamos con la lista VACÍA ---
  List<Map<String, dynamic>> messages = [];

  bool _isTyping = false;

  // --- LOGICA ---
  Future<void> _sendMessage() async {
    if (_textController.text.isNotEmpty) {
      String userMessage = _textController.text;
      String userName = AuthService.nombreUsuarioLogueado ?? "Invitado";

      setState(() {
        messages.add({"isUser": true, "text": userMessage});
        _isTyping = true;
        _textController.clear();
      });

      _scrollToBottom();

      try {
        // Tiempo de espera simulado (3 segundos)
        await Future.delayed(const Duration(seconds: 3));

        final url = Uri.parse(
          'https://plastometric-pourable-gloria.ngrok-free.dev/webhook/chat',
        );

        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"message": userMessage,
                            "usuario": userName,}),
        );

        if (response.statusCode == 200) {
          String aiReply = "";
          try {
            final data = jsonDecode(response.body);
            aiReply = data.toString();
          } catch (e) {
            aiReply = response.body;
          }

          if (mounted) {
            setState(() {
              _isTyping = false;
              messages.add({"isUser": false, "text": aiReply});
            });
            _scrollToBottom();
          }
        } else {
          _handleError();
        }
      } catch (e) {
        _handleError();
      }
    }
  }

  void _handleError() {
    if (mounted) {
      setState(() {
        _isTyping = false;
        messages.add({
          "isUser": false,
          "text": "MIA no está disponible en este momento.",
        });
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Asignamos la llave al Scaffold
      drawer: _buildDrawer(), // Aquí cargamos el menú lateral
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            // Usamos la nueva paleta para el fondo
            colors: [bgLightBlue, Colors.white],
            stops: const [0.0, 0.4],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // --- CABECERA ---
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // CAMBIO: Flecha cambiada por Menú (3 líneas)
                    _buildCircleBtn(
                      Icons.menu,
                      () => _scaffoldKey.currentState?.openDrawer(),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: bgLightBlue, // Usando paleta
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Mia AI ",
                            style: TextStyle(
                              color: accentBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Icon(Icons.auto_awesome, size: 16, color: accentBlue),
                        ],
                      ),
                    ),
                    _buildCircleBtn(Icons.more_horiz, () {}),
                  ],
                ),
              ),

              // --- CONTENIDO CENTRAL ---
              Expanded(
                child: messages.isEmpty
                    ? _buildWelcomeScreen()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        itemCount: messages.length + (_isTyping ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (_isTyping && index == messages.length) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.only(
                                  bottom: 16,
                                  right: 50,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(24),
                                    bottomLeft: Radius.circular(24),
                                    bottomRight: Radius.circular(24),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const TypingIndicator(),
                              ),
                            );
                          }
                          final msg = messages[index];
                          return msg['isUser']
                              ? _buildUserMessage(msg['text'])
                              : _buildBotMessage(msg['text']);
                        },
                      ),
              ),

              // --- INPUT ---
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 20,
                  top: 10,
                ),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(Icons.add, color: textWarmGray),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        height: 55,
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
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _textController,
                                onSubmitted: (_) => _sendMessage(),
                                decoration: InputDecoration(
                                  hintText: "Escribe un mensaje...",
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    color: textWarmGray.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: _sendMessage,
                              child: Icon(Icons.send, color: accentBlue),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- NUEVO: BARRA LATERAL (DRAWER) ---
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Botón Nuevo Chat
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: bgLightBlue,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: Icon(Icons.add_comment_rounded, color: accentBlue),
                  title: Text(
                    "Nuevo Chat",
                    style: TextStyle(
                      color: accentBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    // Lógica para limpiar chat
                    setState(() {
                      messages.clear();
                    });
                    Navigator.pop(context); // Cerrar drawer
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Sección Chats Anteriores
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Chats anteriores",
                style: TextStyle(
                  color: textWarmGray,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Ejemplos visuales
            ListTile(
              leading: Icon(Icons.chat_bubble_outline, color: textWarmGray),
              title: Text(
                "Idea para regalo...",
                style: TextStyle(color: textBlack),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.chat_bubble_outline, color: textWarmGray),
              title: Text(
                "Resumen de texto",
                style: TextStyle(color: textBlack),
              ),
              onTap: () {},
            ),

            // Empujamos lo siguiente al fondo
            const Spacer(),

            Divider(color: bgLightBlue),
            // Sección Comunidad
            ListTile(
              leading: Icon(Icons.groups_rounded, color: accentBlue),
              title: Text(
                "Comunidad",
                style: TextStyle(
                  color: accentBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              onTap: () {},
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- WIDGET PANTALLA DE BIENVENIDA (ACTUALIZADO COLORES) ---
  Widget _buildWelcomeScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [accentBlue, const Color(0xFF90CAF9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const Icon(
                Icons.auto_awesome,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [accentBlue, const Color(0xFF90CAF9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const Text(
                "Hola, estoy aquí contigo",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "¿Qué te gustaría contarme hoy?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: textWarmGray, // Actualizado
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---
  Widget _buildCircleBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: textWarmGray, size: 22),
      ),
    );
  }

  Widget _buildUserMessage(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, left: 50),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: accentBlue, // Usa el nuevo azul suave
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: accentBlue.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildBotMessage(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, right: 50),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(24),
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(color: textBlack, fontSize: 16, height: 1.4),
        ),
      ),
    );
  }
}

// --- WIDGET DE PUNTITOS (ANIMACIÓN) ---
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_buildDot(0), _buildDot(1), _buildDot(2)],
      ),
    );
  }

  Widget _buildDot(int index) {
    double delay = index * 0.2;
    return FadeTransition(
      opacity:
          TweenSequence([
            TweenSequenceItem(tween: Tween(begin: 0.4, end: 1.0), weight: 50),
            TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.4), weight: 50),
          ]).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval(delay, delay + 0.6, curve: Curves.easeInOut),
            ),
          ),
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Color(0xFF6B7280), // Gris cálido
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
