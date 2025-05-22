Disaster Management App
A cross-platform Flutter application to assist users during disasters by providing safety guidelines, emergency contacts, live news updates, and user location features.

Features
Modern light and dark themes
Safety guidelines for various disasters
Emergency contacts management
Live news updates (RSS feed)
User location and map integration
Persistent settings and preferences
Getting Started
Clone the repository:git clone https://github.com/arunim123/disaster_manegement.git
cd disaster_manegement/disaster_management_app
Install dependencies:
flutter pub get
Run the app:

On an emulator or device:
   flutter run
For web:
  flutter run -d chrome  
Project Structure
      lib/ - Main source code
      models/ - Data models
      providers/ - State management
      screens/ - UI screens
      services/ - Data and API services
      utils/ - Utility functions and constants
      assets/ - Images and other assets (add as needed)
      test/ - Unit and widget tests
Dependencies
      provider
      cupertino_icons
      url_launcher
      geolocator
      shared_preferences
      flutter_map
      latlong2
      webfeed_plus
      http
      sqflite
      path_provider
      path
See pubspec.yaml for full details.

Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

