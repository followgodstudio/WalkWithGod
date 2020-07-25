import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_visibility_aware/flutter_visibility_aware.dart';
import 'package:walk_with_god/model/PostSaved.dart';

class PostSavedPreviewItem extends StatelessWidget {
  PostSavedPreviewItem({this.postSaved, this.index, this.callback});

  final PostSaved postSaved;

  final int index;

  final Function callback;

  @override
  Widget build(BuildContext context) {
    return VisibilityAware(
      key: Key(index.toString()),
      visibleCallback: () async {
        callback(index);
      },
      invisibleCallback: () async {
        //debugPrint("#${index} is invisible.");
      },
      child: FlatButton(
          onPressed: null,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
                height: 210,
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: Container(
                        height: 130,
                        width: 250,
                        child: Image.asset(
                          postSaved.photoURL,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Title(
                            color: Colors.red,
                            child: Text(
                              postSaved.subject,
                              style: Theme.of(context).textTheme.headline1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '文 / ${postSaved.authorName}',
                            style: Theme.of(context).textTheme.overline,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ClipOval(
                                child: Container(
                                  height: 13,
                                  width: 25,
                                  child: Image.asset(
                                    postSaved.platform.logoURL,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                '${postSaved.platform.name}',
                                style: Theme.of(context).textTheme.overline,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          )),
    );
=======
import 'package:walk_with_god/model/PostSaved.dart';

class PostSavedPreviewItem extends StatelessWidget {
  PostSavedPreviewItem({this.postSaved});

  final PostSaved postSaved;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: null,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
              height: 210,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Container(
                      height: 130,
                      width: 250,
                      child: Image.asset(
                        postSaved.photoURL,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Title(
                          color: Colors.red,
                          child: Text(
                            postSaved.subject,
                            style: Theme.of(context).textTheme.headline1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '文 / ${postSaved.authorName}',
                          style: Theme.of(context).textTheme.overline,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ClipOval(
                              child: Container(
                                height: 13,
                                width: 25,
                                child: Image.asset(
                                  postSaved.platform.logoURL,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(
                              '${postSaved.platform.name}',
                              style: Theme.of(context).textTheme.overline,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ));
>>>>>>> WIP saved posts
  }
}
