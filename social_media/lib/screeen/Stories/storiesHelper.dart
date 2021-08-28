import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_media/screeen/Stories/stories_widget.dart';
import 'package:social_media/services/Authentication.dart';
import 'package:social_media/services/FirebaseOperation.dart';
import 'package:timeago/timeago.dart' as timeago;

class StoriesHelper with ChangeNotifier {
  UploadTask imageUploadTask;
  final picker = ImagePicker();
  File storyImage;

  File get getStoryImage => storyImage;
  final StoryWidgets storyWidgets = StoryWidgets();
  String storyImageUrl, storyHighlightIcon, storyTime, lastSeenTime;

  String get getStoryImageUrl => storyImageUrl;

  String get getstoryTime => storyTime;

  String get getlastSeenTime => lastSeenTime;

  String get getstoryHighlightIcon => storyHighlightIcon;

  Future selectStoriesImage(BuildContext context, ImageSource source) async {
    final pickedStoryImage = await picker.pickImage(source: source);
    pickedStoryImage == null
        ? print('image cannot null')
        : storyImage = File(pickedStoryImage.path);
    storyImage != null
        ? storyWidgets.previewStoryImage(context, storyImage)
        : print('Error');
    notifyListeners();
  }

  Future uploadStoryImage(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('stories/${getStoryImage.path}/${Timestamp.now()}');
    imageUploadTask = imageReference.putFile(getStoryImage);
    await imageUploadTask.whenComplete(() {
      print('Story Image Uploaded');
    });
    imageReference.getDownloadURL().then((url) {
      storyImageUrl = url;
      print(storyImageUrl);
    });
    notifyListeners();
  }

  Future convertHighlightedIcon(String firestoreImageUrl) async {
    storyHighlightIcon = firestoreImageUrl;
    print(storyHighlightIcon);
    notifyListeners();
  }

  Future addStoryToNewAlbum(BuildContext context, String userUid,
      String highlightName, String storyImage) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('highlights')
        .doc(highlightName)
        .set({
      'title': highlightName,
      'cover': storyHighlightIcon
    }).whenComplete(() {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .collection('highlights')
          .doc(highlightName)
          .collection('stories')
          .add({
        'image': getStoryImageUrl,
        'username':
            Provider.of<FirebaseOperation>(context, listen: false).initUserName,
        'userimage': Provider.of<FirebaseOperation>(context, listen: false)
            .initUserImage,
      });
    });
  }

  storyTimePosted(dynamic timeData) {
    Timestamp timestamp = timeData;
    DateTime dateTime = timestamp.toDate();
    storyTime = timeago.format(dateTime);
    lastSeenTime = timeago.format(dateTime);
    print(storyTime);
    notifyListeners();
  }

  Future addSeenStamp(BuildContext context, String storyId, String personId,
      DocumentSnapshot snapshot) async {
    if (snapshot['useruid'] ==
        Provider.of<Authentication>(context, listen: false).userUid) {
      return FirebaseFirestore.instance
          .collection('stories')
          .doc(storyId)
          .collection('seen')
          .doc(personId)
          .set({
        'time': Timestamp.now(),
        'username':
            Provider.of<FirebaseOperation>(context, listen: false).initUserName,
        'userimage': Provider.of<FirebaseOperation>(context, listen: false)
            .initUserImage,
        'useruid': Provider.of<Authentication>(context, listen: false).userUid,
      });
    }
  }

  Future addStoryToExistingAlbum(BuildContext context, String userUid,
      String highlightColId, String storyImage) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('highlights')
        .doc(highlightColId)
        .collection('stories')
        .add({
      'image': storyImage,
      'username':
          Provider.of<FirebaseOperation>(context, listen: false).initUserName,
      'userimage':
          Provider.of<FirebaseOperation>(context, listen: false).initUserImage,
    });
  }
}
