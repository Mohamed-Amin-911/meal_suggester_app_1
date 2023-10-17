// api_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String apiKey = "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";
  final String endpoint = "https://api.openai.com/v1/chat/completions";
  final List<Map<String, String>> messages = [];

  Future<String> suggestMeal(String ingredients) async {
    String suggestedMeal = 'loading...';

    messages.add({
      'role': 'user',
      'content': 'Create a recipe from these ingredients: \n$ingredients',
    });
    try {
      // Prepare the request headers
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      };

      // Prepare the request body
      Map<String, dynamic> requestBody = {
        "model": "gpt-3.5-turbo",
        "messages": messages,
        // "max_tokens": 250,
        "temperature": 0,
        "top_p": 1,
      };

      // Make the API call
      final response = await http.post(
        Uri.parse(endpoint),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      // Handle the response
      if (response.statusCode == 200) {
        // Parse the response

        // Extract and return the suggested meal
        suggestedMeal =
            jsonDecode(response.body)['choices'][0]['message']['content'];
        suggestedMeal = suggestedMeal.trim();

        messages.add({
          'role': 'assistant',
          'content': suggestedMeal,
        });
        return suggestedMeal;
      } else {
        // Handle errors
        throw Exception(
            'API Call Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Handle exceptions
      throw Exception('Failed to get meal suggestion: $e');
    }
  }
}
