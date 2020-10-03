import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';

import '../../../providers/article/articles_provider.dart';
import '../../../utils/my_logger.dart';
import 'article_card.dart';

class ArticleList extends StatefulWidget {
  const ArticleList({
    Key key,
    // @required this.textColor,
    // this.firestore,
  }) : super(key: key);

  @override
  _ArticleListState createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  Future<bool> useWhiteTextColor(NetworkImage image) async {
    PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      //CachedNetworkImageProvider(imageUrl),
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
    if (dominantColor == null) MyLogger("Widget").i('Dominant Color null');

    return useWhiteForeground(dominantColor);
  }

  bool useWhiteForeground(Color backgroundColor) =>
      1.05 / (backgroundColor.computeLuminance() + 0.05) > 4.5;

  @override
  Widget build(BuildContext context) {
    final articlesData = Provider.of<ArticlesProvider>(context, listen: false);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          // var backgroundImage = articlesData.articles[index].imageUrl == null ||
          //         articlesData.articles[index].imageUrl.isEmpty
          //     ? AssetImage('assets/images/placeholder.png')
          //     : CachedNetworkImageProvider(articlesData.articles[index].imageUrl);
          // Color textColor = Colors.white;
          // useWhiteTextColor(backgroundImage).then((value) =>
          //     {value ? textColor = Colors.white : textColor = Colors.black});

          // builder:
          // (context, index) => ChangeNotifierProvider.value(
          //       value: articlesData.articles[index],
          //       child: ArticleCard(),
          //     );

          return ArticleCard(articlesData.articles[index]);

          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12.5),
          //   child: Hero(
          //     tag: articlesData.articles[index].id,
          //     child: Container(
          //         decoration: BoxDecoration(
          //           image: DecorationImage(
          //             image: backgroundImage,
          //             fit: BoxFit.cover,
          //           ),
          //         ),
          //         child: FlatButton(
          //           onPressed: () {
          //             Navigator.of(context).pushNamed(
          //               ArticleScreen.routeName,
          //               arguments: articlesData.articles[index].id,
          //             );
          //           },
          //           child: Align(
          //             alignment: Alignment.bottomCenter,
          //             child: Column(
          //               mainAxisSize: MainAxisSize.min,
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Padding(
          //                   padding: const EdgeInsets.only(bottom: 8.0),
          //                   child: Text(
          //                     articlesData.articles[index].title ?? "",
          //                     maxLines: 2,
          //                     overflow: TextOverflow.ellipsis,
          //                     style: TextStyle(
          //                         fontFamily: "Jinling", color: textColor),
          //                   ),
          //                 ),
          //                 Padding(
          //                   padding: const EdgeInsets.symmetric(
          //                       vertical: 8.0, horizontal: 3.0),
          //                   child: Text(
          //                     articlesData.articles[index].description ?? "",
          //                     maxLines: 2,
          //                     overflow: TextOverflow.ellipsis,
          //                     style:
          //                         Theme.of(context).textTheme.captionSmallWhite,
          //                   ),
          //                 ),
          //                 Divider(
          //                   color: Colors.white,
          //                 ),
          //                 Padding(
          //                   padding:
          //                       const EdgeInsets.only(top: 8.0, bottom: 20.0),
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.start,
          //                     children: [
          //                       articlesData.articles[index].icon == null ||
          //                               articlesData
          //                                   .articles[index].icon.isEmpty
          //                           ? Icon(Icons.album)
          //                           : Image(
          //                               image: CachedNetworkImageProvider(
          //                                 articlesData.articles[index].icon,
          //                               ),
          //                               width: 30,
          //                               height: 30,
          //                               color: null,
          //                               fit: BoxFit.scaleDown,
          //                               alignment: Alignment.center,
          //                             ),
          //                       // Icon(Icons.bookmark_border,
          //                       //     color: Colors.white,
          //                       //     size: Theme.of(context)
          //                       //         .textTheme
          //                       //         .captionMedium1
          //                       //         .fontSize),
          //                       SizedBox(
          //                         width: 5.0,
          //                       ),
          //                       Expanded(
          //                         child: Text(
          //                           articlesData.articles[index].author ?? "匿名",
          //                           style: Theme.of(context)
          //                               .textTheme
          //                               .captionSmallWhite,
          //                         ),
          //                       ),
          //                       Text(
          //                         getCreatedDuration(articlesData
          //                                 .articles[index].createdDate ??
          //                             DateTime.now().toUtc()),
          //                         style: Theme.of(context)
          //                             .textTheme
          //                             .captionSmallWhite,
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         )),
          //   ),
          // );
        },
        childCount:
            articlesData.articles == null ? 0 : articlesData.articles.length,
      ),
    );
  }
}
