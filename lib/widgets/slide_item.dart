import 'package:flutter/material.dart';
import '../model/slide.dart';

class SlideItem extends StatelessWidget {
  final int index;
  final double narrowFactor = 105 / 188;
  final double wideFactor = 165 / 188;
  final double midiumFactor = 135 / 188;
  SlideItem(this.index);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * narrowFactor,
          height: MediaQuery.of(context).size.width * narrowFactor,
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
            borderRadius: BorderRadius.circular(15),
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
                width: MediaQuery.of(context).size.width * midiumFactor,
                //padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  slideList[index].title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1,
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Ink(
                      decoration: const ShapeDecoration(
                        color: Color.fromARGB(255, 230, 230, 230),
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                          color: Colors.white10,
                          iconSize: 16,
                          icon: Icon(Icons.share),
                          tooltip: '分享到微信',
                          onPressed: null),
                    ),
                  ),

                  Container(
                    child: Ink(
                      decoration: const ShapeDecoration(
                        color: Color.fromARGB(255, 230, 230, 230),
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                          iconSize: 16,
                          icon: Icon(Icons.favorite),
                          tooltip: '收藏',
                          onPressed: null),
                    ),
                  ),

                  // IconButton(
                  //     iconSize: 16,
                  //     icon: Icon(Icons.center_focus_weak),
                  //     tooltip: '分享到我也不知道是哪儿',
                  //     onPressed: null),
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
                  Text('继续阅读', style: Theme.of(context).textTheme.subtitle2),
                ],
              ),
            ),
          ],
        ))
      ],
    );
  }
}
