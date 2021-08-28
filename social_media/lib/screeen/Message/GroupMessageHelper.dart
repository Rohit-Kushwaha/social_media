import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_media/constants/Constantcolors.dart';
import 'package:social_media/screeen/HomePage/homePage.dart';
import 'package:social_media/services/Authentication.dart';
import 'package:social_media/services/FirebaseOperation.dart';
import 'package:timeago/timeago.dart' as timeago;

class GroupMessageHelper with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  bool hasMemberJoined = false;

  bool get getHasMemberJoined => hasMemberJoined;
  String lastMessageTime;

  String get getLastMessageTime => lastMessageTime;

  leaveTheRoom(BuildContext context, String chatroomName) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: constantColors.darkColor,
            title: Text(
              'Leave $chatroomName',
              style: TextStyle(
                color: constantColors.whiteColor,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'No',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: constantColors.whiteColor,
                    color: constantColors.whiteColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                 FirebaseFirestore.instance.collection('chatrooms').doc(
                   chatroomName
                 ).collection('members').doc(
                   Provider.of<Authentication>(context,listen:false).getUserid
                 ).delete().whenComplete(() {
                   Navigator.pushReplacement(context, PageTransition(child: HomePage(),
                       type: PageTransitionType.bottomToTop));
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
              )
            ],
          );
        });
  }

  showMessages(
      BuildContext context, DocumentSnapshot snapshot, String adminUserUid) {
    return StreamBuilder<QuerySnapshot>(
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
          } else {
            return new ListView(
              reverse: true,
              children: snapshot.data.docs.map((DocumentSnapshot snapshot) {
                showLastMessageTime(snapshot['time']);
                return Container(
                    height: snapshot['message'] != null
                        ? MediaQuery.of(context).size.height * .13
                        : MediaQuery.of(context).size.height * .26,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 60.0, top: 20),
                          child: Row(
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxHeight: snapshot['message'] != null
                                      ? MediaQuery.of(context).size.height * 0.1
                                      : MediaQuery.of(context).size.height *
                                          0.4,
                                  maxWidth: snapshot['message'] != null
                                      ? MediaQuery.of(context).size.width * .8
                                      : MediaQuery.of(context).size.width * .9,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 18.0,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 100,
                                        child: Row(
                                          children: [
                                            Text(
                                              snapshot['username'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0,
                                                color:
                                                    constantColors.greenColor,
                                              ),
                                            ),
                                            Provider.of<Authentication>(context,
                                                            listen: false)
                                                        .userUid ==
                                                    adminUserUid
                                                ? Icon(
                                                    FontAwesomeIcons.chessKing,
                                                    size: 12,
                                                    color: constantColors
                                                        .yellowColor)
                                                : Container(
                                                    height: 0.0, width: 0.0),
                                          ],
                                        ),
                                      ),
                                      snapshot['message'] != null
                                          ? Text(
                                              snapshot['message'],
                                              style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : Container(
                                              height: 100,
                                              width: 100,
                                              child: Image.network(
                                                  snapshot['sticker'])),
                                      Container(
                                        width: 80,
                                        child: Text(
                                          getLastMessageTime,
                                          style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontSize: 10.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Provider.of<Authentication>(context,
                                                    listen: false)
                                                .userUid ==
                                            snapshot['useruid']
                                        ? constantColors.redColor
                                            .withOpacity(0.6)
                                        : constantColors.blueGreyColor),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 5.0,
                          top: 8.5,
                          child: Provider.of<Authentication>(context,
                                          listen: false)
                                      .getUserid ==
                                  snapshot['useruid']
                              ? Container(
                                  child: Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.edit,
                                          color: constantColors.blueColor,
                                          size: 14.0,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          FontAwesomeIcons.trashAlt,
                                          color: constantColors.redColor,
                                          size: 14.0,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Container(
                                  height: 0.0,
                                  width: 0.0,
                                ),
                        ),
                        Positioned(
                            left: 40,
                            top: 5,
                            child: Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserid ==
                                    snapshot['useruid']
                                ? Container(
                                    width: 0.0,
                                    height: 0.0,
                                  )
                                : CircleAvatar(
                                    backgroundColor: constantColors.darkColor,
                                    backgroundImage:
                                        NetworkImage(snapshot['userimage']),
                                  )),
                      ],
                    ));
              }).toList(),
            );
          }
        });
  }

  sendMessage(BuildContext context, DocumentSnapshot snapshot,
      TextEditingController messageController) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(snapshot.id)
        .collection('messages')
        .add({
      'message': messageController.text,
      'time': Timestamp.now(),
      'useruid': Provider.of<Authentication>(context, listen: false).userUid,
      'username':
          Provider.of<FirebaseOperation>(context, listen: false).initUserName,
      'useremail':
          Provider.of<FirebaseOperation>(context, listen: false).initUserEmail,
      'userimage':
          Provider.of<FirebaseOperation>(context, listen: false).initUserImage,
    });
  }

  Future checkIfJoinMethod(BuildContext context, String chatRoomName,
      String chatRoomAdminUid) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomName)
        .collection('members')
        .doc(Provider.of<Authentication>(context, listen: false).userUid)
        .get()
        .then((value) {
      hasMemberJoined = false;
      print('Intial State => $hasMemberJoined');
      if (value.data()['joined'] != null) {
        hasMemberJoined = value.data()['joined'];
        print('Final State => $hasMemberJoined');
        notifyListeners();
      }
      if (Provider.of<Authentication>(context, listen: false).userUid ==
          chatRoomAdminUid) {
        hasMemberJoined = true;
        notifyListeners();
      }
      ;
    });
  }

  askToJoin(BuildContext context, String roomName) {
    return showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            backgroundColor: constantColors.darkColor,
            title: Text(
              'Join $roomName?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: constantColors.whiteColor,
              ),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: HomePage(),
                          type: PageTransitionType.bottomToTop));
                },
                child: Text(
                  'No',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    decoration: TextDecoration.underline,
                    decorationColor: constantColors.whiteColor,
                    color: constantColors.whiteColor,
                  ),
                ),
              ),
              MaterialButton(
                color: constantColors.blueColor,
                onPressed: () async {
                  FirebaseFirestore.instance
                      .collection('chatrooms')
                      .doc(roomName)
                      .collection('members')
                      .doc(Provider.of<Authentication>(context, listen: false)
                          .userUid)
                      .set({
                    'joined': true,
                    'username':
                        Provider.of<FirebaseOperation>(context, listen: false)
                            .initUserName,
                    'userimage':
                        Provider.of<FirebaseOperation>(context, listen: false)
                            .initUserEmail,
                    'useruid':
                        Provider.of<Authentication>(context, listen: false)
                            .userUid,
                    'time': Timestamp.now(),
                  }).whenComplete(() {
                    Navigator.pop(context);
                  });
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    color: constantColors.whiteColor,
                  ),
                ),
              ),
            ],
          );
        });
  }

  showSticker(BuildContext context, String chatroomid) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.easeIn,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 105.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .1,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border:
                                Border.all(color: constantColors.blueColor)),
                        height: 30.0,
                        width: 30.0,
                        child: Image.asset('assets/icons/sunflower.png'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .3,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('stickers')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return new GridView(
                          children: snapshot.data.docs
                              .map<Widget>((DocumentSnapshot snapshot) {
                            return GestureDetector(
                              onTap: () {
                                // sendStickers(
                                //     context, snapshot['image'], chatroomid);
                                // print(snapshot['image']);
                              },
                              child: Container(
                                height: 40.0,
                                width: 40.0,
                                child: Image.network(snapshot['image']),
                              ),
                            );
                          }).toList(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height * .5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                )),
          );
        });
  }

  // sendStickers(
  //     BuildContext context, String stickerImageUrl, String chatRoomId) async {
  //   await FirebaseFirestore.instance
  //       .collection('chatrooms')
  //       .doc(chatRoomId)
  //       .collection('messages').add({
  //        'sticker': stickerImageUrl,
  //     // 'username': Provider.of<FirebaseOperation>(context, listen: false).initUserName,
  //     // 'userimage': Provider.of<FirebaseOperation>(context, listen: false).initUserImage,
  //     'time': Timestamp.now(),
  //   }
  //   );
  // }

  showLastMessageTime(dynamic timeData) {
    Timestamp time = timeData;
    DateTime dateTime = time.toDate();
    lastMessageTime = timeago.format(dateTime);
    print(lastMessageTime);
    notifyListeners();
  }
}
