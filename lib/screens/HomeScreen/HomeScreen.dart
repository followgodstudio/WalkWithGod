import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:walk_with_god/model/slide.dart';
import '../../configurations/Theme.dart';

import 'package:walk_with_god/widgets/aricle_paragraph.dart';
import '../../widgets/slide_item.dart';
import '../../model/Slide.dart';
import '../../widgets/slide_dots.dart';
import '../../widgets/comment.dart' as widget;

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  final FirebaseUser user;

  HomeScreen({this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<bool> useWhiteTextColor(String imageUrl) async {
    PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      NetworkImage(
          "https://cdn.britannica.com/78/43678-050-F4DC8D93/Starry-Night-canvas-Vincent-van-Gogh-New-1889.jpg"),

      // Images are square
      size: Size(300, 300),

      // I want the dominant color of the top left section of the image
      region: Offset.zero & Size(40, 40),
    );

    Color dominantColor = paletteGenerator.dominantColor?.color;

    // Here's the problem
    // Sometimes dominantColor returns null
    // With black and white background colors in my tests
    if (dominantColor == null) print('Dominant Color null');

    return useWhiteForeground(dominantColor);
  }

  bool useWhiteForeground(Color backgroundColor) =>
      1.05 / (backgroundColor.computeLuminance() + 0.05) > 4.5;

  @override
  Widget build(BuildContext context) {
    var now = new DateTime.now();
    var formatter = new DateFormat('MMM dd, yyyy');
    String formatted = formatter.format(now);
    //Color textColor = color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    Color textColor = Colors.black;
    useWhiteTextColor(
            "https://cdn.britannica.com/78/43678-050-F4DC8D93/Starry-Night-canvas-Vincent-van-Gogh-New-1889.jpg")
        .then((value) => textColor = value ? Colors.white : Colors.black);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              shadowColor: Colors.white,
              leading: FlatButton(
                  onPressed: null,
                  child: Text(
                    "今日",
                    style: Theme.of(context).textTheme.caption,
                  )),
              backgroundColor: Theme.of(context).canvasColor,
              pinned: true,
              expandedHeight: 250.0,

              flexibleSpace: Stack(
                children: <Widget>[
                  Positioned.fill(
                      child: Image.network(
                    "https://d626yq9e83zk1.cloudfront.net/files/share-odb-2020-01-26.jpg",
                    fit: BoxFit.cover,
                  ))
                ],
              ),

              // flexibleSpace: FlexibleSpaceBar(
              //   title: Text(
              //     formatted,
              //     style: Theme.of(context).textTheme.captionMain,
              //   ),
              // ),

              actions: [
                IconButton(
                  icon: ClipOval(
                    child: Image.asset("assets/images/logo.png"),
                  ),
                  onPressed: () {},
                )
              ],
            ),
            SliverFixedExtentList(
              itemExtent: MediaQuery.of(context).size.width,
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  // return Container(
                  //   alignment: Alignment.center,
                  //   color: Colors.lightBlue[100 * (index % 9)],
                  //   child: Text('List Item $index'),
                  // );

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 12.5),
                    child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://cdn.britannica.com/78/43678-050-F4DC8D93/Starry-Night-canvas-Vincent-van-Gogh-New-1889.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: FlatButton(
                            onPressed: () {},
                            child: Container(
                                child: Stack(children: [
                              Positioned(
                                bottom: 0,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Flexible(
                                    //flex: 2,
                                    Container(
                                      width: 300,
                                      child: Text(
                                        "梵高逝世130年，他的书信仍旧对你我说话",
                                        style: TextStyle(color: textColor)
                                        // Theme.of(context)
                                        //     .textTheme
                                        //     .headline2
                                        ,
                                      ),
                                    ),
                                    Text("testing2"),
                                    Text("testing2"),
                                    //),
                                    // Flexible(flex: 1, child: Text("testing2")),
                                    // Flexible(flex: 1, child: Text("testing3")),
                                  ],
                                ),
                              )
                            ])))),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     leading: FlatButton(onPressed: null, child: Text("今日")),
    //     title: Text(
    //       formatted,
    //       style: Theme.of(context).textTheme.caption,
    //     ),
    //     actions: [
    //       IconButton(
    //         icon: ClipOval(
    //           child: Image.asset("assets/images/logo.png"),
    //         ),
    //         onPressed: () {},
    //       )
    //     ],
    //   ),
    //   backgroundColor: Theme.of(context).canvasColor,
    // );
  }
}
