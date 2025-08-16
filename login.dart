import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController(text: 'demo@example.com');
  final pass = TextEditingController(text: 'password');
  bool loading = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: email, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: pass, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 16),
            if (error != null) Text(error!, style: const TextStyle(color: Colors.red)),
            FilledButton(
              onPressed: loading ? null : () async {
                setState(() { loading = true; error = null; });
                final res = await login(email.text, pass.text);
                if (res == null) {
                  setState(() { error = 'Invalid credentials'; loading = false; });
                } else {
                  final sp = await SharedPreferences.getInstance();
                  await sp.setString('token', res['token']);
                  if (context.mounted) Navigator.pushReplacementNamed(context, '/home');
                }
              },
              child: Text(loading ? '...' : 'Login'),
            )
          ],
        ),
      ),
    );
  }
}
