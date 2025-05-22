import 'package:flutter/material.dart';
import 'package:disaster_management_app/screens/emergency_contacts_screen.dart';
import 'package:disaster_management_app/screens/user_location_screen.dart';
import 'package:disaster_management_app/screens/news_updates_screen.dart';
import 'package:disaster_management_app/screens/safety_guidelines_screen.dart';
import 'package:disaster_management_app/screens/settings_screen.dart';
import 'package:disaster_management_app/screens/profile_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  @override
  void initState() {
    super.initState();
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  void _navigateToEmergencyContacts(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EmergencyContactsScreen()),
    );
  }

  void _navigateToSafetyGuidelines(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SafetyGuidelinesScreen()),
    );
  }

  Future<void> _activateSOS(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled. Please enable them.')),
        );
      }
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied.')),
          );
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are permanently denied, we cannot request permissions.')),
        );
      }
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    String emergencyNumber = prefs.getString('primary_sos_number') ?? '100';
    bool isDefaultNumber = emergencyNumber == '100';

    const String defaultSOSMessage = 'HELP! I am in an emergency. My current location is: {LOCATION_URL}';
    String sosMessageTemplate = prefs.getString('custom_sos_message') ?? defaultSOSMessage;

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      String locationUrl = 'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';
      String message = sosMessageTemplate.replaceAll('{LOCATION_URL}', locationUrl);

      final Uri smsUri = Uri(
        scheme: 'sms',
        path: emergencyNumber,
        queryParameters: <String, String>{'body': message},
      );

      if (context.mounted && await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
        if (context.mounted && isDefaultNumber) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('SOS sent to default number (100). Consider setting a primary SOS contact in Emergency Contacts.'),
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'SETTINGS',
                onPressed: () => _navigateToEmergencyContacts(context),
              ),
            ),
          );
        }
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch SMS to $emergencyNumber. Please ensure you have a SIM card and SMS capabilities.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get location or send SOS: ${e.toString()}')),
        );
      }
    }
  }

  void _navigateToNewsUpdates(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewsUpdatesScreen()),
    );
  }

  void _navigateToUserLocation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserLocationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Create screens list here, not in initState
    final List<Widget> screens = [
      _buildHomeContent(),
      _buildSOSContent(),
      const UserLocationScreen(),
      const ProfileScreen(),
    ];
    
    return Scaffold(
      appBar: _currentIndex != 3 ? AppBar(
        title: const Text('Disaster Management'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _navigateToSettings(context),
          ),
        ],
      ) : null, // Hide AppBar for Profile screen as it has its own
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          // If SOS tab is tapped
          if (index == 1) {
            _activateSOS(context);
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        backgroundColor: Colors.deepPurple,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            label: 'SOS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    final brightness = Theme.of(context).brightness;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: brightness == Brightness.light
              ? [Colors.deepOrange.shade300, Colors.amber.shade100]
              : [Colors.deepPurple.shade800, Colors.black],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Large SOS Button
            Center(
              child: GestureDetector(
                onTap: () => _activateSOS(context),
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.pink.shade400, Colors.deepPurple.shade400],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_active,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'SOS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Feature Grid 2x2
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.25,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // Emergency Contacts
                  _buildFeatureCard(
                    title: 'Emergency\nContacts',
                    icon: Icons.phone,
                    color: Colors.pink,
                    onTap: () => _navigateToEmergencyContacts(context),
                  ),
                  // Guidelines
                  _buildFeatureCard(
                    title: 'Guidelines',
                    icon: Icons.shield,
                    color: Colors.blue,
                    onTap: () => _navigateToSafetyGuidelines(context),
                  ),
                  // My Location
                  _buildFeatureCard(
                    title: 'My Location',
                    icon: Icons.location_on,
                    color: Colors.amber,
                    onTap: () => _navigateToUserLocation(context),
                  ),
                  // News
                  _buildFeatureCard(
                    title: 'News',
                    icon: Icons.article_outlined,
                    color: Colors.teal,
                    onTap: () => _navigateToNewsUpdates(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSOSContent() {
    final brightness = Theme.of(context).brightness;
    
    // This is a placeholder since we're treating SOS as an action rather than a screen
    // In practice, tapping the SOS tab will trigger the _activateSOS method
    // but we still need a widget in the _screens list
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: brightness == Brightness.light
              ? [Colors.pink.shade400, Colors.deepPurple.shade200]
              : [Colors.pink.shade900, Colors.deepPurple.shade900],
        ),
      ),
      child: const Center(
        child: Text(
          'SOS mode activated',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 42,
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 