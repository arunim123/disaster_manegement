import 'package:flutter/material.dart';
import '../models/disaster_guideline.dart';

class GuidelineDetailScreen extends StatefulWidget {
  final DisasterGuideline guideline;

  const GuidelineDetailScreen({Key? key, required this.guideline}) : super(key: key);

  @override
  State<GuidelineDetailScreen> createState() => _GuidelineDetailScreenState();
}

class _GuidelineDetailScreenState extends State<GuidelineDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.guideline.name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            widget.guideline.summary,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16.0),
          ...widget.guideline.sections.map((section) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8.0),
                Text(section.content),
                if (section.checklist != null && section.checklist!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: section.checklist!.map((item) {
                        return Semantics(
                          label: "Checklist item: ${item.text}, currently ${item.isChecked ? 'checked' : 'unchecked'}",
                          checked: item.isChecked,
                          child: CheckboxListTile(
                            title: Text(item.text),
                            value: item.isChecked,
                            onChanged: (bool? newValue) {
                              setState(() {
                                item.isChecked = newValue ?? false;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                const SizedBox(height: 16.0),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
} 