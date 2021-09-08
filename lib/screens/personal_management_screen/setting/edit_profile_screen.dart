import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../configurations/constants.dart';
import '../../../configurations/theme.dart';
import '../../../providers/user/profile_provider.dart';
import '../../../widgets/my_text_button.dart';
import '../../../widgets/navbar.dart';
import '../../../widgets/profile_picture.dart';
import 'edit_image_screen.dart';

class EditProfileScreen extends StatelessWidget {
  static const routeName = "/edit_profile";
  final _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ProfileProvider profile =
        Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
        appBar: NavBar(title: "编辑个人资料"),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding, vertical: verticalPadding),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "头像",
                      style: Theme.of(context).textTheme.captionMedium1,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(EditPictureScreen.routeName);
                        },
                        child: Consumer<ProfileProvider>(
                          builder: (context, value, child) =>
                              ProfilePicture(30.0, value.imageUrl),
                        )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "昵称",
                      style: Theme.of(context).textTheme.captionMedium1,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.captionMedium1,
                        decoration: InputDecoration.collapsed(
                            hintText: profile.name,
                            hintStyle: Theme.of(context)
                                .textTheme
                                .captionMedium1
                                .copyWith(color: MyColors.grey)),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Divider(),
                ),
                MyTextButton(
                  width: double.infinity,
                  text: "保存",
                  onPressed: () {
                    profile.updateProfile(newName: _nameController.text);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
