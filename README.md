# Crisis Assist: Disaster Management App

A comprehensive Flutter-based disaster management and emergency assistance application built specifically with an India focus (supporting NDMA guidelines).

## Key Features

*   **🚨 One-Tap SOS**: Instantly sends your location and an emergency message via SMS to default (112) or customized primary contacts.
*   **🤖 AI Disaster Assistant**: A Gemini-powered AI chatbot that provides immediate, calm, and actionable advice based on NDMA safety guidelines.
*   **✨ AI News Summarizer**: Extracts the most recent disaster-related news feeds and uses Gemini AI to give you a 2-3 sentence summary of the current threat level, helping you avoid panic and quickly get facts.
*   **🎒 Emergency Go-Bag Checklist**: An offline-first, interactive checklist that tracks your progress in packing an emergency survival kit.
*   **🔦 Visual SOS**: A distress signaling tool that rapidly flashes your device screen bright red and white to attract rescue workers in low-visibility environments.
*   **📍 Community Safe Zones Map**: A map interface displaying your current location alongside potential safe zones and user-reported hazards.
*   **📖 Offline Safety Guidelines**: Built-in instructions and protocols for responding to earthquakes, floods, and other emergencies without an internet connection.

## Getting Started

1. Clone the repository.
2. Install Flutter dependencies: `flutter pub get`
3. **Important Configuration**: Open `lib/services/ai_service.dart` and insert your Gemini API Key in the `_apiKey` variable to enable the AI Chatbot and AI News Summarizer.
4. Run the app: `flutter run`

## Built With
- Flutter
- Google Generative AI (Gemini 1.5 Flash)
- Geolocator
- Webfeed Plus
- Shared Preferences
