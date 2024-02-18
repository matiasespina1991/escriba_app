import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:escriba_app/providers/authorization_provider.dart';
import 'package:escriba_app/screens/home_screen/home_screen.dart';
import 'package:escriba_app/screens/loading_screen/loading_screen.dart';
import 'package:escriba_app/screens/login_screen/login_screen.dart';
import 'package:escriba_app/theme/EscribaTheme.dart';
import 'package:provider/provider.dart';
import 'config.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await requestPermissions();

  runApp(const MyApp());
}

Future<void> requestPermissions() async {
  await Permission.microphone.request();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthorizationProvider()),
      ],
      child: MaterialApp(
        title: Config.appName,
        theme: EscribaTheme.themeData,
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthorizationProvider>(
      builder: (BuildContext context, value, Widget? child) {
        bool isAuthenticated = value.isAuthenticated;

        if (Config.debugMode == true) {
          isAuthenticated = true;
        }

        if (!isAuthenticated) {
          return const LoginScreen();
        }
        return const SpeechToTextScreen();
      },
      child: const LoadingScreen(),
    );
  }
}
