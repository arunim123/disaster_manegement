# 🚨 Disaster Management App

A cross-platform Flutter application designed to assist users during disasters by providing essential safety guidelines, emergency contacts, live news updates, and location-based features.

## ✨ Features

- 🌓 **Modern UI/UX** - Light and dark theme support
- 📋 **Safety Guidelines** - Comprehensive disaster preparedness information
- 📞 **Emergency Contacts** - Quick access to critical contact information
- 📰 **Live News Updates** - Real-time disaster news via RSS feeds
- 📍 **Location Services** - GPS integration with interactive maps
- ⚙️ **Persistent Settings** - User preferences saved locally

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator (for iOS development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/arunim123/disaster_manegement.git
   cd disaster_manegement/disaster_management_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   
   **On mobile (Android/iOS):**
   ```bash
   flutter run
   ```
   
   **On web:**
   ```bash
   flutter run -d chrome
   ```

## 📁 Project Structure

```
lib/
├── models/          # Data models and entities
├── providers/       # State management (Provider pattern)
├── screens/         # UI screens and pages
├── services/        # API services and data handling
├── utils/           # Utility functions and constants
└── main.dart        # Application entry point

assets/              # Images, icons, and static resources
test/                # Unit and widget tests
```

## 📦 Dependencies

### Core Dependencies
- **provider** - State management
- **cupertino_icons** - iOS-style icons
- **url_launcher** - Launch URLs and make calls
- **geolocator** - Location services
- **shared_preferences** - Local data persistence

### Map & Location
- **flutter_map** - Interactive maps
- **latlong2** - Latitude/longitude calculations

### Network & Data
- **webfeed_plus** - RSS feed parsing
- **http** - HTTP requests
- **sqflite** - SQLite database
- **path_provider** - File system paths
- **path** - Path manipulation utilities

For complete dependency information, see [`pubspec.yaml`](pubspec.yaml).

## 🛠️ Development

### Running Tests
```bash
flutter test
```

### Building for Production

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

For major changes, please open an issue first to discuss your proposed changes.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

If you encounter any issues or have questions, please [open an issue](https://github.com/arunim123/disaster_manegement/issues) on GitHub.

---

**Built with ❤️ using Flutter**
