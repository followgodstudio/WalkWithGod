import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../configurations/constants.dart';
import '../../../providers/user/profile_provider.dart';
import '../../../utils/utils.dart';
import '../../../widgets/my_icon_button.dart';
import '../../../widgets/my_progress_indicator.dart';
import '../../../widgets/my_text_button.dart';
import '../../../widgets/navbar.dart';

class EditPictureScreen extends StatefulWidget {
  static const routeName = "/edit_picture";

  @override
  _EditPictureScreenState createState() => _EditPictureScreenState();
}

class _EditPictureScreenState extends State<EditPictureScreen> {
  /// Active image file
  File _imageFile;
  bool _uploading = false;
  final picker = ImagePicker();

  /// Cropper plugin
  Future<void> _cropImage(File selectedImage) async {
    File cropped = await ImageCropper.cropImage(
        maxWidth: 300,
        maxHeight: 300,
        sourcePath: selectedImage.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1));
    if (cropped != null)
      setState(() {
        _imageFile = cropped;
      });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    await _cropImage(File(pickedFile.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(),
      // Preview the image and crop it
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding, vertical: verticalPadding),
        child: ListView(
          children: <Widget>[
            if (_imageFile == null)
              Text("请选择一张图片上传", style: Theme.of(context).textTheme.bodyText1),
            if (_imageFile != null) ...[
              Image.file(_imageFile),
              if (!_uploading)
                MyTextButton(
                  text: "上传",
                  onPressed: () async {
                    if (_uploading) return;
                    setState(() {
                      _uploading = true;
                    });
                    await exceptionHandling(context, () async {
                      await Provider.of<ProfileProvider>(context, listen: false)
                          .updateProfilePicture(_imageFile);
                      showPopUpDialog(context, true, "上传成功", afterDismiss: () {
                        Navigator.of(context).pop(true);
                      });
                    });
                    setState(() {
                      _uploading = false;
                    });
                  },
                ),
              if (_uploading) MyProgressIndicator(),
            ]
          ],
        ),
      ),
      // Select an image from the camera or gallery
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            MyIconButton(
              flutterIcon: Icons.photo_camera,
              iconSize: 25,
              padding: 10,
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            MyIconButton(
              flutterIcon: Icons.photo_library,
              iconSize: 25,
              padding: 10,
              onPressed: () => _pickImage(ImageSource.gallery),
            )
          ],
        ),
      ),
    );
  }
}
