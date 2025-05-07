import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'chat_screen.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLogin = true;
  String email = '';
  String password = '';

  void _submit() async {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) return;
    _formKey.currentState!.save();

    final auth = FirebaseAuth.instance;

    try {
      UserCredential userCredential;

      if (isLogin) {
        userCredential = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        userCredential = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
      await FirebaseFirestore.instance
    .collection('users')
    .doc(userCredential.user!.uid)
    .set({
  'email': email,
  'image_url': 'https://www.gravatar.com/avatar/placeholder', // varsayılan bir fotoğraf URL'si
});

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ChatScreen()),
        );
      }
    } catch (e) {

if (mounted) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Hata: ${e.toString()}')),
  );
}

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Giriş Yap' : 'Kayıt Ol')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-posta'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value == null || value.isEmpty ? 'E-posta girin' : null,
                onSaved: (value) => email = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Şifre'),
                obscureText: true,
                validator: (value) =>
                    value != null && value.length < 6
                        ? 'En az 6 karakter olmalı'
                        : null,
                onSaved: (value) => password = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(isLogin ? 'Giriş Yap' : 'Kayıt Ol'),
              ),
              TextButton(
                onPressed: () => setState(() => isLogin = !isLogin),
                child: Text(isLogin
                    ? 'Hesabın yok mu? Kayıt ol'
                    : 'Zaten hesabın var mı? Giriş yap'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
