import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_media/constants/Constantcolors.dart';
import 'package:social_media/screeen/AltProfile/alt_profile.dart';
import 'package:social_media/screeen/Stories/stories.dart';
import 'package:social_media/services/Authentication.dart';
import 'package:social_media/utils/PostOptions.dart';
import 'package:social_media/utils/UploadPost.dart';

class FeedHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  Widget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: constantColors.darkColor.withOpacity(0.6),
      centerTitle: true,
      actions: [
        IconButton(
            icon: Icon(
              Icons.camera_enhance_rounded,
              color: constantColors.greenColor,
            ),
            onPressed: () {
              Provider.of<UploadPost>(context, listen: false)
                  .selectPostImageType(context);
            })
      ],
      title: RichText(
        text: TextSpan(
          text: 'Social ',
          style: TextStyle(
            color: constantColors.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'Feed',
              style: TextStyle(
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget feedBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('stories').snapshots(),
                builder: (context,snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }else{
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: snapshot.data.docs.map((DocumentSnapshot snapshot){
                        return GestureDetector(
                          onTap: (){
                            Navigator.pushReplacement(context, PageTransition(child: Stories(
                              snapshot: snapshot,
                            ), type: PageTransitionType.bottomToTop));
                            // print(snapshot['username']);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Container(
                              child: Image.network(snapshot['userimage']),
                              height: 30.0,
                              width: 50.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: constantColors.blueColor,
                                  width: 2.0,
                                )
                              ),
                            ),
                          )
                        );
                      }).toList(),
                    );
                  }
                },
              ),

              height: MediaQuery.of(context).size.height * .06,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
          Padding(
          padding: EdgeInsets.only(top: 4.0),
          child: Container(
            height: MediaQuery
                .of(context)
                .size
                .height * .8,
            width: MediaQuery
                .of(context)
                .size
                .width,
            decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0)),
            ),
            child: StreamBuilder<QuerySnapshot>(
                stream:
                FirebaseFirestore.instance.collection('posts').orderBy('time',descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      // child: CircularProgressIndicator(),
                      child: SizedBox(
                          height: 500.0,
                          width: 400.0,
                          child: Lottie.asset('assets/animations/loading.json')),
                    );
                  } else {
                    return loadPosts(context, snapshot);
                  }
                }
            ),
          ),
        ),
      ],
      ),
    );
  }

