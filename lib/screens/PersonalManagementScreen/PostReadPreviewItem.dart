import 'package:flutter/material.dart';
import 'package:walk_with_god/model/PostRead.dart';

class PostReadPreviewItem extends StatefulWidget {
  PostReadPreviewItem({Key key, this.postRead}) : super(key: key);

  final PostRead postRead;

  @override
  _PostReadPreviewItemState createState() => _PostReadPreviewItemState();
}

class _PostReadPreviewItemState extends State<PostReadPreviewItem> {
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
                    //decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Container(
                      height: 130,
                      width: 250,
                      child: Image.network(
                        widget.postRead.photoURL,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Title(
                          color: Colors.red,
                          child: Text(
                            widget.postRead.subject,
                            style: Theme.of(context).textTheme.headline1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '文 / ' + widget.postRead.authorName,
                          style: Theme.of(context).textTheme.overline,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "已阅读" + widget.postRead.percentage.toString() + "%",
                                style: Theme.of(context).textTheme.overline,
                              ),
                              Text(
                                "继续阅读",
                                style: Theme.of(context).textTheme.overline,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ));
  }
}
