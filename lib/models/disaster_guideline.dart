class DisasterGuideline {
  final String id;
  final String name;
  final String iconData; // Placeholder for icon, could be asset path or IconData later
  final String summary;
  final List<GuidelineSection> sections;

  const DisasterGuideline({
    required this.id,
    required this.name,
    required this.iconData,
    required this.summary,
    required this.sections,
  });
}

class GuidelineSection {
  final String title;
  final String content;
  final List<ChecklistItem>? checklist; // Checklist is optional

  const GuidelineSection({
    required this.title,
    required this.content,
    this.checklist,
  });
}

class ChecklistItem {
  final String text;
  bool isChecked; // Now mutable

  ChecklistItem({ // No longer const constructor
    required this.text,
    this.isChecked = false,
  });
} 