import '../models/disaster_guideline.dart';

// Placeholder icon identifiers - these would ideally map to actual IconData or image assets
const String earthquakeIcon = 'earthquake'; // Example: could be an asset path later
const String floodIcon = 'flood';
const String fireIcon = 'fire';

final List<DisasterGuideline> predefinedGuidelines = [
  DisasterGuideline(
    id: 'earthquake',
    name: 'Earthquake',
    iconData: earthquakeIcon,
    summary: 'Stay safe during and after an earthquake.',
    sections: [
      GuidelineSection(
        title: 'Before an Earthquake',
        content: 'Identify safe spots in each room (under a sturdy table, against an inside wall). Secure heavy items that could fall. Prepare an emergency kit.',
        checklist: [
          ChecklistItem(text: 'Identify safe spots'),
          ChecklistItem(text: 'Secure heavy furniture'),
          ChecklistItem(text: 'Prepare emergency kit (water, food, first aid)'),
          ChecklistItem(text: 'Practice Drop, Cover, and Hold On'),
        ],
      ),
      GuidelineSection(
        title: 'During an Earthquake',
        content: 'DROP to the ground. Take COVER by getting under a sturdy table or other piece of furniture. HOLD ON until the shaking stops. If there isn\'t a table or desk near you, cover your face and head with your arms and crouch in an inside corner of the building. Stay away from windows and outside doors.',
      ),
      GuidelineSection(
        title: 'After an Earthquake',
        content: 'Check yourself and others for injuries. Be prepared for aftershocks. Check for gas leaks, electrical damage, and structural damage before re-entering buildings. Listen to the radio for updates.',
        checklist: [
          ChecklistItem(text: 'Check for injuries'),
          ChecklistItem(text: 'Beware of aftershocks'),
          ChecklistItem(text: 'Check utilities (gas, water, electricity)'),
          ChecklistItem(text: 'Stay informed via radio/official channels'),
        ],
      ),
    ],
  ),
  DisasterGuideline(
    id: 'flood',
    name: 'Flood',
    iconData: floodIcon,
    summary: 'Protect yourself and your property from flood damage.',
    sections: [
      GuidelineSection(
        title: 'Before a Flood',
        content: 'Know your flood risk. Make a flood emergency plan. Build or restock your emergency preparedness kit. Elevate and anchor critical utilities. Waterproof your basement.',
        checklist: [
          ChecklistItem(text: 'Know your flood zone/risk'),
          ChecklistItem(text: 'Prepare an emergency kit for flooding'),
          ChecklistItem(text: 'Elevate appliances if possible'),
          ChecklistItem(text: 'Have a communication plan'),
        ],
      ),
      GuidelineSection(
        title: 'During a Flood',
        content: 'Evacuate immediately if told to do so. Never drive around barricades. Do not walk, swim, or drive through flood waters. Turn Around, Don\'t Drown! Listen to EAS, NOAA Weather Radio, or local alerting systems for current emergency information and instructions.',
      ),
      GuidelineSection(
        title: 'After a Flood',
        content: 'Return home only when authorities say it is safe. Be aware of areas where floodwaters have receded. Roads may have weakened and could collapse under the weight of a car. Wear sturdy shoes and be careful around damaged buildings.',
        checklist: [
          ChecklistItem(text: 'Wait for official clearance to return'),
          ChecklistItem(text: 'Avoid floodwaters - hidden dangers'),
          ChecklistItem(text: 'Check for structural damage before entering'),
          ChecklistItem(text: 'Document damage for insurance'),
        ],
      ),
    ],
  ),
  // Add more disaster types here (e.g., Fire, Hurricane, Tornado)
  // For example, a basic entry for Fire:
  DisasterGuideline(
    id: 'fire',
    name: 'Fire Safety',
    iconData: fireIcon,
    summary: 'Know how to prevent fires and what to do if one occurs.',
    sections: [
      GuidelineSection(
        title: 'Fire Prevention',
        content: 'Install smoke alarms on every level of your home, inside bedrooms and outside sleeping areas. Test smoke alarms every month. Have a fire escape plan and practice it.',
        checklist: [
          ChecklistItem(text: 'Install smoke alarms'),
          ChecklistItem(text: 'Test smoke alarms monthly'),
          ChecklistItem(text: 'Create and practice fire escape plan'),
        ],
      ),
      GuidelineSection(
        title: 'During a Fire',
        content: 'If your smoke alarm sounds, get out and stay out. If you have to escape through smoke, get low and go under the smoke to your way out. Feel the door with the back of your hand before opening it. If it\'s hot, use another way out.',
      ),
    ],
  ),
]; 