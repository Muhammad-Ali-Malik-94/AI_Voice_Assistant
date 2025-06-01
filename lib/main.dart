// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:provider/provider.dart';
// import 'firebase_options.dart';
// import 'services/auth_service.dart';
// import 'services/chat_session_manager.dart';
// import 'services/settings_service.dart';
// import 'screens/home_screen.dart';
// import 'screens/login_screen.dart';
// import 'widgets/loading_screen.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Initialize Firebase
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   // Initialize Settings Service
//   final settingsService = await SettingsService.create();
//
//   runApp(
//     MyApp(settingsService: settingsService),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   final SettingsService settingsService;
//
//   const MyApp({
//     super.key,
//     required this.settingsService,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         Provider<SettingsService>.value(value: settingsService),
//         Provider<AuthService>(
//           create: (_) => AuthService(),
//         ),
//         ChangeNotifierProxyProvider<AuthService, ChatSessionManager>(
//           create: (_) => ChatSessionManager(),
//           update: (_, auth, chatManager) =>
//           chatManager!..updateUser(auth.currentUser),
//         ),
//       ],
//       child: Builder(
//         builder: (context) {
//           final themeMode = context.watch<SettingsService>().themeMode;
//
//           return MaterialApp(
//             title: 'AI Chat App',
//             theme: ThemeData(
//               colorScheme: ColorScheme.fromSeed(
//                 seedColor: Colors.deepPurple,
//                 brightness: Brightness.light,
//               ),
//               useMaterial3: true,
//             ),
//             darkTheme: ThemeData(
//               colorScheme: ColorScheme.fromSeed(
//                 seedColor: Colors.deepPurple,
//                 brightness: Brightness.dark,
//               ),
//               useMaterial3: true,
//             ),
//             themeMode: ThemeMode.values.firstWhere(
//                   (mode) => mode.name == themeMode,
//               orElse: () => ThemeMode.system,
//             ),
//             home: const AuthWrapper(),
//           );
//         },
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Firebase Test'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              try {
                final firestore = FirebaseFirestore.instance;
                await firestore.collection('test').add({
                  'message': 'Test message',
                  'timestamp': FieldValue.serverTimestamp(),
                });
                print('Document added successfully');
              } catch (e) {
                print('Error: $e');
              }
            },
            child: const Text('Test Firebase'),
          ),
        ),
      ),
    );
  }
}