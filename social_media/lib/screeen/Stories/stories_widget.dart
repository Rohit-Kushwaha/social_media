import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_media/constants/Constantcolors.dart';
import 'package:social_media/screeen/AltProfile/alt_profile.dart';
import 'package:social_media/screeen/HomePage/homePage.dart';
import 'package:social_media/screeen/Stories/stories.dart';
import 'package:social_media/screeen/Stories/storiesHelper.dart';
import 'package:social_media/services/Authentication.dart';
import 'package:social_media/services/FirebaseOperation.dart';

class StoryWidgets {
  final ConstantColors constantColors = new ConstantColors();
  final TextEditingController storyHighlightTitleController =
      TextEditingController();

  addStory(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    color: constantColors.whiteColor,
                    thickness: 4.0,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: constantColors.blueColor,
                      onPressed: () {
                        Provider.of<StoriesHelper>(context, listen: false)
                            .selectStoriesImage(context, ImageSource.gallery)
                            .whenComplete(() {});
                      },
                      child: Text(
                        'Gallery',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: constantColors.whiteColor),
                      ),
                    ),
                    MaterialButton(
                      color: constantColors.blueColor,
                      onPressed: () {
                        Provider.of<StoriesHelper>(context, listen: false)
                            .selectStoriesImage(context, ImageSource.gallery)
                            .whenComplete(() {
                          Navigator.pop(context);
                        });
                      },
                      child: Text(
                        'Camera',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: constantColors.whiteColor),
                      ),
                    )
                  ],
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height * .1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
          );
        });
  }

  previewStoryImage(BuildContext context, File storyImage) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 1.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor,
            ),
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Image.file(storyImage),
                ),
                Positioned(
                    top: 650.0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FloatingActionButton(
                            onPressed: () {
                              addStory(context);
                            },
                            heroTag: 'Reselect Image',
                            backgroundColor: constantColors.redColor,
                            child: Icon(
                              FontAwesomeIcons.backspace,
                              color: constantColors.whiteColor,
                            ),
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              Provider.of<StoriesHelper>(context, listen: false)
                                  .uploadStoryImage(context)
                                  .whenComplete(() async {
                                try {
                                  if (Provider.of<StoriesHelper>(context,
                                              listen: false)
                                          .getStoryImageUrl !=
                                      null) {
                                    await FirebaseFirestore.instance
                                        .collection('stories')
                                        .doc(Provider.of<Authentication>(
                                                context,
                                                listen: false)
                                            .userUid)
                                        .set({
                                      'image': Provider.of<StoriesHelper>(
                                              context,
                                              listen: false)
                                          .getStoryImageUrl,
                                      'username':
                                          Provider.of<FirebaseOperation>(
                                                  context,
                                                  listen: false)
                                              .initUserName,
                                      'userimage':
                                          Provider.of<FirebaseOperation>(
                                                  context,
                                                  listen: false)
                                              .initUserImage,
                                      'useruid': Provider.of<Authentication>(
                                              context,
                                              listen: false)
                                          .userUid,
                                      'time': Timestamp.now(),
                                    }).whenComplete(() {
                                      Navigator.pushReplacement(
                                          context,
                                          PageTransition(
                                              child: HomePage(),
                                              type: PageTransitionType
                                                  .bottomToTop));
                                    });
                                  } else {
                                    return showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: constantColors.darkColor,
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            child: Center(
                                              child: MaterialButton(
                                                onPressed: () async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('stories')
                                                      .doc(Provider.of<
                                                                  Authentication>(
                                                              context,
                                                              listen: false)
                                                          .userUid)
                                                      .set({
                                                    'image': Provider.of<
                                                                StoriesHelper>(
                                                            context,
                                                            listen: false)
                                                        .getStoryImageUrl,
                                                    'username': Provider.of<
                                                                FirebaseOperation>(
                                                            context,
                                                            listen: false)
                                                        .initUserName,
                                                    'userimage': Provider.of<
                                                                FirebaseOperation>(
                                                            context,
                                                            listen: false)
                                                        .initUserImage,
                                                    'useruid': Provider.of<
                                                                Authentication>(
                                                            context,
                                                            listen: false)
                                                        .userUid,
                                                    'time': Timestamp.now(),
                                                  }).whenComplete(() {
                                                    Navigator.pushReplacement(
                                                        context,
                                                        PageTransition(
                                                            child: HomePage(),
                                                            type: PageTransitionType
                                                                .bottomToTop));
                                                  });
                                                },
                                                child: Text(
                                                  'Upload Story',
                                                  style: TextStyle(
                                                      color: constantColors
                                                          .whiteColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16.0),
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  }
                                } catch (e) {
                                  print(e.toString());
                                }
                              });
                            },
                            heroTag: 'Confirm Image',
                            backgroundColor: constantColors.blueColor,
                            child: Icon(
                              FontAwesomeIcons.check,
                              color: constantColors.whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          );
        });
  }

  addToHighLights(BuildContext context, String storyImage) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Text(
                    'Add to Existing Album',
                    style: TextStyle(
                        color: constantColors.yellowColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(Provider.of<Authentication>(context,
                                  listen: false)
                              .userUid)
                          .collection('highlights')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return new ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data.docs
                                .map((DocumentSnapshot snapshot) {
                              return GestureDetector(
                                  onTap: () {
                                    Provider.of<StoriesHelper>(context,listen:false).addStoryToExistingAlbum(
                                        context,
                                        Provider.of<Authentication>(context,listen: false).userUid,
                                        snapshot.id, storyImage);
                                  },
                                  child: (Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                                constantColors.darkColor,
                                            backgroundImage: NetworkImage(
                                              snapshot['cover'],
                                            ),
                                            radius: 20,
                                          ),
                                          Text(
                                            snapshot['title'],
                                            style: TextStyle(
                                                color:
                                                    constantColors.greenColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )));
                            }).toList(),
                          );
                        }
                      },
                    ),
                    height: MediaQuery.of(context).size.height * .1,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Text(
                    'Create New Album',
                    style: TextStyle(
                        color: constantColors.greenColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .1,
                    width: MediaQuery.of(context).size.width,
                    color: constantColors.redColor,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('chatroomIcons')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return ListView(
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data.docs
                                  .map((DocumentSnapshot snapshot) {
                                return GestureDetector(
                                  onTap: () {
                                    Provider.of<StoriesHelper>(context,
                                            listen: false)
                                        .convertHighlightedIcon(
                                            snapshot['image']);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Container(
                                        height: 50.0,
                                        width: 50.0,
                                        child:
                                            Image.network(snapshot['image'])),
                                  ),
                                );
                              }).toList(),
                            );
                          }
                        }),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .1,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * .8,
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: storyHighlightTitleController,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: constantColors.whiteColor),
                            decoration: InputDecoration(
                              hintText: 'Add Album Titile',
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: constantColors.blueColor),
                            ),
                          ),
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            if (storyHighlightTitleController.text.isNotEmpty) {
                              Provider.of<StoriesHelper>(context, listen: false)
                                  .addStoryToNewAlbum(
                                      context,
                                      Provider.of<Authentication>(context,
                                              listen: false)
                                          .userUid,
                                      storyHighlightTitleController.text,
                                      storyImage);
                            } else {
                              return showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      color: constantColors.darkColor,
                                      child: Center(
                                        child: Text(
                                          'Add album title',
                                          style: TextStyle(
                                              color: constantColors.whiteColor),
                                        ),
                                      ),
                                      height: 100,
                                      width: 400,
                                      // height: MediaQuery.of(context).size.height,
                                      // width: MediaQuery.of(context).size.width,
                                      // decoration: BoxDecoration(
                                      //   borderRadius: BorderRadius.circular(12.0),
                                      //   color: constantColors.darkColor,
                                      // ),
                                    );
                                  });
                            }
                          },
                          backgroundColor: constantColors.blueColor,
                          child: Icon(
                            FontAwesomeIcons.check,
                            color: constantColors.whiteColor,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              height: MediaQuery.of(context).size.height * .4,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: constantColors.darkColor,
              ),
            ),
          );
        });
  }

  showViewers(BuildContext context, String storyId, String personUid) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .4,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('stories')
                        .doc(storyId)
                        .collection('seen')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return new ListView(
                          children: snapshot.data.docs
                              .map((DocumentSnapshot snapshot) {
                            Provider.of<StoriesHelper>(context, listen: false)
                                .storyTimePosted(snapshot['time']);
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: constantColors.darkColor,
                                radius: 25.0,
                                backgroundImage:
                                    NetworkImage(snapshot['userimage']),
                              ),
                              title: Text(
                                snapshot['username'],
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          child: AltProfile(
                                            userUid: snapshot['useruid'],
                                          ),
                                          type:
                                              PageTransitionType.bottomToTop));
                                },
                                icon: Icon(
                                  FontAwesomeIcons.arrowCircleRight,
                                  color: constantColors.yellowColor,
                                ),
                              ),
                              subtitle: Text(
                                Provider.of<StoriesHelper>(context,
                                        listen: false)
                                    .getlastSeenTime
                                    .toString(),
                                style: TextStyle(
                                    color: constantColors.greenColor,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * .5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
          );
        });
  }

  previewAllHighlights(BuildContext context, String highlightTitle) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(Provider.of<Authentication>(context, listen: false)
                      .userUid)
                  .collection('highlights')
                  .doc(highlightTitle)
                  .collection('stories')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return new PageView(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot snapshot) {
                      return Container(
                        decoration: BoxDecoration(
                          color: constantColors.darkColor,
                        ),
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(snapshot['image']),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          );
        });
  }
}
