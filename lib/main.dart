import 'package:flutter/material.dart';
import 'package:s3gui/const.dart';
import 'package:s3gui/pages/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:s3gui/pages/home.dart';
import 'package:s3gui/repository/secureStore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
    // Verifica credenziali in modo asincrono
  final secureStorage = SecureStorage();
  final s3AccessKey = await secureStorage.getString(s3AccessKeyTag) ?? 
                      sharedPreferences.getString(s3AccessKeyTag) ?? '';
  
  // Migra le credenziali da SharedPreferences a SecureStorage se necessario
  if (s3AccessKey.isEmpty && sharedPreferences.containsKey(s3AccessKeyTag)) {
    final legacyKey = sharedPreferences.getString(s3AccessKeyTag) ?? '';
    if (legacyKey.isNotEmpty) {
      await secureStorage.saveString(s3AccessKeyTag, legacyKey);
    }
  }
  
  final isReady = s3AccessKey.isNotEmpty;
  runApp(App(sharedPreferences: sharedPreferences, isConfigured: isReady,));
}

class App extends StatelessWidget {
  const App({super.key, required this.sharedPreferences,  required this.isConfigured,});

  final SharedPreferences sharedPreferences;
 final bool isConfigured;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'S3 GUI',
      theme: ThemeData(
        fontFamily: 'Roboto',
        appBarTheme: AppBarTheme(color: Colors.deepPurpleAccent.shade700),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.lightBlue),
      ),
      debugShowCheckedModeBanner: false,
      home: isConfigured
          ? HomePage(sharedPreferences: sharedPreferences)
          : SettingsPage(sharedPreferences: sharedPreferences),
    );
  }
}
