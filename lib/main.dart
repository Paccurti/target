import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teste_target/firebase_options.dart';
import 'package:teste_target/models/app_text_list.dart';
import 'package:teste_target/models/auth.dart';
import 'package:teste_target/pages/auth_or_app_page.dart';
import 'package:teste_target/pages/auth_page.dart';
import 'package:teste_target/pages/home_page.dart';
import 'package:teste_target/utils/app_routes.dart';

void main() async {
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
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, AppTextList>(
          create: (_) => AppTextList('', []),
          update: (ctx, auth, previous) {
            return AppTextList(
              auth.token ?? '',
              previous?.items ?? [],
            );
          },
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes: {
          AppRoutes.authPage: (context) => const AuthPage(),
          AppRoutes.homePage: (context) => const HomePage(),
          AppRoutes.authOrAppPage: (context) => const AuthOrAppPage(),
        },
      ),
    );
  }
}
