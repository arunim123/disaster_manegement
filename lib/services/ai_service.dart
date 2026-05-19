import 'package:google_generative_ai/google_generative_ai.dart';

class AiService {
  // IMPORTANT: For a production app, never hardcode API keys. 
  // Fetch them from a secure backend or use environment variables.
  // We're leaving this as a placeholder for the user to insert their key.
  static const String _apiKey = 'AIzaSyBNtJbrIfGNlpu6LyKDpJiOnh-xWhznxXQ';
  static final _model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: _apiKey,
  );

  static Future<String> getEmergencyAdvice(String prompt) async {
    if (_apiKey == 'YOUR_GEMINI_API_KEY_HERE' || _apiKey.isEmpty) {
      return 'API Key not configured. Please add your Gemini API Key in lib/services/ai_service.dart to use this feature.';
    }

    try {
      final fullPrompt = "System: You are a highly capable AI assistant embedded in an India-focused Disaster Management application called Crisis Assist. Your role is to provide calm, accurate, and concise advice based on the National Disaster Management Authority (NDMA) guidelines of India. Users might be in a state of panic or emergency. Keep your answers short, actionable, and formatted clearly with bullet points. If someone reports an immediate life-threatening situation (e.g., trapped, injured), advise them to trigger the app's SOS button or contact 112 immediately, before providing further instruction.\n\nUser: $prompt";
      final response = await _model.generateContent([Content.text(fullPrompt)]);
      return response.text ?? 'I could not generate a response. Please check safety guidelines or call 112 if it is an emergency.';
    } catch (e) {
      return 'Error connecting to the AI service: $e. Please rely on the offline safety guidelines.';
    }
  }

  static Future<String> summarizeNews(List<String> newsItems) async {
    if (_apiKey == 'YOUR_GEMINI_API_KEY_HERE') {
      return 'API Key not configured. Please add your Gemini API Key in lib/services/ai_service.dart to use this feature.';
    }

    final prompt = 'Please summarize the following disaster news headlines and descriptions into a short, 2-3 sentence actionable summary for a civilian. Focus only on the most critical threats.\\n\\n${newsItems.join('\\n')}';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Could not generate summary.';
    } catch (e) {
      return 'Error connecting to the AI service: $e.';
    }
  }
}
