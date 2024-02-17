import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:escriba_app/providers/authorization_provider.dart';
import 'package:escriba_app/screens/home_screen/home_screen.dart';
import 'package:escriba_app/screens/loading_screen/loading_screen.dart';
import 'package:escriba_app/screens/login_screen/login_screen.dart';
import 'package:escriba_app/theme/EscribaTheme.dart';
import 'package:provider/provider.dart';
import 'config.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Asegura la inicialización de widgets

  // Solicita permisos aquí
  await requestPermissions();

  runApp(const MyApp());
}

Future<void> requestPermissions() async {
  // Solicita todos los permisos que necesitas al inicio
  await Permission.microphone.request();
  // Añade más permisos según sea necesario
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
        return const HomeScreen();
      },
      child: const LoadingScreen(),
    );
  }
}
