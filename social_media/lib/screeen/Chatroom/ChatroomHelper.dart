import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_media/constants/Constantcolors.dart';
import 'package:social_media/screeen/Message/GroupMessage.dart';
import 'package:social_media/services/Authentication.dart';
import 'package:social_media/services/FirebaseOperation.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatroomHelper with ChangeNotifier {
  String chatRoomAvatarUrl, chatRoomID;
  String latestMessageTime;

  String get getLatestMessageTime => latestMessageTime;

  String get getChatRoomIDUrl => chatRoomID;

  String get getChatRoomAvatarUrl => chatRoomAvatarUrl;
  ConstantColors constantColors = ConstantColors();
  TextEditingController chatRoomController = TextEditingController();

  showChatRoomDetails(BuildContext context, DocumentSnapshot snapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
              padding: EdgeInsets.only(),
              child: Container(
                  height: MediaQuery.of(context).size.height * .3,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: constantColors.blueGreyColor,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12.0),
                        topLeft: Radius.circular(12.0)),
                  ),
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
                        decoration: BoxDecoration(
                          color: constantColors.blueGreyColor,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Members',
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                          ),
                        ),
                      ),
                      Container(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('chatrooms')
                              .doc(snapshot.id)
                              .collection('members')
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
                                    child: CircleAvatar(
                                      backgroundColor: constantColors.darkColor,
                                      // radius: 25.0,
                                      backgroundImage:
                                          NetworkImage(snapshot['userimage']),
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                          },
                        ),
                        height: MediaQuery.of(context).size.height * .08,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: constantColors.blueGreyColor,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          'Admin',
                          style: TextStyle(
                              color: constantColors.yellowColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: constantColors.transperant,
                              backgroundImage:
                                  NetworkImage(snapshot['userimage']),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(snapshot['username'],
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0)),
                                ),
                             Provider.of<Authentication>(context,listen: false).userUid ==
            snapshot['useruid'] ?    Padding(
                               padding: EdgeInsets.only(left: 16.0),
                               child: MaterialButton(
                                 onPressed: () {
                                   return showDialog(
                                       context: context,
                                       builder: (context) {
                                         return AlertDialog(
                                           title: Text('Delete chatroom?', style: TextStyle(
                                               color: constantColors
                                                   .whiteColor,
                                               fontWeight:
                                               FontWeight.bold,
                                               fontSize: 16.0),
                                           ),
                                           backgroundColor: constantColors.darkColor ,
                                           actions: [
                                             MaterialButton(
                                               onPressed: () {
                                                 Navigator.pop(context);
                                               },
                                               child: Text('No',
                                                   style: TextStyle(
                                                       decoration: TextDecoration.underline,
                                                       decorationColor: constantColors.whiteColor,
                                                       color: constantColors
                                                           .whiteColor,
                                                       fontWeight:
                                                       FontWeight.bold,
                                                       fontSize: 16.0)),

                                             ),
                                             MaterialButton(
                                               onPressed: () {
                                                 FirebaseFirestore.instance.collection('chatrooms').doc(
                                                     snapshot.id
                                                 ).delete().whenComplete(() {
                                                   Navigator.pop(context);
                                                 });
                                               },
                                               child: Text('Yes',
                                                   style: TextStyle(
                                                       color: constantColors
                                                           .whiteColor,
                                                       fontWeight:
                                                       FontWeight.bold,
                                                       fontSize: 16.0)),
                                               color: constantColors.redColor,
                                             ),
                                           ],
                                         );
                                       });
                                 },
                                 color: constantColors.redColor,
                                 child: Text(
                                   'Delete',
                                   style: TextStyle(
                                       fontWeight: FontWeight.bold,
                                       fontSize: 16.0,
                                       color: constantColors.whiteColor),
                                 ),
                               ),
                             ): Container(
                               height: 0.0,
                                 width: 0.0,
                             ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )));
        });
  }

  showCreateChatRoomsheet(BuildContext context) {
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
                    'Select chatroom Avatar',
                    style: TextStyle(
                        color: constantColors.greenColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .1,
                    width: MediaQuery.of(context).size.width,
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
                          return new ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data.docs
                                .map((DocumentSnapshot snapshot) {
                              return GestureDetector(
                                onTap: () {
                                  chatRoomAvatarUrl = snapshot['image'];
                                  print(chatRoomAvatarUrl);
                                  notifyListeners();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: chatRoomAvatarUrl ==
                                                  snapshot['image']
                                              ? constantColors.blueColor
                                              : constantColors.transperant),
                                    ),
                                    height: 10,
                                    width: 40,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .7,
                        child: TextField(
                          textCapitalization: TextCapitalization.words,
                          controller: chatRoomController,
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter chatroom id',
                            hintStyle: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () async {
                          Provider.of<FirebaseOperation>(context, listen: false)
                              .submitUserData(chatRoomController.text, {
                            'roomavatar': getChatRoomAvatarUrl,
                            'time': Timestamp.now(),
                            'roomname': chatRoomController.text,
                            'username': Provider.of<FirebaseOperation>(context,
                                    listen: false)
                                .initUserName,
                            'useremail': Provider.of<FirebaseOperation>(context,
                                    listen: false)
                                .initUserEmail,
                            'userimage': Provider.of<FirebaseOperation>(context,
                                    listen: false)
                                .initUserImage,
                            'useruid': Provider.of<Authentication>(context,
                                    listen: false)
                                .userUid,
                          }).whenComplete(() {
                            Navigator.pop(context);
                          });
                        },
                        backgroundColor: constantColors.blueGreyColor,
                        child: Icon(
                          FontAwesomeIcons.plus,
                          color: constantColors.yellowColor,
                        ),
                      )
                    ],
                  )
                ],
              ),
              height: MediaQuery.of(context).size.height * .25,
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

  showChatrooms(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chatrooms').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                height: 200.0,
                width: 200.0,
                child: Lottie.asset('assets/animations/loading.json'),
              ),
            );
          } else {
            return new ListView(
                children:
                    snapshot.data.docs.map<Widget>((DocumentSnapshot snapshot) {
              return ListTile(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: GroupMessage(snapshot: snapshot),
                          type: PageTransitionType.leftToRight));
                },
                onLongPress: () {
                  showChatRoomDetails(context, snapshot);
                },
                title: Text(
                  snapshot['roomname'],
                  style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
                subtitle: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chatrooms')
                      .doc(snapshot.id)
                      .collection('messages')
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.data.docs.first['username'] != null &&
                        snapshot.data.docs.first['message'] != null) {
                      return Text(
                        '${snapshot.data.docs.first['username']} : ${snapshot.data.docs.first['message']}',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: constantColors.greenColor,
                        ),
                      );
                    } else {
                      return new Container(
                        width: 0.0,
                        height: 0.0,
                        // children: snapshot.data.docs
                        //     .map((DocumentSnapshot snapshot) {})
                        //     .toList(),
                      );
                    }
                  },
                ),
                trailing: Container(
                  width: 80.0,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chatrooms')
                          .doc(snapshot.id)
                          .collection('messages')
                          .orderBy('time', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        showLastMessageTime(snapshot.data.docs.first['time']);
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Text(
                            getLatestMessageTime,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10.0,
                                color: constantColors.whiteColor),
                          );
                        }
                      }),
                ),
                leading: CircleAvatar(
                  backgroundColor: constantColors.transperant,
                  backgroundImage: NetworkImage(snapshot['roomavatar']),
                ),
              );
            }).toList());
          }
        });
  }

  showLastMessageTime(dynamic timeData) {
    Timestamp t = timeData;
    DateTime dateTime = t.toDate();
    latestMessageTime = timeago.format(dateTime);
    print(latestMessageTime);
    notifyListeners();
  }
}
