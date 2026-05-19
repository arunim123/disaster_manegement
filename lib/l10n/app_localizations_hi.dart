// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'आपदा सहायता';

  @override
  String get home => 'होम';

  @override
  String get sos => 'एसओएस (SOS)';

  @override
  String get map => 'नक्शा';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get emergencyContacts => 'आपातकालीन संपर्क';

  @override
  String get guidelines => 'दिशानिर्देश';

  @override
  String get myLocation => 'मेरी लोकेशन';

  @override
  String get news => 'समाचार';

  @override
  String get sosActivated => 'एसओएस मोड सक्रिय';

  @override
  String get sendSOSDefault =>
      'डिफ़ॉल्ट नंबर (112) और आपके संपर्कों को एसओएस भेजा गया।';

  @override
  String get primarySOSNumber => 'प्राथमिक एसओएस नंबर';

  @override
  String get customSOSMessage => 'कस्टम एसओएस संदेश';
}
