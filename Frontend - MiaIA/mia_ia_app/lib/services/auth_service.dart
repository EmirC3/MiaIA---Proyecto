import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // IP ESPECIAL para Emulador Android (10.0.2.2).
  // Si usas celular físico, cambia esto por tu IP local (ej. 192.168.1.15)
  static const String baseUrl =
      'https://brittany-pasquilic-adria.ngrok-free.dev/api';

  // ==========================================================
  //                      ZONA DE CLIENTES
  // ==========================================================

  // --- LOGIN CLIENTE ---
  static Future<Map<String, dynamic>> loginUser(
    String username,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/login/user');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nombreuser': username, 'contraseña': password}),
      );

      return _processResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  // --- REGISTRO CLIENTE ---
  static Future<Map<String, dynamic>> registerClient(
    String nombre,
    String apellido,
    String username,
    String genero,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/register/user');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': nombre,
          'apellido': apellido,
          'nombreuser': username,
          'genero': genero,
          'contraseña': password,
        }),
      );

      return _processResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  // --- Helper para procesar respuestas ---
  static Map<String, dynamic> _processResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'data': data,
          'message': data['message'] ?? 'Éxito',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Error desconocido',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al leer respuesta del servidor',
      };
    }
  }
}
