import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogOutScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LogOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () async {
            await _auth.signOut();
          },
          child: Text(
            'Signout',
            style: TextStyle(
              fontSize: 20,
              letterSpacing: 4,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
