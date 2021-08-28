import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_media/constants/Constantcolors.dart';
import 'package:social_media/screeen/AltProfile/alt_profile.dart';
import 'package:social_media/services/Authentication.dart';
import 'package:social_media/services/FirebaseOperation.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostFunctions with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  TextEditingController commentController = TextEditingController();
  TextEditingController updateCaptionController = TextEditingController();
  String imageTimePosted;

  String get getImagaeTimePosted => imageTimePosted;

  showTimeAgo(dynamic timedata) {
    Timestamp time = timedata;
    DateTime dateTime = time.toDate();
    imageTimePosted = timeago.format(dateTime);
    print(imageTimePosted);
    notifyListeners();
  }

  showPostOptions(BuildContext context, String postId) {
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
                    padding: EdgeInsets.symmetric(horizontal: 150),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          color: constantColors.blueColor,
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    child: Center(
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 300,
                                            height: 50,
                                            child: TextField(
                                              decoration: InputDecoration(
                                                hintText: 'Add New Caption',
                                                hintStyle: TextStyle(
                                                  color:
                                                      constantColors.whiteColor,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              controller:
                                                  updateCaptionController,
                                            ),
                                          ),
                                          FloatingActionButton(
                                            onPressed: () {
                                              Provider.of<FirebaseOperation>(
                                                      context,
                                                      listen: false)
                                                  .updateCaption(postId, {
                                                'caption':
                                                    updateCaptionController.text
                                              });
                                            },
                                            backgroundColor:
                                                constantColors.whiteColor,
                                            child: Icon(
                                                FontAwesomeIcons.fileUpload,
                                                color:
                                                    constantColors.whiteColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Text(
                            'Edit Captions',
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        MaterialButton(
                          color: constantColors.redColor,
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: constantColors.darkColor,
                                    title: Text('Delete this post?',
                                        style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        )),
                                    actions: [
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'No',
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor:
                                                constantColors.whiteColor,
                                            color: constantColors.whiteColor,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      MaterialButton(
                                        color: constantColors.redColor,
                                        onPressed: () {
                                          Provider.of<FirebaseOperation>(
                                                  context,
                                                  listen: false)
                                              .deleteUserData(postId, 'posts')
                                              .whenComplete(() {
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Text(
                            'Delete Post',
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              height: MediaQuery.of(context).size.height * .1,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12.0),
                    topLeft: Radius.circular(12.0)),
              ),
            ),
          );
        });
  }

  Future addLike(BuildContext context, String postId, String subDocId) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(subDocId)
        .set({
      'likes': FieldValue.increment(1),
      'username':
          Provider.of<FirebaseOperation>(context, listen: false).initUserName,
      'useremail':
          Provider.of<FirebaseOperation>(context, listen: false).initUserEmail,
      'userimage':
          Provider.of<FirebaseOperation>(context, listen: false).initUserImage,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserid,
      'time': Timestamp.now()
    });
  }

  Future addComment(BuildContext context, String postId, String comment) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comment')
        .doc(comment)
        .set({
      'comment': comment,
      'username':
          Provider.of<FirebaseOperation>(context, listen: false).initUserName,
      'useremail':
          Provider.of<FirebaseOperation>(context, listen: false).initUserEmail,
      'userimage':
          Provider.of<FirebaseOperation>(context, listen: false).initUserImage,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserid,
      'time': Timestamp.now()
    });
  }

  showCommentsSheet(
      BuildContext context, DocumentSnapshot documentSnapshot, String docId) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * .79,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Container(
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: constantColors.whiteColor),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        'Comments',
                        style: TextStyle(
                          color: constantColors.blueColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .65,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(docId)
                          .collection('comment')
                          .orderBy('time')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return new ListView(
                              children: snapshot.data.docs
                                  .map((DocumentSnapshot documentSnapshot) {
                            return Container(
                              height: MediaQuery.of(context).size.height * .15,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                              context,
                                              PageTransition(
                                                  child: AltProfile(
                                                    userUid: documentSnapshot[
                                                        'useruid'],
                                                  ),
                                                  type: PageTransitionType
                                                      .leftToRight));
                                        },
                                        child: CircleAvatar(
                                          backgroundColor:
                                              constantColors.darkColor,
                                          radius: 15,
                                          backgroundImage: NetworkImage(
                                            documentSnapshot['userimage'],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(),
                                        child: Container(
                                          child: Text(
                                            documentSnapshot['username'],
                                            style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            IconButton(
                                                icon: Icon(
                                                  FontAwesomeIcons.arrowUp,
                                                  color:
                                                      constantColors.blueColor,
                                                  size: 12.0,
                                                ),
                                                onPressed: () {}),
                                            Text(
                                              '0',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.0,
                                                color: constantColors.blueColor,
                                              ),
                                            ),
                                            IconButton(
                                                icon: Icon(
                                                  FontAwesomeIcons.reply,
                                                  color: constantColors
                                                      .yellowColor,
                                                  size: 12.0,
                                                ),
                                                onPressed: () {}),
                                            IconButton(
                                                icon: Icon(
                                                  FontAwesomeIcons.trashAlt,
                                                  color:
                                                      constantColors.redColor,
                                                  size: 12.0,
                                                ),
                                                onPressed: () {}),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      children: [
                                        IconButton(
                                            icon: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              color: constantColors.blueColor,
                                              size: 12,
                                            ),
                                            onPressed: () {}),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.75,
                                          child: Text(
                                            documentSnapshot['comment'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0,
                                              color: constantColors.whiteColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          }).toList());
                        }
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 300.0,
                          height: 20.0,
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              hintText: 'Add comment',
                              hintStyle: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            controller: commentController,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: constantColors.whiteColor,
                            ),
                          ),
                        ),
                        FloatingActionButton(
                            backgroundColor: constantColors.greenColor,
                            child: Icon(
                              FontAwesomeIcons.comment,
                              color: constantColors.greyColor,
                            ),
                            onPressed: () {
                              print('Adding comment');
                              addComment(context, documentSnapshot['caption'],
                                      commentController.text)
                                  .whenComplete(() {
                                commentController.clear();
                                notifyListeners();
                              });
                            })
                      ],
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0))),
            ),
          );
        });
  }

  showLikes(BuildContext context, String postId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: constantColors.whiteColor),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Text(
                      'Likes',
                      style: TextStyle(
                        color: constantColors.blueColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                Container(
                    height: MediaQuery.of(context).size.height * .2,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(postId)
                          .collection('likes')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return new ListView(
                            children: snapshot.data.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return ListTile(
                                leading: GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                            child: AltProfile(
                                              userUid:
                                                  documentSnapshot['useruid'],
                                            ),
                                            type: PageTransitionType
                                                .leftToRight));
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        documentSnapshot['userimage']),
                                  ),
                                ),
                                title: Text(
                                  documentSnapshot['username'],
                                  style: TextStyle(
                                      color: constantColors.blueColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                                subtitle: Text(
                                  documentSnapshot['useremail'],
                                  style: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                                trailing: Provider.of<Authentication>(context,
                                                listen: false)
                                            .userUid ==
                                        documentSnapshot['useruid']
                                    ? Container(width: 0.0, height: 0.0)
                                    : MaterialButton(
                                        color: constantColors.blueColor,
                                        onPressed: () {},
                                        child: Text(
                                          'Follow',
                                          style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0),
                                        ),
                                      ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    )),
              ],
            ),
            height: MediaQuery.of(context).size.height * .50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: BorderRadius.circular(15.0),
            ),
          );
        });
  }

  showRewards(BuildContext context, String postId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: constantColors.whiteColor),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Text(
                      'Rewards',
                      style: TextStyle(
                        color: constantColors.blueColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .1,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('awards')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return new ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data.docs
                              .map((DocumentSnapshot snapshot) {
                            return GestureDetector(
                              onTap: () async {
                                print(snapshot['image']);
                                await Provider.of<FirebaseOperation>(context,
                                        listen: false)
                                    .addRewards(postId, {
                                  'username': Provider.of<FirebaseOperation>(
                                          context,
                                          listen: false)
                                      .initUserName,
                                  'userimage': Provider.of<FirebaseOperation>(
                                          context,
                                          listen: false)
                                      .initUserImage,
                                  'useruid': Provider.of<Authentication>(
                                          context,
                                          listen: false)
                                      .userUid,
                                  'time': Timestamp.now(),
                                  'awards': snapshot['image'],
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Container(
                                  height: 50.0,
                                  width: 50.0,
                                  child: Image.network(snapshot['image']),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height * .2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: BorderRadius.circular(15.0),
            ),
          );
        });
  }
}
