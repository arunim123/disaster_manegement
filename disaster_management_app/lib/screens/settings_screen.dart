import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:disaster_management_app/providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _emergencyNumber = '100';
  String _userName = 'User';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _emergencyNumber = prefs.getString('primary_sos_number') ?? '100';
      _userName = prefs.getString('user_name') ?? 'User';
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    await prefs.setString('primary_sos_number', _emergencyNumber);
    await prefs.setString('user_name', _userName);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    // Safely access theme after build context is ready
    return Builder(
      builder: (BuildContext context) {
        final brightness = Theme.of(context).brightness;
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
          ),
          body: _isLoading 
            ? const Center(child: CircularProgressIndicator())
            : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: brightness == Brightness.light
                      ? [Colors.deepOrange.shade300, Colors.amber.shade100]
                      : [Colors.deepPurple.shade800, Colors.black],
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    // Profile Section
                    Card(
                      margin: const EdgeInsets.only(bottom: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Profile Information',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              initialValue: _userName,
                              decoration: const InputDecoration(
                                labelText: 'Your Name',
                                prefixIcon: Icon(Icons.person),
                              ),
                              onChanged: (value) {
                                _userName = value;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Emergency Settings
                    Card(
                      margin: const EdgeInsets.only(bottom: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Emergency Settings',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              initialValue: _emergencyNumber,
                              decoration: const InputDecoration(
                                labelText: 'Primary Emergency Number',
                                prefixIcon: Icon(Icons.phone),
                                hintText: 'e.g., 100, 911',
                              ),
                              keyboardType: TextInputType.phone,
                              onChanged: (value) {
                                _emergencyNumber = value;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Appearance Settings
                    Card(
                      margin: const EdgeInsets.only(bottom: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Appearance',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SwitchListTile(
                              title: const Text('Dark Mode'),
                              subtitle: const Text('Use dark theme throughout the app'),
                              secondary: Icon(
                                themeProvider.isDarkMode 
                                    ? Icons.dark_mode 
                                    : Icons.light_mode,
                                color: themeProvider.isDarkMode 
                                    ? Colors.indigo 
                                    : Colors.amber,
                              ),
                              value: themeProvider.isDarkMode,
                              activeColor: Colors.deepPurple,
                              onChanged: (bool value) {
                                themeProvider.setDarkMode(value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Notification Settings
                    Card(
                      margin: const EdgeInsets.only(bottom: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Notification Settings',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SwitchListTile(
                              title: const Text('Enable Notifications'),
                              subtitle: const Text('Receive alerts about emergencies in your area'),
                              value: _notificationsEnabled,
                              activeColor: Colors.deepOrange,
                              onChanged: (bool value) {
                                setState(() {
                                  _notificationsEnabled = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // About Section
                    Card(
                      margin: const EdgeInsets.only(bottom: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'About',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const ListTile(
                              leading: Icon(Icons.info),
                              title: Text('App Version'),
                              subtitle: Text('1.0.0'),
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Icons.privacy_tip),
                              title: const Text('Privacy Policy'),
                              onTap: () {
                                // Open Privacy Policy
                              },
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Icons.help),
                              title: const Text('Help & Support'),
                              onTap: () {
                                // Open Help
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Save Button
                    ElevatedButton(
                      onPressed: _saveSettings,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text('Save Settings'),
                    ),
                  ],
                ),
              ),
        );
      }
    );
  }
} 