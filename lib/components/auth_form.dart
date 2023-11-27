// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teste_target/models/auth.dart';

import '../exceptions/auth_exception.dart';
import 'custom_text_form_field.dart';

enum AuthMode { signup, login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.login;

  bool _isLogin() => _authMode == AuthMode.login;
  bool _isSignup() => _authMode == AuthMode.signup;

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.signup;
      } else {
        _authMode = AuthMode.login;
      }
    });
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreo um Erro'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);

    try {
      if (_isLogin()) {
        // Login
        await auth.signIn(
          emailController.text,
          passwordController.text,
        );
      } else {
        // Registrar
        await auth.signUp(
          emailController.text,
          passwordController.text,
        );
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado!');
    }

    setState(() => _isLoading = false);
  }

  String label = 'Usuário';
  IconData icon = Icons.person;
  TextInputType textInputType = TextInputType.emailAddress;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(16),
      height: _isLogin() ? 310 : 400,
      width: deviceSize.width * 0.75,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextFormField(
              label: label,
              controller: emailController,
              icon: icon,
              textInputType: textInputType,
              obscureText: false,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'O campo usuário não pode estar vazio!';
                } else if (value.length > 20) {
                  return 'Não pode ser maior que 20 caracteres!';
                } else if (value.endsWith(' ')) {
                  return 'Não pode terminar com espaço em branco!';
                }
                return null;
              },
            ),
            CustomTextFormField(
              label: 'Senha',
              controller: passwordController,
              icon: Icons.lock,
              textInputType: textInputType,
              obscureText: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'O campo senha não pode estar vazio!';
                } else if (value.length < 2) {
                  return 'A senha deve ter no mínimo 2 caracteres!';
                } else if (value.length > 20) {
                  return 'Não pode ser maior que 20 caracteres!';
                } else if (value.contains(RegExp(r'[^a-zA-Z0-9]'))) {
                } else if (value.endsWith(' ')) {
                  return 'Não pode terminar com espaço em branco!';
                } else if (value.contains(RegExp(r'[^a-zA-Z0-9]'))) {
                  return 'Apenas letras e números!';
                }
                return null;
              },
            ),
            if (_isSignup())
              CustomTextFormField(
                label: 'Confirmar Senha',
                controller: confirmPasswordController,
                icon: Icons.lock,
                textInputType: textInputType,
                obscureText: true,
                validator: _isLogin()
                    ? null
                    : (_password) {
                        final password = _password ?? '';
                        if (password != passwordController.text) {
                          return 'Senhas informadas não conferem.';
                        }
                        return null;
                      },
              ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 98, 187, 101),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 60,
                    vertical: 8,
                  ),
                ),
                child: Text(
                  _authMode == AuthMode.login ? 'Entrar' : 'Registrar',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            const Spacer(),
            TextButton(
              onPressed: _switchAuthMode,
              child: Text(
                _isLogin()
                    ? 'Sem cadastro? Registre-se já!'
                    : 'Já possui conta? Entre agora!',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}