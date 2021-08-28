import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media/constants/Constantcolors.dart';

class HomepageHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget bottomNavigationBar(BuildContext context, int index, PageController pageController) {
    return CustomNavigationBar(
      currentIndex: index,
      bubbleCurve: Curves.bounceIn,
      scaleCurve: Curves.decelerate,
      selectedColor: constantColors.blueColor,
      unSelectedColor: constantColors.whiteColor,
      strokeColor: constantColors.blueColor,
      scaleFactor: 0.5,
      iconSize: 30,
      onTap: (val) {
        index = val;
        pageController.jumpToPage(val);
        notifyListeners();
      },
      backgroundColor: Color(0xff040307),
      items: [
        CustomNavigationBarItem(icon: Icon(EvaIcons.home)),
        CustomNavigationBarItem(icon: Icon(Icons.message_rounded)),
        CustomNavigationBarItem(icon: Icon(Icons.face,
              // radius: 35, backgroundColor: constantColors.blueGreyColor,
              // backgroundImage: NetworkImage(
              //   Provider.of<FirebaseOperation>(context,listen: false).initUserImage),

              ),
        )
      ],
    );
  }
}
