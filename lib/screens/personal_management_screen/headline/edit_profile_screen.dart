import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/user/profile_provider.dart';
import '../../../widgets/profile_picture.dart';
import '../../../configurations/theme.dart';

class EditProfileScreen extends StatelessWidget {
  static const routeName = "/edit_profile";
  final _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ProfileProvider profile =
        Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('编辑个人资料', style: Theme.of(context).textTheme.headline2),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Theme.of(context).buttonColor,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Theme.of(context).appBarTheme.color,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "头像",
                      style: Theme.of(context).textTheme.buttonMedium1,
                    ),
                    ProfilePicture(profile.imageUrl, 30.0),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Divider(color: Color.fromARGB(255, 128, 128, 128)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "昵称",
                      style: Theme.of(context).textTheme.buttonMedium1,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.buttonMedium1,
                        decoration: InputDecoration.collapsed(
                            hintText: profile.name,
                            hintStyle:
                                Theme.of(context).textTheme.buttonMediumGray),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Divider(color: Color.fromARGB(255, 128, 128, 128)),
                ),
                FlatButton(
                    onPressed: () {
                      profile.updateProfile(newName: _nameController.text);
                      Navigator.of(context).pop();
                    },
                    child: Text("保存",
                        style: Theme.of(context).textTheme.captionMedium4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    color: Theme.of(context).buttonColor),
              ],
            ),
          ),
        ));
  }
}
