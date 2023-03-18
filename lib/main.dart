import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scan/screens/home_screen.dart';
import 'package:qr_scan/screens/mapa_screen.dart';

import 'providers/scan_list_provider.dart';
import 'providers/ui_provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UIProvider()),
        ChangeNotifierProvider(create: (_) => ScanListProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QR Reader',
        initialRoute: 'home',
        routes: {
          'home': (_) => const HomeScreen(),
          'mapa': (_) => const MapaScreen(),
        },
        theme: ThemeData(
          // No es pot emprar colorPrimary des de l'actualització de Flutter
          colorScheme: const ColorScheme.light().copyWith(
            primary: Colors.deepPurple,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.deepPurple,
          ),
        ),
      ),
    );
  }
}
