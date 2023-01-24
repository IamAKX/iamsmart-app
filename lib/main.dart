import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:iamsmart/screen/login/login_screen.dart';
import 'package:iamsmart/util/router.dart';
import 'package:iamsmart/util/theme.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'service/auth_provider.dart';
import 'service/snakbar_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
