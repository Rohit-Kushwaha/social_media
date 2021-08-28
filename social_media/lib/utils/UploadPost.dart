import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_media/constants/Constantcolors.dart';
import 'package:social_media/services/Authentication.dart';
import 'package:social_media/services/FirebaseOperation.dart';

class UploadPost with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  TextEditingController captionController = TextEditingController();
  File uploadPostImage;

  File get getUploadPostImage => uploadPostImage;
  String uploadPostImageUrl;

  String get getUploadPostmageUrl => uploadPostImageUrl;
  final picker = ImagePicker();
  UploadTask imagePostUploadTask;

  Future pickUploadPostImage(BuildContext context, ImageSource source) async {
    final uploadPostImageVal = await picker.pickImage(source: source);
    uploadPostImageVal == null
        ? print('Select image')
        : uploadPostImage = File(uploadPostImageVal.path);
    print(uploadPostImageVal.path);

    uploadPostImage != null
        ? showPostImage(context)
        : print('Image Upload error');

    notifyListeners();
  }

  Future uploadPostImageToFirebase() async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('posts/${uploadPostImage.path}/${TimeOfDay.now()}');
    imagePostUploadTask = imageReference.putFile(uploadPostImage);
    await imagePostUploadTask.whenComplete(() {
      print('Post image uploaded to storage');
    });
    imageReference.getDownloadURL().then((imageUrl) {
      uploadPostImageUrl = imageUrl;
      print(uploadPostImageUrl);
    });
    notifyListeners();
  }

  //modal sheet
  selectPostImageType(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(12.0),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                        color: constantColors.blueColor,
                        child: Text('Gallery',
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            )),
                        onPressed: () {
                          pickUploadPostImage(context, ImageSource.gallery);
                        }),
                    MaterialButton(
                        color: constantColors.blueColor,
                        child: Text('Camera',
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            )),
                        onPressed: () {
                          pickUploadPostImage(context, ImageSource.camera);
                        }),
                  ],
                )
              ],
            ),
          );
        });
  }

  showPostImage(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 140.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                // CircleAvatar(
                //   backgroundColor: constantColors.transperant,
                //   radius: 60.0,
                //   backgroundImage: FileImage(uploadPostImage),
                // ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  child: Container(
                    height: 180.0,
                    width: 360.0,
                    child: Image.file(uploadPostImage, fit: BoxFit.contain),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                            child: Text('Reselect',
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationColor:
                                        constantColors.whiteColor)),
                            onPressed: () {
                              selectPostImageType(context);
                            }),
                        MaterialButton(
                            color: constantColors.blueColor,
                            child: Text('ConfirmImage',
                                style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                )),
                            onPressed: () {
                              uploadPostImageToFirebase().whenComplete(() {
                                editPostSheet(context);
                                print('Image Uploaded');
                              });
                            }),
                      ]),
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * .5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
          );
        });
  }

  editPostSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 140.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              IconButton(
                                  icon: Icon(Icons.image_aspect_ratio),
                                  color: constantColors.greenColor,
                                  onPressed: () {}),
                              IconButton(
                                  icon: Icon(Icons.fit_screen),
                                  color: constantColors.yellowColor,
                                  onPressed: () {}),
                            ],
                          ),
                        ),
                        Container(
                          height: 200.0,
                          width: 300.0,
                          child:
                              Image.file(uploadPostImage, fit: BoxFit.contain),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 30.0,
                          width: 30.0,
                          child: Image.asset('assets/icons/sunflower.png'),
                        ),
                        Container(
                          height: 110,
                          width: 5.0,
                          color: constantColors.blueColor,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Container(
                            height: 120.0,
                            width: 300.0,
                            child: TextField(
                              maxLines: 5,
                              textCapitalization: TextCapitalization.words,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(100)
                              ],
                              maxLengthEnforcement:
                                  MaxLengthEnforcement.enforced,
                              maxLength: 100,
                              controller: captionController,
                              style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Add a Caption',
                                hintStyle: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    child: Text(
                      'Share',
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    onPressed: () async {
                      Provider.of<FirebaseOperation>(context, listen: false)
                          .uploadPostData(captionController.text, {
                        'caption': captionController.text,
                        'username': Provider.of<FirebaseOperation>(context,
                                listen: false)
                            .initUserName,
                        'useremail': Provider.of<FirebaseOperation>(context,
                                listen: false)
                            .initUserEmail,
                        'userimage': Provider.of<FirebaseOperation>(context,
                                listen: false)
                            .initUserImage,
                        'useruid':
                            Provider.of<Authentication>(context, listen: false)
                                .getUserid,
                        'time': Timestamp.now(),
                        'postimage': getUploadPostmageUrl,
                      }).whenComplete(() async {
                        return FirebaseFirestore.instance
                            .collection('users')
                            .doc(Provider.of<Authentication>(context,
                                    listen: false)
                                .getUserid)
                            .collection('posts')
                            .add({
                          'caption': captionController.text,
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
                              .getUserid,
                          'time': Timestamp.now(),
                          'postimage': getUploadPostmageUrl,
                        });
                      }).whenComplete(() {
                        Navigator.pop(context);
                      });
                    },
                    color: constantColors.blueColor,
                  ),
                ],
              ),
              height: MediaQuery.of(context).size.height * .6,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: BorderRadius.circular(12.0)));
        });
  }
}
