import 'package:assignment/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashArt extends StatefulWidget {
  const SplashArt({super.key});

  @override
  State<SplashArt> createState() => _SplashArtState();
}

class _SplashArtState extends State<SplashArt>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 2), () {
      // Navigator.of(context).pushReplacementNamed('/home');
      Navigator.of(context).pushReplacementNamed('/auth');
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              CustomizedColors.backgroundColor,
              Color.fromARGB(255, 224, 253, 255),
              Color.fromARGB(255, 184, 247, 252),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: const Center(
          child: Image(
            image: AssetImage('assets/images/logo.png'),
            width: 288,
            height: 288,
          ),
        ),
      ),
    
    );
  }
}
