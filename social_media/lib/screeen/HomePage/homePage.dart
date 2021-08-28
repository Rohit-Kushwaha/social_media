import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media/constants/Constantcolors.dart';
import 'package:social_media/screeen/Chatroom/Chatroom.dart';
import 'package:social_media/screeen/Feed/Feed.dart';
import 'package:social_media/screeen/HomePage/HomepageHelpers.dart';
import 'package:social_media/screeen/Profile/Profile.dart';
import 'package:social_media/services/FirebaseOperation.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController homePageController = PageController();
  ConstantColors constantColors = ConstantColors();
  int pageIndex = 0;

  @override
  void initState() {
    Provider.of<FirebaseOperation>(context, listen: false)
        .initUserData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: constantColors.darkColor,
        body: PageView(
          controller: homePageController,
          children: [
            Feed(),
            Chatroom(),
            Profile(),
          ],
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (page) {
            setState(() {
              pageIndex = page;
            });
          },
        ),
        bottomNavigationBar:
            Provider.of<HomepageHelpers>(context, listen: false)
                .bottomNavigationBar(context, pageIndex, homePageController)
    );
  }
}
