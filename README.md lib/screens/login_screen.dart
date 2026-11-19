import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _pwd = TextEditingController();
  String? _error;

  Future<void> _login() async {
    if (await AuthService.verify(_pwd.text)) {
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      setState(() => _error = 'كلمة المرور غير صحيحة');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.assignment_ind, size: 90, color: Colors.teal),
              const SizedBox(height: 16),
              const Text('إسناد ماهر',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('نظام متابعة التكاليف والمكاتبات', style: TextStyle(fontSize: 15)),
              const SizedBox(height: 40),
              TextField(
                controller: _pwd,
                obscureText: true,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور',
                  border: const OutlineInputBorder(),
                  errorText: _error,
                  prefixIcon: const Icon(Icons.lock),
                ),
                onSubmitted: (_) => _login(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('دخول', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 12),
              const Text('كلمة المرور الافتراضية: 1234',
                  style: TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
