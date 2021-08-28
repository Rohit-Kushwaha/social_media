import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_media/constants/Constantcolors.dart';
import 'package:social_media/screeen/AltProfile/alt_profile.dart';
import 'package:social_media/screeen/LandingPage/landingPage.dart';
import 'package:social_media/screeen/Stories/storiesHelper.dart';
import 'package:social_media/screeen/Stories/stories_widget.dart';
import 'package:social_media/services/Authentication.dart';
import 'package:social_media/utils/PostOptions.dart';

class ProfileHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
 final StoryWidgets storyWidgets = StoryWidgets();
  Widget headerProfile(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 200.0,
            width: 180.0,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: GestureDetector(
                    onTap: (){
                  storyWidgets.addStory(context);
                    },
                    child: Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: constantColors.transperant,
                          radius: 60.0,
                          backgroundImage:
                              NetworkImage(snapshot.data['userimage']),
                        ),
                        Positioned(
                          top: 90.0,
                            left: 90.0,
                            child: Icon(
                          FontAwesomeIcons.plusCircle,
                          color: constantColors.whiteColor,
                        ))
                      ],
                    ),
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
                              'Followers',
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          checkFollowingSheet(context, snapshot);
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
                                'Following',
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
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
                        Text(
                          '0',
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold),
                        ),
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
    );
  }

  Widget divider() {
    return Center(
      child: SizedBox(
        height: 25.0,
        width: 350.0,
        child: Divider(color: constantColors.whiteColor),
      ),
    );
  }

  Widget middleProfile(BuildContext context, dynamic snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 150,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(2.0)),
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
                child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('users').doc(
                  Provider.of<Authentication>(context,listen: false).getUserid
                ).collection('highlights').snapshots(),
                  builder: (context,snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }else{
                    return new ListView(
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data.docs.map((DocumentSnapshot snapshot){
                      return GestureDetector(
                        onTap: (){
                          storyWidgets.previewAllHighlights(context, snapshot['title']);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height*0.1,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: constantColors.darkColor,
                                  backgroundImage: NetworkImage(
                                    snapshot['cover'],
                                  ),
                                  radius: 20,
                                ),
                                Text(snapshot['title'],style: TextStyle(
                                  color: constantColors.greenColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0
                                ),)
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    );
                  }
                  },
                ),
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: constantColors.darkColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(15.0)
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Container(
                  child: StreamBuilder<QuerySnapshot>(
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
                          return new ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data.docs
                                .map((DocumentSnapshot snaphot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return new Container(
                                  height: 60.0,
                                  width: 60.0,
                                  child: Image.network(snaphot['userimage']),
                                );
                              }
                            }).toList(),
                          );
                        }
                      }),
                  height: MediaQuery.of(context).size.height * .1,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: constantColors.darkColor.withOpacity(.4),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget footerProfile(BuildContext context, dynamic snapshot) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .
              // doc(snapshot.data['useruid']).
              doc(Provider.of<Authentication>(context, listen: false).userUid)
              .collection('posts')
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
                      child: Container(
                        height: MediaQuery.of(context).size.height * .5,
                        width: MediaQuery.of(context).size.width,
                        child: FittedBox(
                          child: Image.network(snapshot['postimage']),
                        ),
                      ),
                    );
                  }).toList());
            }
          },
        ),
        height: MediaQuery.of(context).size.height * .45,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: constantColors.darkColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  logOutDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: constantColors.darkColor,
            title: Text(
              'Log out from the social ',
              style: TextStyle(
                fontSize: 18.0,
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              MaterialButton(
                  child: Text(
                    'No',
                    style: TextStyle(
                        fontSize: 18.0,
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: constantColors.whiteColor),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              MaterialButton(
                  color: constantColors.redColor,
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Provider.of<Authentication>(context, listen: false)
                        .logOutViaEmail()
                        .whenComplete(() {
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: LandingPage(),
                            type: PageTransitionType.bottomToTop),
                      );
                    });
                  }),
            ],
          );
        });
  }

  checkFollowingSheet(BuildContext context, dynamic snapshot) {
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
                        .collection('following')
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
                              trailing: MaterialButton(
                                color: constantColors.blueColor,
                                onPressed: () {},
                                child: Text(
                                  'Unfollow',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: constantColors.whiteColor),
                                ),
                              ),
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        child: AltProfile(
                                          userUid: snaphot['useruid'],
                                        ),
                                        type: PageTransitionType.topToBottom));
                              },
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
