import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // For kIsWeb

class PicoclawChatService {
  // Base URLs for different platforms - assuming PicoClaw runs on port 11434 (emulating Ollama) or 8080. 
  // Change to 8080 if PicoClaw is configured for 8080.
  static const String _androidBaseUrl = 'http://10.0.2.2:11434/api/chat';
  static const String _webBaseUrl = 'http://localhost:11434/api/chat';

  // The 'Knowledge Base' for the AI - acts as training data via System Prompt
  static const String systemPrompt = """
You are 'PicoClaw', the highly efficient customer support bot for the WorthIt app.

FACTS:
- App Name: WorthIt
- Service: Hyperlocal delivery from nearby Market, Medical, and General stores.
- Payment Methods: UPI, Credit/Debit Cards, Cash on Delivery (COD).
- Refunds: Processed in 5-7 business days.
- Tracking: Available in the 'Order Tracking' screen.
- Contact: support@worthit.com

RULES:
1. Answer ONLY what is asked. Do not add extra information or "matter".
2. NO greetings ("Hello", "Hi") and NO sign-offs.
3. Be EXTREMELY concise.
4. If asked about live order status, say: "Check 'Order Tracking' screen."
5. If you don't know, say: "Email support@worthit.com."
""";

  // Chat history to maintain context
  List<Map<String, String>> _history = [
    {"role": "system", "content": systemPrompt}
  ];

  /// reset chat history
  void clearHistory() {
    _history = [
      {"role": "system", "content": systemPrompt}
    ];
  }

  Future<String> sendMessage(String message) async {
    // Add user message to history
    _history.add({"role": "user", "content": message});

    try {
      // Determine the correct URL based on the platform
      // standard Android emulator uses 10.0.2.2 to access host localhost
      final String baseUrl = kIsWeb ? _webBaseUrl : _androidBaseUrl;
      final Uri url = Uri.parse(baseUrl);

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          // Add 'Authorization: Bearer <API_KEY>' here if your PicoClaw endpoint requires auth
        },
        body: jsonEncode({
          "model": "picoclaw", // Uses the generic picoclaw identifier
          "messages": _history,
          "stream": false, // Non-streaming for simpler implementation
          "options": {
            "temperature": 0.0, // Strict, deterministic
            "num_predict": 50, // Hard limit on response length to ensure brevity
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Handle both Ollama-style and standard OpenAI-style responses
        String botResponse = "";
        if (data["message"] != null && data["message"]["content"] != null) {
          botResponse = data["message"]["content"];
        } else if (data["choices"] != null && data["choices"].isNotEmpty) {
          botResponse = data["choices"][0]["message"]["content"];
        } else {
           return "Error parsing response from PicoClaw.";
        }

        // Add assistant response to history
        _history.add({"role": "assistant", "content": botResponse});

        return botResponse;
      } else {
        return "Error: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      return "Connection Error: Could not connect to PicoClaw at 10.0.2.2 (Android) or localhost (Web). Ensure the PicoClaw backend server is running.";
    }
  }
}
