import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_media/constants/Constantcolors.dart';
import 'package:social_media/screeen/HomePage/homePage.dart';
import 'package:social_media/screeen/Stories/storiesHelper.dart';
import 'package:social_media/screeen/Stories/stories_widget.dart';
import 'package:social_media/services/Authentication.dart';

class Stories extends StatefulWidget {
  final DocumentSnapshot snapshot;

  const Stories({Key key, @required this.snapshot}) : super(key: key);

  @override
  _StoriesState createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  final ConstantColors constantColors = ConstantColors();
  final StoryWidgets storyWidgets = StoryWidgets();

  @override
  void initState() {
    Provider.of<StoriesHelper>(context, listen: false)
        .storyTimePosted(widget.snapshot['time']);
    Provider.of<StoriesHelper>(context, listen: false).addSeenStamp(
        context,
        widget.snapshot.id,
        Provider.of<Authentication>(context, listen: false).userUid,
        widget.snapshot);
    // Timer(
    //   Duration(seconds: 15),
    //     () => Navigator.pushReplacement(context, PageTransition(
    //         child: HomePage(),type: PageTransitionType.bottomToTop
    //     )),
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: GestureDetector(
        onPanUpdate: (update) {
          if (update.delta.dx > 0) {
            print('update');
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: HomePage(), type: PageTransitionType.bottomToTop));
          } else {}
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(
                    widget.snapshot['image'],
                    fit: BoxFit.contain,
                  ),
                ),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Positioned(
              top: 30.0,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                child: Row(
                  children: [
                    Container(
                      child: CircleAvatar(
                        backgroundColor: constantColors.darkColor,
                        backgroundImage:
                            NetworkImage(widget.snapshot['userimage']),
                        radius: 25.0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 55,
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * .49,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.snapshot['username'],
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                            Text(
                                Provider.of<StoriesHelper>(context,
                                        listen: false)
                                    .getstoryTime,
                                style: TextStyle(
                                    color: constantColors.greenColor,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    Provider.of<Authentication>(context, listen: false)
                                .getUserid ==
                            widget.snapshot['useruid']
                        ? GestureDetector(
                            onTap: () {
                              storyWidgets.showViewers(context,
                                  widget.snapshot.id,
                                  widget.snapshot['useruid']);
                            },
                            child: Container(
                              height: 30,
                              width: 50.0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.solidEye,
                                    color: constantColors.yellowColor,
                                    size: 16.0,
                                  ),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('stories')
                                        .doc(widget.snapshot.id)
                                        .collection('seen')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        return Text(
                                          snapshot.data.docs.length.toString(),
                                          style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            width: 0.0,
                            height: 0.0,
                          ),
                    SizedBox(
                      height: 30.0,
                      width: 30.0,
                      child: CircularCountDownTimer(
                        isTimerTextShown: false,
                        duration: 15,
                        fillColor: constantColors.blueColor,
                        height: 20.0,
                        width: 20.0,
                        color: constantColors.darkColor,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          return showMenu(
                              context: context,
                              position: RelativeRect.fromLTRB(300, 70, 0, 0),
                              color: constantColors.darkColor,
                              items: [
                                PopupMenuItem(
                                  child: TextButton.icon(
                                      onPressed: () {
                                        storyWidgets.addToHighLights(
                                            context, widget.snapshot['image']);
                                      },
                                      icon: Icon(
                                        FontAwesomeIcons.archive,
                                        color: constantColors.blueColor,
                                      ),
                                      label: Text(
                                        'Add to highlights',
                                        style: TextStyle(
                                          color: constantColors.blueColor,
                                        ),
                                      )),
                                ),
                                PopupMenuItem(
                                  child: TextButton.icon(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('stories')
                                            .doc(Provider.of<Authentication>(
                                                    context,
                                                    listen: false)
                                                .userUid)
                                            .delete()
                                            .whenComplete(() {
                                          Navigator.pushReplacement(
                                              context,
                                              PageTransition(
                                                  child: HomePage(),
                                                  type: PageTransitionType
                                                      .bottomToTop));
                                        });
                                      },
                                      icon: Icon(
                                        FontAwesomeIcons.archive,
                                        color: constantColors.redColor,
                                      ),
                                      label: Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: constantColors.redColor,
                                        ),
                                      )),
                                )
                              ]);
                        },
                        icon: Icon(
                          EvaIcons.moreVertical,
                          color: constantColors.whiteColor,
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
