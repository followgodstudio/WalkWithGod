import 'package:flutter/material.dart';
import '../model/slide.dart';

class SlideItem extends StatelessWidget {
  final int index;
  SlideItem(this.index);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey[200],
                blurRadius: 10.0, // has the effect of softening the shadow
                spreadRadius: 1.0, // has the effect of extending the shadow
                offset: Offset(
                  10.0, // horizontal, move right 10
                  10.0, // vertical, move down 10
                ),
              )
            ],
            shape: BoxShape.rectangle,
            image: DecorationImage(
              image: AssetImage(slideList[index].imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
            child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                child: Image.asset(
                  slideList[index].icon,
                  height: 60,
                  width: 60,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Container(
                width: 280.0,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  slideList[index].title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.title,
                  maxLines: 3,
                  softWrap: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                slideList[index].author,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Song',
                  color: Theme.of(context).accentColor,
                ),
                softWrap: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                      iconSize: 16,
                      icon: Icon(Icons.share),
                      tooltip: '分享到微信',
                      onPressed: null),
                  IconButton(
                      iconSize: 16,
                      icon: Icon(Icons.center_focus_weak),
                      tooltip: '分享到我也不知道是哪儿',
                      onPressed: null),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    Icons.keyboard_arrow_up,
                    size: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                  Text('继续阅读', style: Theme.of(context).textTheme.display2),
                ],
              ),
            ),
          ],
        ))
      ],
    );
  }
}
