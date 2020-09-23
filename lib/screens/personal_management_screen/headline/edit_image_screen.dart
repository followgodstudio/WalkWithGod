import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../configurations/theme.dart';
import '../../../providers/user/profile_provider.dart';
import '../../../widgets/popup_dialog.dart';

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
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Theme.of(context).textTheme.buttonColor2,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Theme.of(context).appBarTheme.color,
      ),
      // Preview the image and crop it
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            if (_imageFile == null)
              Text("请选择一张图片上传",
                  style: Theme.of(context).textTheme.captionMedium4),
            if (_imageFile != null) ...[
              Image.file(_imageFile),
              if (!_uploading)
                FlatButton(
                    onPressed: () async {
                      setState(() {
                        _uploading = true;
                      });
                      await Provider.of<ProfileProvider>(context, listen: false)
                          .updateProfilePicture(_imageFile);
                      setState(() {
                        _uploading = false;
                      });
                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(seconds: 1), () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            });
                            return PopUpDialog(true, "上传成功");
                          });
                    },
                    child: Text("上传",
                        style: Theme.of(context).textTheme.captionMedium4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    color: Theme.of(context).buttonColor),
              if (_uploading) Center(child: CircularProgressIndicator()),
            ]
          ],
        ),
      ),
      // Select an image from the camera or gallery
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }
}
