import 'package:flutter/material.dart';
import 'package:flutter_visibility_aware/flutter_visibility_aware.dart';

import '../../../model/post_read.dart';

class PostReadPreviewItem extends StatefulWidget {
  PostReadPreviewItem({Key key, this.postRead, this.index, this.callback})
      : super(key: key);

  final PostRead postRead;

  final int index;

  final Function callback;

  @override
  _PostReadPreviewItemState createState() => _PostReadPreviewItemState();
}

class _PostReadPreviewItemState extends State<PostReadPreviewItem> {
  bool isCurrent = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityAware(
      key: Key(widget.index.toString()),
      visibleCallback: () async {
        widget.callback(widget.index);
        setState(() {
          isCurrent = true;
        });
      },
      invisibleCallback: () async {
        setState(() {
          isCurrent = false;
        });
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
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          child: Container(
                            height: 130,
                            width: 250,
                            child: Image.asset(
                              widget.postRead.photoURL,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 10,
                          top: 10,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                            child: Container(
                                width: 33,
                                height: 33,
                                color: isCurrent ? Colors.yellow : Colors.grey,
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "DEC",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "05",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                        Positioned(
                          left: 10,
                          bottom: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ClipOval(
                                child: Container(
                                  height: 13,
                                  width: 25,
                                  child: Image.asset(
                                    widget.postRead.platform.logoURL,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                '${widget.postRead.platform.name}',
                                style: Theme.of(context).textTheme.overline,
                              ),
                            ],
                          ),
                        ),
                      ],
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
                            '文 / ${widget.postRead.authorName}',
                            style: Theme.of(context).textTheme.overline,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "已阅读${widget.postRead.percentage}%",
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
          )),
    );
  }
}
