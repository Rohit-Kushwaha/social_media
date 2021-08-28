import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media/constants/Constantcolors.dart';
import 'package:social_media/screeen/AltProfile/alt_profile_helpers.dart';
import 'package:social_media/screeen/Chatroom/ChatroomHelper.dart';
import 'package:social_media/screeen/Feed/FeedHelpers.dart';
import 'package:social_media/screeen/HomePage/HomepageHelpers.dart';
import 'package:social_media/screeen/LandingPage/LandingServices.dart';
import 'package:social_media/screeen/LandingPage/Landingutils.dart';
import 'package:social_media/screeen/LandingPage/landingHelpers.dart';
import 'package:social_media/screeen/Message/GroupMessageHelper.dart';
import 'package:social_media/screeen/Profile/ProfileHelperes.dart';
import 'package:social_media/screeen/SplashScreen/splashScreen.dart';
import 'package:social_media/screeen/Stories/storiesHelper.dart';
import 'package:social_media/services/Authentication.dart';
import 'package:social_media/services/FirebaseOperation.dart';
import 'package:social_media/utils/PostOptions.dart';
import 'package:social_media/utils/UploadPost.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ConstantColors constantcolors = ConstantColors();
    return MultiProvider(
        child: MaterialApp(
          home: SplashScreen(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            accentColor: constantcolors.blueColor,
            fontFamily: 'Poppins',
            canvasColor: Colors.transparent,
          ),
        ),
        providers: [
          ChangeNotifierProvider(create: (_) => PostFunctions()),
          ChangeNotifierProvider(create: (_) => AltProfileHelper()),
          ChangeNotifierProvider(create: (_) => Authentication()),
          ChangeNotifierProvider(create: (_) => FeedHelpers()),
          ChangeNotifierProvider(create: (_) => LandingHelpers()),
          ChangeNotifierProvider(create: (_) => LandingServices()),
          ChangeNotifierProvider(create: (_) => FirebaseOperation()),
          ChangeNotifierProvider(create: (_) => LandingUtils()),
          ChangeNotifierProvider(create: (_) => HomepageHelpers()),
          ChangeNotifierProvider(create: (_) => ProfileHelpers()),
          ChangeNotifierProvider(create: (_) => UploadPost()),
          ChangeNotifierProvider(create: (_) => ChatroomHelper()),
          ChangeNotifierProvider(create: (_) => GroupMessageHelper()),
          ChangeNotifierProvider(create: (_) => StoriesHelper()),
        ]);
  }
}
