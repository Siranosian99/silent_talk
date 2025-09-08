// main.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Django Register Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const RegisterScreen(),
    );
  }
}

/// basit kayıt ekranı
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // TextEditingController’lar
  final _userNameCtrl = TextEditingController();
  final _nameCtrl     = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _passCtrl     = TextEditingController();

  bool _isBusy = false;

  // --- API çağrısı ---
  Future<bool> _registerUser() async {
    const baseUrl = 'http://10.0.2.2:8000/api/users/register/'; // emülatör için
    final url = Uri.parse(baseUrl);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userName': _userNameCtrl.text.trim(),
        'name'    : _nameCtrl.text.trim(),
        'email'   : _emailCtrl.text.trim(),
        'password': _passCtrl.text,
      }),
    );

    if (response.statusCode == 201) return true;

    // Hata detayını terminale yaz
    debugPrint('REGISTER FAILED ${response.statusCode}: ${response.body}');
    return false;
  }

  // --- formu gönder ---
  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isBusy = true);
    final ok = await _registerUser();
    setState(() => _isBusy = false);

    if (ok) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kayıt başarılı!')),
        );
      }
      _formKey.currentState!.reset();
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kayıt başarısız!')),
        );
      }
    }
  }

  @override
  void dispose() {
    _userNameCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kayıt Ol')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Kullanıcı adı
              TextFormField(
                controller: _userNameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Kullanıcı Adı',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) =>
                (v == null || v.isEmpty) ? 'Kullanıcı adı zorunlu' : null,
              ),
              const SizedBox(height: 12),

              // Ad
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Ad Soyad',
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: (v) =>
                (v == null || v.isEmpty) ? 'Ad zorunlu' : null,
              ),
              const SizedBox(height: 12),

              // E‑posta
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E‑posta',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'E‑posta zorunlu';
                  final emailReg = RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w+$');
                  return emailReg.hasMatch(v) ? null : 'Geçersiz e‑posta';
                },
              ),
              const SizedBox(height: 12),

              // Şifre
              TextFormField(
                controller: _passCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Şifre',
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (v) =>
                (v == null || v.length < 6) ? 'En az 6 karakter' : null,
              ),
              const SizedBox(height: 24),

              // Gönder butonu
              ElevatedButton.icon(
                onPressed: _isBusy ? null : _onSubmit,
                icon: _isBusy
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Icon(Icons.send),
                label: Text(_isBusy ? 'Gönderiliyor...' : 'Kayıt Ol'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
