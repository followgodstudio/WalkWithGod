
import 'package:flutter/material.dart';
import '../model/slide.dart';

class SlideItem extends StatelessWidget {
  final int index;
  final double narrowFactor = 105 / 188;
  final double wideFactor = 165 / 188;
  final double midiumFactor = 135 / 188;
  SlideItem(this.index);


  onShareViaWechat(){

  }

  final shareIcons=[
    {
      'path': 'assets/images/icon.jpeg',
      'callback' : ()=>{}
    },
    {
      'path': 'assets/images/icon.jpeg',
      'callback' : ()=>{}
    },
    {
      'path': 'assets/images/icon.jpeg',
      'callback' : ()=>{}
    }
  ];

  _onPressShareButton(context){
    List<Widget> result = new List<Widget>();
    shareIcons.asMap().forEach((key, icon)=>{
      result.add(
        IconButton(
          icon: /*Icon(Icons.add_a_photo),*/ new Image.asset(icon['path']),
          onPressed: icon['callback']
        )
      )
    });

    showModalBottomSheet(context: context, builder: (context){
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
              mainAxisSize: MainAxisSize.min,
              children: result
          ),
          FlatButton(
            color: Colors.blue,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.all(8.0),
            splashColor: Colors.blueAccent,
            onPressed: ()=>{
              _cancelShare(context)
            },
            child: Text(
              "取消",
              style: TextStyle(fontSize: 20.0),
            ),
          )
        ],
      );
    });
  }

  _cancelShare(context){
    Navigator.pop(context);
  }

  _onPressFavorite(context){

  }

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
            // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            //   Column(
            //     children: [
            //       Row(
            //         children: [
            //           Container(
            //             child: Ink(
            //               decoration: const ShapeDecoration(
            //                 color: Color.fromARGB(255, 230, 230, 230),
            //                 shape: CircleBorder(),
            //               ),
            //               child: IconButton(
            //                   color: Colors.white10,
            //                   iconSize: 16,
            //                   icon: Icon(Icons.person_add),
            //                   tooltip: '分享到微信',
            //                   onPressed: null),
            //             ),
            //           ),
            //           Container(
            //             child: Ink(
            //               decoration: const ShapeDecoration(
            //                 color: Color.fromARGB(255, 230, 230, 230),
            //                 shape: CircleBorder(),
            //               ),
            //               child: IconButton(
            //                   color: Colors.white10,
            //                   iconSize: 16,
            //                   icon: Icon(Icons.person_add),
            //                   tooltip: '分享到微信',
            //                   onPressed: null),
            //             ),
            //           ),
            //           Container(
            //             child: Ink(
            //               decoration: const ShapeDecoration(
            //                 color: Color.fromARGB(255, 230, 230, 230),
            //                 shape: CircleBorder(),
            //               ),
            //               child: IconButton(
            //                   color: Colors.white10,
            //                   iconSize: 16,
            //                   icon: Icon(Icons.person_add),
            //                   tooltip: '分享到微信',
            //                   onPressed: null),
            //             ),
            //           ),
            //         ],
            //       ),
            //       Text("等n位好友喜欢了这篇文章")
            //     ],
            //   )
            // ]),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                          onPressed: ()=>_onPressShareButton(context)),
                    ),
                  ),
                  SizedBox(width: 30),
                  Container(
                    child: Ink(
                      decoration: const ShapeDecoration(
                        color: Color.fromARGB(255, 230, 230, 230),
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                          iconSize: 18,
                          icon: Icon(Icons.favorite),
                          tooltip: '收藏',
                          onPressed: ()=>_onPressFavorite(context)),
                    ),
                  ),
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
