import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_media/constants/Constantcolors.dart';
import 'package:social_media/screeen/Chatroom/ChatroomHelper.dart';

class Chatroom extends StatelessWidget {
  final ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: constantColors.blueGreyColor,
        onPressed: () {
          Provider.of<ChatroomHelper>(context, listen: false).showCreateChatRoomsheet(context);
        },
        child: Icon(FontAwesomeIcons.plus,
        color: constantColors.greenColor,),
      ),
      appBar: AppBar(
        backgroundColor: constantColors.darkColor.withOpacity(0.6),
       centerTitle: true,
       actions: [
          IconButton(onPressed: (){}, icon: Icon(EvaIcons.moreVertical,
          color: constantColors.whiteColor,))
       ],
       leading: IconButton(onPressed: (){
         Provider.of<ChatroomHelper>(context, listen: false).showCreateChatRoomsheet(context);

       },
         icon: Icon(FontAwesomeIcons.plus, color: constantColors.greenColor,),
       ),
       title: RichText(
          text: TextSpan(
            text: 'Chat ',
            style: TextStyle(
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Box',
                style: TextStyle(
                  color: constantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Provider.of<ChatroomHelper>(context,listen: false).showChatrooms(context),
      ),
    );
  }
}
