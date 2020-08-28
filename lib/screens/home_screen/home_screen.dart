import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../configurations/theme.dart';
import 'article/article_list.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  final FirebaseUser user;
  final Firestore firestore;

  HomeScreen({this.user, this.firestore});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    var collection = Firestore.instance
        .collection('articles')
        .where("created_date",
            isGreaterThanOrEqualTo:
                new DateTime(now.year, now.month, now.day - 1))
        .orderBy("created_date", descending: true)
        .snapshots()
        .toList();
    // .listen((data) => data.documents.forEach((doc) => print(doc["title"])));
    print(collection.toString());
  }

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
            "https://blog.sevenponds.com/wp-content/uploads/2018/12/800px-Vincent_van_Gogh_-_Self-Portrait_-_Google_Art_Project_454045.jpg")
        .then((value) => {textColor = value ? Colors.white : Colors.black});

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              shadowColor: Colors.white,
              backgroundColor: Theme.of(context).canvasColor,
              pinned: true,
              automaticallyImplyLeading: false,
              flexibleSpace: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        FlatButton(
                            onPressed: () {},
                            child: Text(
                              "今日",
                              style: Theme.of(context).textTheme.captionMedium2,
                            )),
                        Container(
                            width: 30.0, height: 5.0, color: Colors.yellow),
                      ],
                    ),
                  ),
                  FlatButton(
                    onPressed: () {},
                    child: Text(
                      formatted,
                      style: Theme.of(context).textTheme.captionMain,
                    ),
                  ),
                ],
              ),
              actions: [
                FlatButton(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage("assets/images/logo.png"),
                  ),
                  onPressed: () {},
                )
              ],
            ),
            ArticleList(
              textColor: textColor,
              firestore: Firestore.instance,
            ),
          ],
        ),
      ),
    );
  }
}
