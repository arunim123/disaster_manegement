import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EmergencyChecklistScreen extends StatefulWidget {
  const EmergencyChecklistScreen({super.key});

  @override
  State<EmergencyChecklistScreen> createState() => _EmergencyChecklistScreenState();
}

class ChecklistItem {
  String name;
  bool isChecked;
  ChecklistItem({required this.name, this.isChecked = false});

  Map<String, dynamic> toJson() => {
        'name': name,
        'isChecked': isChecked,
      };

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      name: json['name'],
      isChecked: json['isChecked'],
    );
  }
}

class _EmergencyChecklistScreenState extends State<EmergencyChecklistScreen> {
  List<ChecklistItem> _items = [];

  final List<String> _defaultItems = [
    'Water (1 gallon per person per day)',
    'Non-perishable food (3-day supply)',
    'Battery-powered or hand-crank radio',
    'Flashlight',
    'Extra batteries',
    'First aid kit',
    'Whistle to signal for help',
    'Dust mask',
    'Moist towelettes and garbage bags',
    'Wrench or pliers to turn off utilities',
    'Manual can opener',
    'Local maps',
    'Cell phone with chargers and backup battery',
    'Prescription medications',
    'Important family documents (copies)',
  ];

  @override
  void initState() {
    super.initState();
    _loadChecklist();
  }

  Future<void> _loadChecklist() async {
    final prefs = await SharedPreferences.getInstance();
    final String? itemsJson = prefs.getString('emergency_checklist');

    if (itemsJson != null) {
      final List<dynamic> decoded = jsonDecode(itemsJson);
      setState(() {
        _items = decoded.map((e) => ChecklistItem.fromJson(e)).toList();
      });
    } else {
      setState(() {
        _items = _defaultItems.map((e) => ChecklistItem(name: e)).toList();
      });
      _saveChecklist();
    }
  }

  Future<void> _saveChecklist() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_items.map((e) => e.toJson()).toList());
    await prefs.setString('emergency_checklist', encoded);
  }

  void _toggleItem(int index) {
    setState(() {
      _items[index].isChecked = !_items[index].isChecked;
    });
    _saveChecklist();
  }

  @override
  Widget build(BuildContext context) {
    final double progress = _items.isEmpty ? 0 : _items.where((i) => i.isChecked).length / _items.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Go-Bag'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).cardColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Preparation Progress',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: Colors.grey[300],
                  color: progress == 1.0 ? Colors.green : Colors.deepOrange,
                ),
                const SizedBox(height: 8),
                Text(
                  '${(_items.where((i) => i.isChecked).length)} of ${_items.length} items packed',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return CheckboxListTile(
                  title: Text(
                    item.name,
                    style: TextStyle(
                      decoration: item.isChecked ? TextDecoration.lineThrough : null,
                      color: item.isChecked ? Colors.grey : null,
                    ),
                  ),
                  value: item.isChecked,
                  activeColor: Colors.deepOrange,
                  onChanged: (_) => _toggleItem(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
