import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:iamsmart/util/router.dart';
import 'package:iamsmart/util/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'service/auth_provider.dart';

late SharedPreferences prefs;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => AuthProvider(),
        ),
      ],
      child: MaterialApp.router(
        title: 'IamSmart',
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: globalTheme(context),
      ),
    );
  }
}
