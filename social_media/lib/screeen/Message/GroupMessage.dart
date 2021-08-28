import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_media/constants/Constantcolors.dart';
import 'package:social_media/screeen/HomePage/homePage.dart';
import 'package:social_media/screeen/Message/GroupMessageHelper.dart';
import 'package:social_media/services/Authentication.dart';

class GroupMessage extends StatefulWidget {
  final DocumentSnapshot snapshot;

  GroupMessage({Key key, @required this.snapshot}) : super(key: key);

  @override
  _GroupMessageState createState() => _GroupMessageState();
}

class _GroupMessageState extends State<GroupMessage> {
  final ConstantColors constantColors = ConstantColors();
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    Provider.of<GroupMessageHelper>(context, listen: false)
        .checkIfJoinMethod(
            context, widget.snapshot.id, widget.snapshot['useruid'])
        .whenComplete(() async {
      if (Provider.of<GroupMessageHelper>(context, listen: false)
              .getHasMemberJoined ==
          false) {
        Timer(
            Duration(milliseconds: 10),
            () => Provider.of<GroupMessageHelper>(context, listen: false)
                .askToJoin(context, widget.snapshot.id));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<GroupMessageHelper>(context, listen:false).leaveTheRoom(
                    context, widget.snapshot.id);
              },
              icon: Icon(
                EvaIcons.logOutOutline,
                color: constantColors.redColor,
              )),
          Provider.of<Authentication>(context, listen: false).userUid ==
                  widget.snapshot['useruid']
              ? IconButton(
                  onPressed: () {},
                  icon: Icon(
                    EvaIcons.moreVertical,
                    color: constantColors.whiteColor,
                  ))
              : Container(
                  height: 0.0,
                  width: 0.0,
                )
        ],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: constantColors.whiteColor,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: HomePage(), type: PageTransitionType.leftToRight));
          },
        ),
        backgroundColor: constantColors.darkColor.withOpacity(0.5),
        title: Container(
          width: MediaQuery.of(context).size.width * .85,
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.snapshot['roomavatar']),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.snapshot['roomname'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: constantColors.whiteColor,
                      ),
                    ),
                   StreamBuilder<QuerySnapshot>(
                     stream: FirebaseFirestore.instance.collection('chatrooms').doc(
                       widget.snapshot.id
                     ).collection('members').snapshots(),
                     builder: (context,snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }else{
                        return new Text('${snapshot.data.docs.length.toString()} members',
                          style: TextStyle(
                            color: constantColors.greenColor.withOpacity(0.5),
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0
                          ),
                        );
                      }
                     },
                   )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              AnimatedContainer(
                child: Provider.of<GroupMessageHelper>(context, listen: false)
                    .showMessages(
                        context, widget.snapshot, widget.snapshot['useruid']),
                height: MediaQuery.of(context).size.height * .8,
                width: MediaQuery.of(context).size.width,
                duration: Duration(seconds: 1),
                curve: Curves.bounceIn,
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Provider.of<GroupMessageHelper>(context,listen: false)
                               .showSticker(context,widget.snapshot.id);
                        },
                        child: CircleAvatar(
                          radius: 18.0,
                          backgroundColor: constantColors.transperant,
                          backgroundImage:
                              AssetImage('assets/icons/sunflower.png'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextField(
                            controller: messageController,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: constantColors.whiteColor,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Drop a hi...',
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                  color: constantColors.greenColor),
                            ),
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          if (messageController.text.isNotEmpty) {
                            Provider.of<GroupMessageHelper>(context,
                                    listen: false)
                                .sendMessage(context, widget.snapshot,
                                    messageController);
                          }
                        },
                        backgroundColor: constantColors.blueColor,
                        child: Icon(
                          Icons.send_sharp,
                          color: constantColors.whiteColor,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
