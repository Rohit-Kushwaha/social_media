import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_media/constants/Constantcolors.dart';
import 'package:social_media/screeen/HomePage/homePage.dart';
import 'package:social_media/screeen/LandingPage/Landingutils.dart';
import 'package:social_media/services/Authentication.dart';
import 'package:social_media/services/FirebaseOperation.dart';

class LandingServices with ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ConstantColors constantColors = ConstantColors();

  sohwUserAvatar(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.30,
            width: MediaQuery.of(context).size.width,
            child: Column(children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Divider(
                  thickness: 4.0,
                  color: constantColors.whiteColor,
                ),
              ),
              CircleAvatar(
                  radius: 65.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: FileImage(
                   Provider.of<LandingUtils>(context, listen: false)
                   .userAvatar)),

              SizedBox(
                height: 16,
              ),
              Container(
                child: Row(
                  children: [
                    MaterialButton(
                        child: Text('Reselect',
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: constantColors.whiteColor)),
                        onPressed: () {
                          Provider.of<LandingUtils>(context, listen: false)
                              .pickUserAvatar(context, ImageSource.gallery);
                        }),
                    MaterialButton(
                        color: constantColors.blueColor,
                        child: Text('ConfirmImage',
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                            )),
                        onPressed: () {
                          Provider.of<FirebaseOperation>(context, listen: false)
                              .uploadUserAvatar(context)
                              .whenComplete(() {
                            signInSheet(context);
                          });
                        })
                  ],
                ),
              ),
            ]),
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(15.0),
            ),
          );
        });
  }

  Widget  passwordLessSignIn(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .40,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return new ListView(
                children:
                    snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
              return ListTile(
                trailing: Container(

                  width: 120.0,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(icon: Icon(FontAwesomeIcons.check),
                          color: constantColors.blueColor,
                          onPressed: (){
                        Provider.of<Authentication>(context,listen: false).
                        logIntoAccount( documentSnapshot['useremail'], documentSnapshot['userpassword'])
                        .whenComplete(() {
                          Navigator.pushReplacement
                          (context, PageTransition(child: HomePage(),
                              type: PageTransitionType.leftToRight));
                        });
                          }),
                      IconButton(icon: Icon(FontAwesomeIcons.trashAlt),
                          color: constantColors.redColor,
                          onPressed: (){
                        Provider.of<FirebaseOperation>(context,listen: false)
                            .deleteUserData(documentSnapshot['useruid'],['users']);
                          }),
                    ],
                  ),
                ),
                leading: CircleAvatar(
                  backgroundColor: constantColors.darkColor,
                  backgroundImage: NetworkImage(documentSnapshot['userimage']),
                ),
                subtitle: Text(documentSnapshot['useremail'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: constantColors.whiteColor,
                      fontSize: 12,
                    )),
                title: Text(documentSnapshot['username'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: constantColors.greenColor,
                    )),
              );
            }).toList());
          }
        },
      ),
    );
  }

  signInSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
              padding: EdgeInsets.only(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                ),
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: FileImage(
                        Provider.of<LandingUtils>(context, listen: false)
                            .getUserAvatar),
                    backgroundColor: constantColors.redColor,
                    radius: 45.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        hintText: 'Enter name...',
                        hintStyle: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter email...',
                        hintStyle: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: 'Enter Password',
                        hintStyle: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: FloatingActionButton(
                        backgroundColor: constantColors.redColor,
                        child: Icon(
                          FontAwesomeIcons.check,
                          color: constantColors.whiteColor,
                        ),
                        onPressed: () {
                          if (emailController.text.isNotEmpty) {
                            Provider.of<Authentication>(context, listen: false)
                                .createAccount(emailController.text,
                                    passwordController.text)
                                .whenComplete(() {
                              print('Creating Collection...');
                              Provider.of<FirebaseOperation>(context,
                                      listen: false)
                                  .createUserCollection(context, {
                                    'userpassword': passwordController.text,
                                'useruid': Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserid,
                                'useremail': emailController.text,
                                'username': usernameController.text,
                                'userimage': Provider.of<LandingUtils>(context,
                                        listen: false)
                                    .getUserAvatarUrl,
                              });
                            });
                          } else {
                            warningText(context, 'Fill all the data');
                          }
                        }),
                  ),
                ]),
              ));
        });
  }

  warningText(BuildContext context, String warning) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.circular(15.0)),
            height: MediaQuery.of(context).size.height * .1,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                warning,
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
            ),
          );
        });
  }

  loginSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(),
            //     bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.30,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter email...',
                        hintStyle: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: 'Enter Password',
                        hintStyle: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  FloatingActionButton(
                      backgroundColor: constantColors.blueColor,
                      child: Icon(
                        FontAwesomeIcons.check,
                        color: constantColors.whiteColor,
                      ),
                      onPressed: () {
                        if (emailController.text.isNotEmpty) {
                          Provider.of<Authentication>(context, listen: false)
                              .logIntoAccount(
                                  emailController.text, passwordController.text)
                            //   .whenComplete(() {
                            // Provider.of<FirebaseOperation>(context,
                            //         listen: false)
                            //     .initUserData(context);
                          .whenComplete(() {
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: HomePage(),
                                    type: PageTransitionType.bottomToTop));
                          });
                        } else {
                          warningText(context, 'Fill all the data');
                        }
                      }),
                ],
              ),
              decoration: BoxDecoration(
                color: constantColors.blueColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
            ),
          );
        });
  }
}
