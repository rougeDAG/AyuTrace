import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  // `10.0.2.2` is how the Android emulator connects to the host machine's localhost
  static const String _ollamaUrl = "http://10.0.2.2:11434/api/chat";
  static const String _modelName = "gemma3:1b";

  Future<String?> askAboutProducts({
    required String userQuestion,
    required List<Map<String, dynamic>> products,
    String role = 'customer',
  }) async {
    try {
      final productsData = products
          .map(
            (p) => '''
Product Name: \${p['name']}
Ingredients: \${p['ingredients']}
Benefits: \${p['benefits']}
''',
          )
          .join('\\n---\\n');

      final prompt =
          '''
You are an expert Ayurvedic assistant. Your goal is to provide helpful, informative answers based ONLY on the provided product information. Do not invent facts. If the information is not in the product data, state that clearly.

Role: $role

Product database:
$productsData

User Question: "$userQuestion"

Answer the user directly now:''';

      final response = await http.post(
        Uri.parse(_ollamaUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "model": _modelName,
          "messages": [
            {"role": "user", "content": prompt},
          ],
          "stream": false,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message']['content'];
      } else {
        return "Error from Ollama: \${response.statusCode}";
      }
    } catch (e) {
      if (e.toString().contains('Connection refused')) {
        return "Cannot connect to Ollama. Please ensure Ollama is running on your PC.";
      }
      return "Network Error: $e";
    }
  }
}
