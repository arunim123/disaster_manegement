import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/emergency_contact.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  static const String _userContactsKey = 'user_emergency_contacts';
  static const String _primarySOSNumberKey = 'primary_sos_number';
  static const String _customSOSMessageKey = 'custom_sos_message';
  static const String _defaultSOSMessage = 'HELP! I am in an emergency. My current location is: {LOCATION_URL}';

  final List<EmergencyContact> _predefinedContacts = [
    const EmergencyContact(name: 'Police', phoneNumber: '100'),
    const EmergencyContact(name: 'Ambulance', phoneNumber: '108'),
    const EmergencyContact(name: 'Fire Brigade', phoneNumber: '101'),
    const EmergencyContact(name: 'National Disaster Helpline', phoneNumber: '1075'),
  ];

  List<EmergencyContact> _userContacts = [];
  List<EmergencyContact> _allContacts = [];
  bool _isLoading = true;
  String? _primarySOSNumber;
  String? _customSOSMessage;

  @override
  void initState() {
    super.initState();
    _loadContactsAndSOSSettings();
  }

  Future<void> _loadContactsAndSOSSettings() async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    // Load user contacts
    final String? userContactsJson = prefs.getString(_userContactsKey);
    if (userContactsJson != null) {
      try {
        final List<dynamic> decodedJson = jsonDecode(userContactsJson) as List<dynamic>;
        _userContacts = decodedJson
            .map((jsonItem) => EmergencyContact(
                  name: jsonItem['name'] as String,
                  phoneNumber: jsonItem['phoneNumber'] as String,
                ))
            .toList();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading contacts: ${e.toString()}')),
          );
        }
        _userContacts = [];
      }
    }
    // Load primary SOS number
    _primarySOSNumber = prefs.getString(_primarySOSNumberKey);
    // Load custom SOS message
    _customSOSMessage = prefs.getString(_customSOSMessageKey);
    
    _updateAllContacts();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, String>> userContactsToSave = _userContacts
        .map((contact) => {'name': contact.name, 'phoneNumber': contact.phoneNumber})
        .toList();
    await prefs.setString(_userContactsKey, jsonEncode(userContactsToSave));
    // No need to call _updateAllContacts here as it's called by the calling function or _loadContactsAndSOSNumber
    // However, if _saveContacts is called independently, ensure UI updates if necessary.
     _updateAllContacts(); // Added to ensure consistency if called standalone
  }

  Future<void> _savePrimarySOSNumber(String? number) async {
    final prefs = await SharedPreferences.getInstance();
    if (number == null || number.trim().isEmpty) {
      await prefs.remove(_primarySOSNumberKey);
      setState(() {
        _primarySOSNumber = null;
      });
       if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Primary SOS number cleared.')),
        );
      }
    } else {
      await prefs.setString(_primarySOSNumberKey, number.trim());
      setState(() {
        _primarySOSNumber = number.trim();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Primary SOS number saved: $number')),
        );
      }
    }
  }

  Future<void> _saveCustomSOSMessage(String? message) async {
    final prefs = await SharedPreferences.getInstance();
    if (message == null || message.trim().isEmpty || message.trim() == _defaultSOSMessage) {
      await prefs.remove(_customSOSMessageKey);
      setState(() {
        _customSOSMessage = null; // Cleared or set to default, so store as null
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Custom SOS message cleared (using default).')),
        );
      }
    } else {
      await prefs.setString(_customSOSMessageKey, message.trim());
      setState(() {
        _customSOSMessage = message.trim();
      });
       if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Custom SOS message saved.')),
        );
      }
    }
  }

  Future<void> _showSetPrimarySOSDialog() async {
    final TextEditingController controller = TextEditingController(text: _primarySOSNumber);
    String? newNumber = _primarySOSNumber;

    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Set Primary SOS Number'),
          content: TextFormField(
            controller: controller,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'SOS Phone Number',
              hintText: 'e.g., 911 or a trusted contact',
              icon: Icon(Icons.sos_outlined),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => newNumber = value,
            validator: (value) {
              if (value != null && value.isNotEmpty && !RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$').hasMatch(value.trim())) {
                return 'Please enter a valid phone number';
              }
              return null; // Empty or valid is fine (empty clears)
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                // Manually validate because Form widget is not used here for simplicity
                if (newNumber != null && newNumber!.isNotEmpty && !RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$').hasMatch(newNumber!.trim())) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar( // Show error in dialog context
                     const SnackBar(content: Text('Invalid phone number format.'), backgroundColor: Colors.red),
                  );
                  return;
                }
                _savePrimarySOSNumber(newNumber);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSetCustomSOSMessageDialog() async {
    final TextEditingController controller = TextEditingController(text: _customSOSMessage ?? _defaultSOSMessage);
    String? newMessage = _customSOSMessage ?? _defaultSOSMessage;

    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Set Custom SOS Message'),
          content: TextFormField(
            controller: controller,
            keyboardType: TextInputType.multiline,
            maxLines: null, // Allows multiple lines
            decoration: InputDecoration(
              labelText: 'SOS Message',
              hintText: 'Include {LOCATION_URL} for the map link.',
              helperText: "Example: '''${_defaultSOSMessage}''' (The {LOCATION_URL} part will be replaced with the actual map link when the SOS is triggered.)",
              helperMaxLines: 3,
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) => newMessage = value,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Message cannot be empty. To use default, clear and save.';
              }
              if (!value.contains('{LOCATION_URL}')) {
                return 'Message must contain {LOCATION_URL} placeholder.';
              }
              return null;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Use Default'),
              onPressed: () {
                _saveCustomSOSMessage(null); // Pass null to clear/use default
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                // Basic validation for presence and placeholder
                if (newMessage == null || newMessage!.trim().isEmpty) {
                     ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(content: Text('Message cannot be empty.'), backgroundColor: Colors.red),
                     );
                     return;
                }
                if (!newMessage!.contains('{LOCATION_URL}')) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(content: Text('Message must include {LOCATION_URL}.'), backgroundColor: Colors.red),
                    );
                    return;
                }
                _saveCustomSOSMessage(newMessage);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateAllContacts() {
    // Show predefined first, then user-added, sorted alphabetically
    _userContacts.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    setState(() {
      _allContacts = [..._predefinedContacts, ..._userContacts];
    });
  }

  Future<void> _makePhoneCall(BuildContext context, String phoneNumber, String contactName) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not call $contactName at $phoneNumber')),
        );
      }
    }
  }

  Future<void> _showAddEditContactDialog(BuildContext context, {EmergencyContact? contactToEdit, int? contactIndex}) async {
    final _formKey = GlobalKey<FormState>();
    String name = contactToEdit?.name ?? '';
    String phoneNumber = contactToEdit?.phoneNumber ?? '';
    bool isEditing = contactToEdit != null;

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Contact' : 'Add New Contact'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    initialValue: name,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'e.g., John Doe, Home, Doctor',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    onChanged: (value) => name = value.trim(),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: phoneNumber,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      hintText: 'e.g., 1234567890',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a phone number';
                      }
                      // Basic validation for digits and common characters
                      if (!RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$').hasMatch(value.trim())) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                    onChanged: (value) => phoneNumber = value.trim(),
                    textInputAction: TextInputAction.done,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              child: Text(isEditing ? 'Save Changes' : 'Add Contact'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newContact = EmergencyContact(name: name, phoneNumber: phoneNumber);
                  if (isEditing && contactIndex != null) {
                    // We are editing an existing user contact
                     int userContactIndex = _userContacts.indexWhere((uc) => uc.name == contactToEdit!.name && uc.phoneNumber == contactToEdit.phoneNumber);
                     if (userContactIndex != -1) {
                        setState(() {
                          _userContacts[userContactIndex] = newContact;
                        });
                     }
                  } else {
                    // Adding a new contact
                    setState(() {
                      _userContacts.add(newContact);
                    });
                  }
                  _saveContacts();
                  Navigator.of(dialogContext).pop();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Contact ${isEditing ? "updated" : "added"}: $name')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _addContact(BuildContext context) {
    _showAddEditContactDialog(context);
  }

  void _editContact(BuildContext context, EmergencyContact contact, int listIndex) {
    // Ensure we are editing a user contact, not a predefined one.
    // The listIndex is for _allContacts, we need the index in _userContacts.
    int userContactIndex = _userContacts.indexWhere((uc) => uc.name == contact.name && uc.phoneNumber == contact.phoneNumber);
    if (userContactIndex != -1) {
      _showAddEditContactDialog(context, contactToEdit: contact, contactIndex: userContactIndex);
    } else {
       if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Predefined contacts cannot be edited.')),
        );
      }
    }
  }

  void _deleteContact(BuildContext context, EmergencyContact contact, int listIndex) {
    // Cannot delete predefined contacts.
    int userContactIndex = _userContacts.indexWhere((uc) => uc.name == contact.name && uc.phoneNumber == contact.phoneNumber);
    if (userContactIndex == -1) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Predefined contacts cannot be deleted.')),
        );
      }
      return;
    }

    showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Contact'),
          content: Text('Are you sure you want to delete ${contact.name}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
            ),
          ],
        );
      },
    ).then((confirmed) {
      if (confirmed == true) {
        setState(() {
          _userContacts.removeAt(userContactIndex);
        });
        _saveContacts();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${contact.name} deleted.')),
          );
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts & SOS'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
                    elevation: 2,
                    child: ListTile(
                      leading: Icon(Icons.sos_sharp, color: Colors.red[700], size: 30),
                      title: const Text('Primary SOS Number', style: TextStyle(fontWeight: FontWeight.w500)),
                      subtitle: Text(_primarySOSNumber ?? 'Not set (Defaults to 100)'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit_note_outlined, color: Colors.blueAccent),
                        onPressed: _showSetPrimarySOSDialog,
                        tooltip: 'Set Primary SOS Number',
                      ),
                      onTap: _showSetPrimarySOSDialog,
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 8.0),
                    elevation: 2,
                    child: ListTile(
                      leading: Icon(Icons.message_outlined, color: Colors.blue[700], size: 30),
                      title: const Text('Custom SOS Message', style: TextStyle(fontWeight: FontWeight.w500)),
                      subtitle: Text(_customSOSMessage ?? _defaultSOSMessage, style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis,),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent),
                        onPressed: _showSetCustomSOSMessageDialog,
                        tooltip: 'Set Custom SOS Message',
                      ),
                      onTap: _showSetCustomSOSMessageDialog,
                    ),
                  ),
                  const Divider(height: 1),
                  // If _allContacts is empty, show a message, otherwise show the ListView.
                  _allContacts.isEmpty 
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                          child: Text(
                            'No user-defined contacts. Tap + to add personal contacts.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(8.0),
                          itemCount: _allContacts.length,
                          itemBuilder: (context, index) {
                            final contact = _allContacts[index];
                            final bool isPredefined = _predefinedContacts.any((pc) => pc.name == contact.name && pc.phoneNumber == contact.phoneNumber);

                            return Semantics(
                              label: 'Contact: ${contact.name}, Phone number: ${contact.phoneNumber}. ${isPredefined ? "This is a predefined contact." : "This is a user-added contact."}',
                              child: Card(
                                child: ListTile(
                                  leading: Icon(
                                    isPredefined ? Icons.verified_user_outlined : Icons.person_pin_circle_outlined,
                                    size: 30,
                                    color: isPredefined ? Colors.blueAccent : Colors.teal,
                                  ),
                                  title: Text(contact.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                                  subtitle: Text(contact.phoneNumber, style: Theme.of(context).textTheme.bodyLarge),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Semantics(
                                        label: 'Call ${contact.name}',
                                        button: true,
                                        child: IconButton(
                                          icon: const Icon(Icons.call, color: Colors.green),
                                          onPressed: () => _makePhoneCall(context, contact.phoneNumber, contact.name),
                                          tooltip: 'Call ${contact.name}',
                                        ),
                                      ),
                                      if (!isPredefined) // Show edit/delete only for user contacts
                                        Semantics(
                                          label: 'Edit ${contact.name}',
                                          button: true,
                                          child: IconButton(
                                            icon: const Icon(Icons.edit_outlined, color: Colors.orange),
                                            onPressed: () => _editContact(context, contact, index),
                                            tooltip: 'Edit ${contact.name}',
                                          ),
                                        ),
                                      if (!isPredefined)
                                        Semantics(
                                          label: 'Delete ${contact.name}',
                                          button: true,
                                          child: IconButton(
                                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                            onPressed: () => _deleteContact(context, contact, index),
                                            tooltip: 'Delete ${contact.name}',
                                          ),
                                        ),
                                    ],
                                  ),
                                  onTap: () => _makePhoneCall(context, contact.phoneNumber, contact.name),
                                ),
                              ),
                            );
                          },
                        ), 
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addContact(context),
        tooltip: 'Add New Contact',
        child: const Icon(Icons.add),
      ),
    );
  }
} 