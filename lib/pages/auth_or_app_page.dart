import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teste_target/pages/auth_page.dart';
import 'package:teste_target/pages/home_page.dart';

import '../models/auth.dart';

class AuthOrAppPage extends StatelessWidget {
  const AuthOrAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return auth.isAuth ? const HomePage() : const AuthPage();
  }
}
