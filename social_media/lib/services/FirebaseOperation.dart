import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media/screeen/LandingPage/Landingutils.dart';
import 'package:social_media/services/Authentication.dart';

class FirebaseOperation with ChangeNotifier {
  UploadTask imageUploadTask;
  String initUserEmail, initUserName, initUserImage;

  Future uploadUserAvatar(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance.ref().child(
        'userProfileAvatar/${Provider.of<LandingUtils>(context, listen: false).getUserAvatar.path}/${TimeOfDay.now()}');
    imageUploadTask = imageReference.putFile(
        Provider.of<LandingUtils>(context, listen: false).getUserAvatar);
    await imageUploadTask.whenComplete(() {
      print('Image uploded');
    });
    await imageReference.getDownloadURL().then((url) {
      Provider.of<LandingUtils>(context, listen: false).userAvatarUrl =
          url.toString();
      print(
          'the user profile avatar url => ${Provider.of<LandingUtils>(context, listen: false).userAvatarUrl}');
      notifyListeners();
    });
  }

  Future createUserCollection(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).userUid)
        .set(data);
  }

  Future initUserData(BuildContext context) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserid)
        .get()
        .then((doc) {
      print('Fetching user data');
      initUserImage = doc.data()['userimage'];
      initUserEmail = doc.data()['useremail'];
      initUserName = doc.data()['username'];
      print(initUserName);
      print(initUserEmail);
      print(initUserImage);
      notifyListeners();
    });
  }

  Future uploadPostData(String postId,dynamic data) async {
    return FirebaseFirestore.instance.collection('posts').doc(
      postId 
    ).set(data);
  }

  Future addRewards(String postId, dynamic data) async{
    return FirebaseFirestore.instance.collection('posts').doc(postId).collection('awards').add(data);
  }

  Future deleteUserData(String userUid, dynamic collection) async {
    return FirebaseFirestore.instance.collection(collection).doc(userUid).delete();
  }

  Future updateCaption(String postId,dynamic data) async{
    return FirebaseFirestore.instance.collection('posts').doc(postId).update(data);
  }

  Future followUser(String followingUid,String followingDocId,dynamic followingData, String followerUid,
      String followerDocId,dynamic followerData ) async {
    return FirebaseFirestore.instance.collection('users').doc(followingUid).collection('followers').doc(followingDocId)
        .set(followingData).whenComplete(() async {
          return FirebaseFirestore.instance.collection('users').doc(followerUid).collection('following').doc(followerDocId)
              .set(followerData);
    });
  }

  Future submitUserData(String chatRoomName, dynamic chatRoomData,) async {
    return FirebaseFirestore.instance.collection('chatrooms').doc(
      chatRoomName
    ).set(chatRoomData);
  }
}
