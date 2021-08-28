import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_media/constants/Constantcolors.dart';
import 'package:social_media/screeen/HomePage/homePage.dart';
import 'package:social_media/services/Authentication.dart';
import 'package:social_media/services/FirebaseOperation.dart';
import 'package:social_media/utils/PostOptions.dart';

import 'alt_profile.dart';

class AltProfileHelper with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  Widget appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_rounded),
        color: constantColors.whiteColor,
        onPressed: () {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: HomePage(), type: PageTransitionType.bottomToTop));
        },
      ),
      backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(EvaIcons.moreVertical),
          color: constantColors.whiteColor,
          onPressed: () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: HomePage(), type: PageTransitionType.bottomToTop));
          },
        ),
      ],
      title: RichText(
        text: TextSpan(
          text: 'The',
          style: TextStyle(
            color: constantColors.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'Social',
              style: TextStyle(
                color: constantColors.blueColor,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget headerProfile(BuildContext context,
      AsyncSnapshot<DocumentSnapshot> snapshot, String userUid) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 200.0,
                width: 180.0,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: CircleAvatar(
                        backgroundColor: constantColors.transperant,
                        radius: 60.0,
                        backgroundImage:
                            NetworkImage(snapshot.data['userimage']),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        snapshot.data['username'],
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 19.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            EvaIcons.email,
                            color: constantColors.greenColor,
                            size: 16.0,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              snapshot.data['useremail'],
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              checkFollowerSheet(context, snapshot);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: constantColors.darkColor,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              height: 70.0,
                              width: 70.0,
                              child: Column(
                                children: [
                                  Text(
                                    '0',
                                    style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontSize: 28.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Followers',
                                    style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: constantColors.darkColor,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            height: 70.0,
                            width: 70.0,
                            child: Column(
                              children: [
                                StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(snapshot.data['useruid'])
                                        .collection('followers')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        return new Text(
                                          snapshot.data.docs.length.toString(),
                                          style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontSize: 28.0,
                                              fontWeight: FontWeight.bold),
                                        );
                                      }
                                    }),
                                Text(
                                  'Following',
                                  style: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: constantColors.darkColor,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        height: 70.0,
                        width: 80.0,
                        child: Column(
                          children: [
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(snapshot.data['useruid'])
                                    .collection('following')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    return new Text(
                                      snapshot.data.docs.length.toString(),
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontSize: 28.0,
                                          fontWeight: FontWeight.bold),
                                    );
                                  }
                                }),
                            Text(
                              'Posts',
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: () {
                    Provider.of<FirebaseOperation>(context, listen: false)
                        .followUser(
                            userUid,
                            Provider.of<Authentication>(context, listen: false)
                                .userUid,
                            {
                              'username': Provider.of<FirebaseOperation>(
                                      context,
                                      listen: false)
                                  .initUserName,
                              'useremail': Provider.of<FirebaseOperation>(
                                      context,
                                      listen: false)
                                  .initUserEmail,
                              'userimage': Provider.of<FirebaseOperation>(
                                      context,
                                      listen: false)
                                  .initUserImage,
                              'useruid': Provider.of<Authentication>(context,
                                      listen: false)
                                  .userUid,
                              'time': Timestamp.now(),
                            },
                            Provider.of<Authentication>(context, listen: false)
                                .userUid,
                            userUid,
                            {
                              'username': snapshot.data['username'],
                              'useremail': snapshot.data['useremail'],
                              'userimage': snapshot.data['userimage'],
                              'useruid': snapshot.data['useruid'],
                              'time': Timestamp.now(),
                            })
                        .whenComplete(() {
                      followedNotification(context, snapshot.data['username']);
                    });
                  },
                  color: constantColors.blueColor,
                  child: Text(
                    'Follow',
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {},
                  color: constantColors.blueColor,
                  child: Text(
                    'Message',
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  divider() {
    return Center(
      child: SizedBox(
        height: 25.0,
        width: 350.0,
        child: Divider(color: constantColors.whiteColor),
      ),
    );
  }

  Widget middleProfile(BuildContext context, dynamic snapshot) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(2.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(FontAwesomeIcons.userAstronaut,
                    color: constantColors.yellowColor, size: 15.0),
                Text(
                  'Recently Added',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: constantColors.whiteColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * .1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor.withOpacity(.4),
              borderRadius: BorderRadius.circular(15.0),
            ),
          )
        ],
      ),
    );
  }

  Widget footerProfile(BuildContext context, dynamic snapshot) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(snapshot.data['useruid'])
              .
              // doc(Provider.of<Authentication>(context,listen: false).userUid).
              collection('posts')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return new GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  children: snapshot.data.docs.map((DocumentSnapshot snapshot) {
                    return GestureDetector(
                      onTap: () {
                        showPostDetails(context, snapshot);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * .5,
                          width: MediaQuery.of(context).size.width,
                          child: FittedBox(
                            child: Image.network(snapshot['postimage']),
                          ),
                        ),
                      ),
                    );
                  }).toList());
            }
          },
        ),
        height: MediaQuery.of(context).size.height * .38,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: constantColors.darkColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  followedNotification(BuildContext context, String name) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      color: constantColors.whiteColor,
                      thickness: 4.0,
                    ),
                  ),
                  Text(
                    'Follwed $name',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  )
                ],
              ),
            ),
            height: MediaQuery.of(context).size.height * .1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0)),
              color: constantColors.darkColor,
            ),
          );
        });
  }

  checkFollowerSheet(BuildContext context, dynamic snapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Container(
                height: MediaQuery.of(context).size.height * .4,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: constantColors.darkColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(snapshot.data['useruid'])
                        .collection('followers')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return new ListView(
                            children: snapshot.data.docs
                                .map((DocumentSnapshot snaphot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return new ListTile(
                              onTap: () {
                                if (snaphot['useruid'] !=
                                    Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserid) {
                                  snaphot['useruid'] ==
                                      Navigator.pushReplacement(
                                          context,
                                          PageTransition(
                                              child: AltProfile(
                                                userUid: snaphot['useruid'],
                                              ),
                                              type: PageTransitionType
                                                  .topToBottom));
                                }
                              },
                              leading: CircleAvatar(
                                backgroundColor: constantColors.darkColor,
                                backgroundImage: NetworkImage(
                                  snaphot['userimage'],
                                ),
                              ),
                              title: Text(
                                snaphot['username'],
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                snaphot['useremail'],
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: constantColors.yellowColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: snaphot['useruid'] ==
                                      Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserid
                                  ? Container(
                                      height: 0.0,
                                      width: 0.0,
                                    )
                                  : MaterialButton(
                                      onPressed: () {},
                                      child: Text(
                                        'Unfollow',
                                        style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0),
                                      ),
                                    ),
                            );
                          }
                        }).toList());
                      }
                    }),
              ));
        });
  }

  showPostDetails(BuildContext context, DocumentSnapshot snapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              height: MediaQuery.of(context).size.height * .55,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * .28,
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(
                        child: Image.network(snapshot['postimage']),
                      )),
                  Text(
                    snapshot['caption'],
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 70,
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onLongPress: () {
                                      Provider.of<PostFunctions>(context,
                                              listen: false)
                                          .showLikes(
                                              context, snapshot['caption']);
                                    },
                                    onTap: () {
                                      print('Adding Like...');
                                      Provider.of<PostFunctions>(context,
                                              listen: false)
                                          .addLike(
                                              context,
                                              snapshot['caption'],
                                              Provider.of<Authentication>(
                                                      context,
                                                      listen: false)
                                                  .userUid);
                                    },
                                    child: Icon(
                                      FontAwesomeIcons.heart,
                                      color: constantColors.redColor,
                                      size: 22,
                                    ),
                                  ),
                                  StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('posts')
                                          .doc(snapshot['caption'])
                                          .collection('likes')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else {
                                          return Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              snapshot.data.docs.length
                                                  .toString(),
                                              style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0,
                                              ),
                                            ),
                                          );
                                        }
                                      }),
                                ],
                              ),
                            ),
                            Container(
                              width: 70,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Provider.of<PostFunctions>(context,
                                              listen: false)
                                          .showCommentsSheet(context, snapshot,
                                              snapshot['caption']);
                                    },
                                    child: Icon(
                                      FontAwesomeIcons.comment,
                                      color: constantColors.blueColor,
                                      size: 22,
                                    ),
                                  ),
                                  StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('posts')
                                          .doc(snapshot['caption'])
                                          .collection('comment')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else {
                                          return Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              snapshot.data.docs.length
                                                  .toString(),
                                              style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0,
                                              ),
                                            ),
                                          );
                                        }
                                      }),
                                ],
                              ),
                            ),
                            Container(
                              width: 70,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Provider.of<PostFunctions>(context,
                                              listen: false)
                                          .showRewards(
                                              context, snapshot['caption']);
                                    },
                                    child: Icon(
                                      FontAwesomeIcons.award,
                                      color: constantColors.yellowColor,
                                      size: 22,
                                    ),
                                  ),
                                  StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('posts')
                                          .doc(snapshot['caption'])
                                          .collection('awards')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else {
                                          return Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              snapshot.data.docs.length
                                                  .toString(),
                                              style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0,
                                              ),
                                            ),
                                          );
                                        }
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ))
                ],
              ));
        });
  }
}
