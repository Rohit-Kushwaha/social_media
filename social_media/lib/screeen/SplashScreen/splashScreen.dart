import 'dart:async';

import 'package:flutter/material.dart';
import 'package:social_media/constants/Constantcolors.dart';
import 'package:social_media/screeen/LandingPAge/landingPage.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ConstantColors constantColors = ConstantColors();

  @override
  void initState() {
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            PageTransition(
                child: LandingPage(), type: PageTransitionType.leftToRight))
                );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: Center(
        child: RichText(
          text: TextSpan(
            text: 'the',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: constantColors.whiteColor,
                fontSize: 30),
            children: <TextSpan>[
              TextSpan(
                text: 'Social',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: constantColors.blueColor,
                    fontSize: 34),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
