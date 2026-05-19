// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Crisis Assist';

  @override
  String get home => 'Home';

  @override
  String get sos => 'SOS';

  @override
  String get map => 'Map';

  @override
  String get profile => 'Profile';

  @override
  String get emergencyContacts => 'Emergency Contacts';

  @override
  String get guidelines => 'Guidelines';

  @override
  String get myLocation => 'My Location';

  @override
  String get news => 'News';

  @override
  String get sosActivated => 'SOS mode activated';

  @override
  String get sendSOSDefault =>
      'SOS sent to default number (112) and your contacts.';

  @override
  String get primarySOSNumber => 'Primary SOS Number';

  @override
  String get customSOSMessage => 'Custom SOS Message';
}
