import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../../configurations/theme.dart';
import '../../article_screen/article_screen.dart';
import 'package:provider/provider.dart';
import '../../../providers/article/articles_provider.dart';

class ArticleList extends StatelessWidget {
  const ArticleList({
    Key key,
    // @required this.textColor,
    // this.firestore,
  }) : super(key: key);

  // final Firestore firestore;
  // final Color textColor;

  String getCreatedDuration(DateTime createdDate) {
    createdDate ?? DateTime.now().toUtc();
    int timeDiffInHours =
        DateTime.now().toUtc().difference(createdDate).inHours;
    int timeDiffInDays = 0;
    int timeDiffInMonths = 0;
    int timeDiffInYears = 0;
    if (timeDiffInHours > 24 * 365) {
      timeDiffInYears = timeDiffInHours ~/ 24;
      //timeDiffInHours %= timeDiffInHours;
    } else if (timeDiffInHours > 24 * 30) {
      timeDiffInMonths = timeDiffInHours ~/ 24;
      //timeDiffInHours %= timeDiffInHours;
    } else if (timeDiffInHours > 24) {
      timeDiffInDays = timeDiffInHours ~/ 24;
      //timeDiffInHours %= timeDiffInHours;
    }

    return timeDiffInYears > 1
        ? timeDiffInYears.toString() + " years ago"
        : timeDiffInYears > 0
            ? timeDiffInYears.toString() + " year ago"
            : timeDiffInMonths > 1
                ? timeDiffInMonths.toString() + " months ago"
                : timeDiffInMonths > 0
                    ? timeDiffInMonths.toString() + " month ago"
                    : timeDiffInDays > 1
                        ? timeDiffInDays.toString() + " days ago"
                        : timeDiffInDays > 0
                            ? timeDiffInDays.toString() + " day ago"
                            : timeDiffInHours > 1
                                ? timeDiffInHours.toString() + " hours ago"
                                : timeDiffInHours > 0
                                    ? timeDiffInHours.toString() + " hour ago"
                                    : null;
  }

  // Future<bool> useWhiteTextColor(Image image) async {
  //   PaletteGenerator paletteGenerator =
  //       await PaletteGenerator.fromImage(image,

  //     // Images are square
  //     //size: Size(300, 300),

  //     // I want the dominant color of the top left section of the image
  //     region: Offset.zero & Size(40, 40),
  //   );

  //   Color dominantColor = paletteGenerator.dominantColor?.color;

  //   // Here's the problem
  //   // Sometimes dominantColor returns null
  //   // With black and white background colors in my tests
  //   if (dominantColor == null) print('Dominant Color null');

  //   return useWhiteForeground(dominantColor);
  // }

  Future<bool> useWhiteTextColor(NetworkImage image) async {
    PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      //NetworkImage(imageUrl),
      image,
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
    final articlesData = Provider.of<ArticlesProvider>(context);

    return SliverFixedExtentList(
      itemExtent: MediaQuery.of(context).size.width,
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          NetworkImage backgroundImage = NetworkImage(articlesData
                      .articles[index].imageUrl ==
                  null
              ? "https://blog.sevenponds.com/wp-content/uploads/2018/12/800px-Vincent_van_Gogh_-_Self-Portrait_-_Google_Art_Project_454045.jpg"
              : articlesData.articles[index].imageUrl);
          Color textColor;
          useWhiteTextColor(backgroundImage).then((value) =>
              {value ? textColor = Colors.white : textColor = Colors.black});
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12.5),
            child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: backgroundImage,
                    fit: BoxFit.cover,
                  ),
                ),
                child: FlatButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => ArticleScreen(), settings: articlesData.articles[index].id.toString()),
                    // );
                    Navigator.of(context).pushNamed(
                      ArticleScreen.routeName,
                      arguments: articlesData.articles[index].id,
                    );
                  },
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            articlesData.articles[index].title ?? "",
                            style: TextStyle(
                                fontFamily: "Jinling", color: textColor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            articlesData.articles[index].description ?? "",
                            style:
                                Theme.of(context).textTheme.captionSmallWhite,
                          ),
                        ),
                        Divider(
                          color: Colors.white,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.bookmark_border,
                                color: Colors.white,
                                size: Theme.of(context)
                                    .textTheme
                                    .captionMedium1
                                    .fontSize),
                            SizedBox(
                              width: 5.0,
                            ),
                            Expanded(
                              child: Text(
                                articlesData.articles[index].author ?? "匿名",
                                style: Theme.of(context)
                                    .textTheme
                                    .captionMediumWhite,
                              ),
                            ),
                            Text(
                              getCreatedDuration(
                                  articlesData.articles[index].createdDate ??
                                      DateTime.now().toUtc()),
                              style: Theme.of(context)
                                  .textTheme
                                  .captionMediumWhite,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                )),
          );
        },
        childCount: articlesData.articles.length,
      ),
    );
  }
}
