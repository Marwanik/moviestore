import 'package:flutter/material.dart';
import 'package:moviestore/presentation/widgets/authFieldWidget.dart';
import 'package:moviestore/presentation/widgets/loginButtonWidget.dart';
import 'package:moviestore/presentation/constans/colors.dart';
import 'package:moviestore/presentation/constans/icons.dart';
import 'package:moviestore/presentation/constans/string.dart';
import 'package:moviestore/presentation/constans/textStyle.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordHidden = true;

  // Regex for validation
  final RegExp _emailRegex = RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z]+\.[a-zA-Z]+');
  final RegExp _passwordRegex = RegExp(r'^(?=.*[!@#\$&*~]).{8,}$');

  void _login() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Successful!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2F),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60),


              Text(WELCOME, style: loginFirst),
              SizedBox(height: 8),

              Text(LOGINTOCONTINUE, style: loginSecond),
              SizedBox(height: 40),

              Center(child: LOGINICON),
              SizedBox(height: 60),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      hintText: ENTERYOUREMAIL,
                      controller: _emailController,
                      hintStyle: loginFields,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        } else if (!_emailRegex.hasMatch(value)) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    CustomTextField(
                      hintText: ENTERYOURPASSWORD,
                      controller: _passwordController,
                      hintStyle: loginFields,
                      obscureText: _isPasswordHidden,
                      isPasswordField: true,
                      suffixIcon: _isPasswordHidden
                          ? Icons.visibility_off
                          : Icons.visibility,
                      onToggleVisibility: () {
                        setState(() {
                          _isPasswordHidden = !_isPasswordHidden;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        } else if (!_passwordRegex.hasMatch(value)) {
                          return "Password must be at least 8 characters and include a special character (!@#\$&*~)";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Add Forgot Password functionality here
                        },
                        child: Text(FORGETPASSWORD, style: loginFields),
                      ),
                    ),
                    SizedBox(height: 40),

                    CustomButton(
                      text: LOGIN,
                      onPressed: _login,
                      backgroundColor: selectColor,
                      textStyle: loginButton,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
