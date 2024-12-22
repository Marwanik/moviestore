import 'package:flutter/material.dart';
import 'package:moviestore/presentation/constans/colors.dart';
import 'package:moviestore/presentation/constans/textStyle.dart';

class ProfileScreen extends StatelessWidget {
  final String username;

  ProfileScreen({required this.username});

  void _logout(BuildContext context) {
    // Navigate to LoginScreen
    Navigator.pushReplacementNamed(context, '/login'); // Replace '/login' with your LoginScreen route
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Flutter Logo Image
            const FlutterLogo(size: 120),
            const SizedBox(height: 20),

            // Username
            Text(
              username,
              style: movieName1, // Adjust style as needed
            ),
            const SizedBox(height: 40),

            // Logout Button
            ElevatedButton(
              onPressed: () => _logout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: selectColor,
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 40,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
