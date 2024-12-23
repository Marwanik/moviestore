import 'package:flutter/material.dart';
import 'package:moviestore/presentation/constans/colors.dart';
import 'package:moviestore/presentation/constans/string.dart';
import 'package:moviestore/presentation/constans/textStyle.dart';
import 'package:moviestore/presentation/pages/loginScreen.dart';
import 'package:moviestore/presentation/pages/homeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _circleScaleUpAnimation;
  late Animation<double> _circleScaleDownAnimation;
  late Animation<double> _imageFadeInAnimation;
  late Animation<Offset> _textSlideInAnimation;
  late Animation<Color?> _backgroundColorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _circleScaleUpAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _circleScaleDownAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.6, curve: Curves.easeIn),
      ),
    );

    _imageFadeInAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.6, curve: Curves.easeIn),
      ),
    );

    _textSlideInAnimation = Tween<Offset>(begin: const Offset(3, 0), end: const Offset(0, 0)).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 1.0, curve: Curves.easeInOut),
      ),
    );

    _backgroundColorAnimation = ColorTween(
      begin: secondColor,
      end: mainColor,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();

    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    Future.delayed(const Duration(seconds: 4), () {
      if (isLoggedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundColorAnimation,
        builder: (context, child) {
          return Container(
            color: _backgroundColorAnimation.value,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _circleScaleUpAnimation,
                    builder: (context, child) {
                      double scaleValue = _circleScaleUpAnimation.value;
                      if (_circleScaleDownAnimation.value < 1) {
                        scaleValue = _circleScaleDownAnimation.value;
                      }
                      return Transform.scale(
                        scale: scaleValue,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: _textSlideInAnimation,
                    builder: (context, child) {
                      return SlideTransition(
                        position: _textSlideInAnimation,
                        child: Opacity(
                          opacity: _imageFadeInAnimation.value,
                          child: Text(
                            MOVIESSTORE,
                            style: splash,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