Widget loadPosts(
  BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
return ListView(
  children: snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
    Provider.of<PostFunctions>(context,listen: false).showTimeAgo(documentSnapshot['time']);
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.only(top: 8.0, left: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0,left: 8.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      if(documentSnapshot['useruid'] != Provider.of<Authentication>(context,listen:false).userUid)
                      {
                       Navigator.pushReplacement(context, PageTransition(child: AltProfile(userUid: documentSnapshot['useruid'],), type: PageTransitionType.bottomToTop));
                      }
                        else{

                      }
                    },
                    child: CircleAvatar(
                      backgroundColor:
                      constantColors.blueGreyColor,
                      radius: 20.0,
                      backgroundImage: NetworkImage(
                          documentSnapshot.get('userimage')),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Container(
                              child: Text(
                                documentSnapshot.get('caption'),
                                style: TextStyle(
                                  color: constantColors.greenColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Container(
                                child: RichText(
                                  text: TextSpan(
                                      text: documentSnapshot['username'],
                                      style: TextStyle(
                                          color:
                                          constantColors.greenColor,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: ' ,${
                                          Provider.of<PostFunctions>(context,listen: false)
                                              .getImagaeTimePosted.toString()
                                          }',
                                          style: TextStyle(
                                              color: constantColors
                                                  .lightColor
                                                  .withOpacity(0.8),
                                              fontSize: 16.0,
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                      ]),
                                )),
                          ),
                        ],
                      ),
                    ),

                  ),

                  Container(
                    width: MediaQuery.of(context).size.width * .15,
                    height: MediaQuery.of(context).size.height * .05,
                    // color: constantColors.redColor,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('posts')
                          .doc(documentSnapshot['caption']).collection('awards').snapshots(),
                      builder: (context,snapshot){
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }else{
                          return new ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
                             return Container(
                               width: 30.0,
                               height: 30.0,
                               child: Image.network(documentSnapshot['awards']),
                             );
                            }).toList(),
                          );
                        }
                      }
                    ),
                  ),
                ],

              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Container(
                height:
                MediaQuery.of(context).size.height * .46,
                width: MediaQuery.of(context).size.width,
                child: FittedBox(
                  child: Image.network(
                    documentSnapshot.get('postimage'),
                    scale: 2,
                  ),
                ),
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
                            onLongPress: (){
                              Provider.of<PostFunctions>(context, listen: false).showLikes(context
                              ,documentSnapshot['caption']);
                            },
                            onTap: (){
                              print('Adding Like...');
                              Provider.of<PostFunctions>(context,listen: false).addLike(context, documentSnapshot['caption'],
                              Provider.of<Authentication>(context,listen: false).userUid);
                            },
                            child: Icon(
                              FontAwesomeIcons.heart,
                              color: constantColors.redColor,
                              size: 22,
                            ),
                          ),
                         StreamBuilder<QuerySnapshot>(
                             stream: FirebaseFirestore.instance.collection('posts')
                             .doc(documentSnapshot['caption']).
                             collection('likes').snapshots(),
                             builder: (context, snapshot){
                               if(snapshot.connectionState == ConnectionState.waiting){
                                 return Center(
                                   child: CircularProgressIndicator(),
                                 );
                               }else{
                               return Padding(
                                   padding: EdgeInsets.only(left: 8.0),
                                   child: Text(
                                     snapshot.data.docs.length.toString(),
                                     style: TextStyle(
                                     color: constantColors.whiteColor,
                                     fontWeight: FontWeight.bold,
                                     fontSize: 18.0,),
                                   ),
                               );
                             }}),
                        ],
                      ),
                    ),
                    Container(
                      width: 70,
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: (){
                           Provider.of<PostFunctions>(context,listen: false)
                               .showCommentsSheet(context, documentSnapshot, documentSnapshot['caption']);
                           },

                            child: Icon(
                              FontAwesomeIcons.comment,
                              color: constantColors.blueColor,
                              size: 22,
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('posts')
                                  .doc(documentSnapshot['caption']).
                              collection('comment').snapshots(),
                              builder: (context, snapshot){
                                if(snapshot.connectionState == ConnectionState.waiting){
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }else{
                                  return Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      snapshot.data.docs.length.toString(),
                                      style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,),
                                    ),
                                  );
                                }}),
                        ],
                      ),
                    ),
                    Container(
                      width: 70,
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: (){
                             Provider.of<PostFunctions>(context,listen: false).showRewards(context,
                             documentSnapshot['caption']);
                    },
                            child: Icon(
                              FontAwesomeIcons.award,
                              color: constantColors.yellowColor,
                              size: 22,
                            ),
                          ),StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('posts')
                                  .doc(documentSnapshot['caption']).
                              collection('awards').snapshots(),
                              builder: (context, snapshot){
                                if(snapshot.connectionState == ConnectionState.waiting){
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }else{
                                  return Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      snapshot.data.docs.length.toString(),
                                      style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,),
                                    ),
                                  );
                                }}),
                        ],
                      ),
                    ),

                    Spacer(),
                    Provider.of<Authentication>(context, listen: false)
                        .getUserid ==
                        documentSnapshot.get('useruid')
                        ? IconButton(
                        icon: Icon(
                          EvaIcons.moreVertical,
                          color: constantColors.whiteColor,
                        ),
                        onPressed: () {
                          Provider.of<PostFunctions>(context,listen: false).showPostOptions(context,
                          documentSnapshot['caption']);
                        })
                        : Container(
                      width: 0.0,
                      height: 0.0,
                    )
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }).toList(),
);
}
}
