import 'package:flutter/material.dart';

class Typesetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int fontSize = 12;
    String lineSpace = "small";
    String font = "字体名称一";
    bool isNight = false;
    List<IconData> fontSizeIcons = [Icons.add, Icons.remove];
    List<IconData> lineSpaceIcons = [
      Icons.menu,
      Icons.reorder,
      Icons.format_align_justify
    ];
    return Container(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 30,
                child: Row(
                  children: <Widget>[
                    Text("字号      "),
                    for (var icons in fontSizeIcons)
                      ButtonTheme(
                        minWidth: 120,
                        height: 30,
                        child: FlatButton(
                          child: Icon(icons),
                          color: Theme.of(context).buttonColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          onPressed: () => {},
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text("行间距  "),
                  for (var icons in lineSpaceIcons)
                    ButtonTheme(
                      minWidth: 80,
                      height: 30,
                      child: FlatButton(
                        child: Icon(icons),
                        color: Theme.of(context).buttonColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        onPressed: () => {},
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text("字体     "),
                  Text(font),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text("夜间模式 "),
                  Spacer(),
                  Switch(value: isNight, onChanged: null),
                ],
              ),
            ),
          ],
        ));
  }
}
