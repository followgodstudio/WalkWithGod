import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';

import '../../providers/article/articles_provider.dart';
import '../../utils/my_logger.dart';
import '../../widgets/article_card.dart';

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
    if (dominantColor == null)
      MyLogger("Widget").i('ArticleList-build-Dominant Color null');

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
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.5),
            child: ArticleCard(
                article: articlesData.articles[index], isSmall: false),
          );
        },
        childCount:
            articlesData.articles == null ? 0 : articlesData.articles.length,
      ),
    );
  }
}
