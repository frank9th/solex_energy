import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';
import 'package:solex/model.dart';
import 'package:solex/screens/Item_sreen.dart';
import 'package:solex/screens/home.dart';
import 'firebase_options.dart';

//import 'package:flutter_dotenv/flutter_dotenv.dart';

//
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get the platform message channel.

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    name: 'solex-app',
  );
  //await dotenv.load(fileName: ".env");
  //var apiKey = dotenv.env['GOOGLE_API_KEY'];

  /// flutter run --dart-define=apiKey='Your Api Key'
  ///
  // Gemini.init(apiKey: apiKey!,);
  // Gemini.init(apiKey: const String.fromEnvironment('GOOGLE_API_KEY'), enableDebugging: true);

  // Gemini.reInitialize(apiKey: "new api key", enableDebugging: false);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Processor()),
    ChangeNotifierProvider(create: (_) => SingleProcessor()),
    ChangeNotifierProvider(create: (_) => ChatProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  // This ValueNotifier will keep track of the theme mode
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
            title: 'SOLEX',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.yellow,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.yellow,
              brightness: Brightness.dark,
              textTheme: const TextTheme(
                bodyMedium: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 15.0, // Adjust the font size as needed
                  color: Colors.black, // Set your desired font color
                ),
                // Other text styles...
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.green,
              ),
            ),
            themeMode: currentMode, // Use the current theme mode

            home: const AuditScreen()

            //const HomeScreen(),
            );
      },
    );
  }
}
