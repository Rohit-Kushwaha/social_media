import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media/constants/Constantcolors.dart';
import 'package:social_media/screeen/AltProfile/alt_profile_helpers.dart';

class AltProfile extends StatelessWidget {

  ConstantColors constantColors = ConstantColors();
  final String userUid;
  AltProfile({@required this.userUid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor:  constantColors.,
      appBar: Provider.of<AltProfileHelper>(context,listen:false).appBar(context),
      body: SingleChildScrollView(
        child: Container(

          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('users').doc(userUid).snapshots(),
            builder: (context,snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }else{
                return Column(
                  children: [
                    Provider.of<AltProfileHelper>(context,listen: false).headerProfile(context, snapshot, userUid),
                    Provider.of<AltProfileHelper>(context,listen: false).divider(),
                    Provider.of<AltProfileHelper>(context,listen: false).middleProfile(context, snapshot),
                    Provider.of<AltProfileHelper>(context,listen: false).footerProfile(context, snapshot),

                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                );
              }
            },
          ),

          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.blueGreyColor.withOpacity(0.6),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),)
          ),
        ),
      ),
    );
  }
}
