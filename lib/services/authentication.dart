import "dart:convert";
import "package:http/http.dart" as http;

class Authentication {
  final String baseUrl="https://bikaneza-backend.onrender.com/api";

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Handle successful login
      return true;
    } else {
      // Handle error
      return false;
    }
  }
  Future<bool> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      // Handle successful registration
      return true;
    } else {
      // Handle error
      return false;
    }
  }
}