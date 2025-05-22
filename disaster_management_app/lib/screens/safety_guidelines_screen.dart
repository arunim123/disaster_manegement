import 'package:flutter/material.dart';
import '../utils/guideline_data.dart'; // Your data source
import 'guideline_detail_screen.dart';

class SafetyGuidelinesScreen extends StatelessWidget {
  const SafetyGuidelinesScreen({super.key});

  IconData _getIconForDisaster(String iconDataString) {
    // For a real app, consider a more robust mapping or using actual image assets
    switch (iconDataString) {
      case earthquakeIcon:
        return Icons.landslide_rounded;
      case floodIcon:
        return Icons.water_damage_rounded;
      case fireIcon:
        return Icons.local_fire_department_rounded;
      default:
        return Icons.help_center_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Guidelines'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: predefinedGuidelines.length,
        itemBuilder: (context, index) {
          final guideline = predefinedGuidelines[index];
          return Semantics(
            label: 'Safety guideline for ${guideline.name}. ${guideline.summary}',
            hint: 'Tap to view details for ${guideline.name}',
            button: true,
            child: Card(
              child: ListTile(
                leading: Icon(
                  _getIconForDisaster(guideline.iconData),
                  size: 36, // Slightly larger icon
                  color: Theme.of(context).primaryColorLight, // Use theme color
                ),
                title: Text(guideline.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                subtitle: Text(guideline.summary, maxLines: 2, overflow: TextOverflow.ellipsis),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GuidelineDetailScreen(guideline: guideline),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
} 