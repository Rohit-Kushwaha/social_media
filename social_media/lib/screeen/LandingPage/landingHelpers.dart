import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_media/constants/Constantcolors.dart';
import 'package:social_media/screeen/HomePage/homePage.dart';
import 'package:social_media/screeen/LandingPage/LandingServices.dart';
import 'package:social_media/screeen/LandingPage/Landingutils.dart';
import 'package:social_media/screeen/Profile/Profile.dart';
import 'package:social_media/services/Authentication.dart';

class LandingHelpers with ChangeNotifier {
 

  ConstantColors constantColors = ConstantColors();
  Widget bodyImage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/login.png'),
        ),
      ),
    );
  }

  Widget taglineText(BuildContext context) {
    return Positioned(
      top: 450.0,
      left: 10.0,
      child: Container(
        constraints: BoxConstraints(maxWidth: 170),
        child: RichText(
          text: TextSpan(
            text: 'Are ',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: constantColors.whiteColor,
                fontSize: 40),
            children: <TextSpan>[
              TextSpan(
                text: 'You ',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: constantColors.whiteColor,
                    fontSize: 40),
              ),
              TextSpan(
                text: 'Social ?',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: constantColors.blueColor,
                    fontSize: 40),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mainButtons(BuildContext context) {
    return Positioned(
      top: 630,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                emailAuthSheet(context);
              },
              child: Container(
                child: Icon(
                  EvaIcons.emailOutline,
                  color: constantColors.yellowColor,
                ),
                height: 40.0,
                width: 80.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: constantColors.yellowColor,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                print('SigninwithGoogle');
                Provider.of<Authentication>(context, listen: false)
                    .signInWithGoogle().then((result){
                  if (result == null) {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: HomePage(),
                            type: PageTransitionType.leftToRight),
                    );
                          }
              });
                },
              child: Container(
                child: Icon(
                  FontAwesomeIcons.google,
                  color: constantColors.redColor,
                ),
                height: 40.0,
                width: 80.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: constantColors.redColor,
                  ),
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                child: Icon(
                  FontAwesomeIcons.facebookF,
                  color: constantColors.blueColor,
                ),
                height: 40.0,
                width: 80.0,
                decoration: BoxDecoration(
                  border: Border.all(color: constantColors.blueColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget privacyText(BuildContext context) {
    return Positioned(
      top: 680.0,
      left: 20.0,
      right: 20.0,
      child: Container(
        child: Column(
          children: [
            Text("By continuing you agree the social's Terms of",
                style: TextStyle(color: Colors.grey, fontSize: 12.0)),
            Text("Services and Privacy Policy",
                style: TextStyle(color: Colors.grey, fontSize: 12.0))
          ],
        ),
      ),
    );
  }

  emailAuthSheet(BuildContext context) {
    ConstantColors constantColors = ConstantColors();
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Provider.of<LandingServices>(context, listen: false)
                    .passwordLessSignIn(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                        color: constantColors.blueColor,
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        onPressed: () {
                          Provider.of<LandingServices>(context, listen: false)
                              .loginSheet(context);
                        }),
                    MaterialButton(
                      color: constantColors.redColor,
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () {
                        Provider.of<LandingUtils>(context, listen: false)
                            .selectAvatarOptionsSheet(context);
                      },
                    )
                  ],
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
          );
        });
  }

}
