import 'package:flutter/material.dart';
import 'package:disaster_management_app/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:disaster_management_app/providers/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      title: 'Crisis Assist',
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
  
  ThemeData _buildLightTheme() {
    return ThemeData(
      // Base colors
      primaryColor: Colors.deepOrange,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepOrange,
        primary: Colors.deepOrange,
        secondary: Colors.deepPurple,
        tertiary: Colors.pink,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      
      // Typography
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 57.0, fontWeight: FontWeight.bold, color: Colors.white),
        displayMedium: TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold, color: Colors.white),
        displaySmall: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.white),
        headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),
        headlineMedium: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.white),
        headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600, color: Colors.white),
        titleLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, color: Colors.white),
        titleMedium: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.white),
        titleSmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.white),
        bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.white),
        bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.white),
        bodySmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.white),
        labelLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
        labelMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.white),
        labelSmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      
      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          elevation: 5,
        ),
      ),
      
      // Card theme
      cardTheme: CardTheme(
        elevation: 5.0,
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.deepOrange, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        labelStyle: TextStyle(color: Colors.deepOrange.shade700),
      ),
      
      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.deepPurple,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
      
      // Slider theme
      sliderTheme: SliderThemeData(
        activeTrackColor: Colors.deepOrange,
        thumbColor: Colors.deepOrange,
        overlayColor: Colors.deepOrange.withOpacity(0.3),
        valueIndicatorColor: Colors.deepPurple,
      ),
      
      // Color for scaffold backgrounds
      scaffoldBackgroundColor: Colors.amber.shade50,
    );
  }
  
  ThemeData _buildDarkTheme() {
    return ThemeData(
      // Base colors
      primaryColor: Colors.deepPurple,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        primary: Colors.deepPurple,
        secondary: Colors.deepOrange,
        tertiary: Colors.pink.shade700,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      
      // Typography (inheriting from light theme, just adapted for dark mode)
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 57.0, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
        bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
        bodySmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
        labelLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        labelMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
        labelSmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
      ),
      
      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          elevation: 5,
        ),
      ),
      
      // Card theme
      cardTheme: CardTheme(
        elevation: 5.0,
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Colors.grey.shade900,
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.deepOrange, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade800,
        labelStyle: const TextStyle(color: Colors.white70),
      ),
      
      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
      
      // Slider theme
      sliderTheme: SliderThemeData(
        activeTrackColor: Colors.deepPurple,
        thumbColor: Colors.deepPurple,
        overlayColor: Colors.deepPurple.withOpacity(0.3),
        valueIndicatorColor: Colors.deepOrange,
      ),
      
      // Color for scaffold backgrounds - dark background
      scaffoldBackgroundColor: Colors.black,
    );
  }
}
