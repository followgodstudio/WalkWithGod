import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../configurations/theme.dart';
import '../providers/article/article_provider.dart';
import '../widgets/my_divider.dart';

class ArticleWidget extends StatelessWidget {
  final ArticleProvider article;
  ArticleWidget(this.article);

  @override
  Widget build(BuildContext context) {
    int maxLines = 2;
    double imageWidth = 0.25 * MediaQuery.of(context).size.width;
    Widget imagePlaceholder = Container(
        decoration: BoxDecoration(color: Theme.of(context).primaryColor));
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: IntrinsicHeight(
        child: Row(children: [
          Container(
            width: imageWidth,
            height: imageWidth,
            child: CachedNetworkImage(
                imageUrl: this.article.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => imagePlaceholder,
                errorWidget: (context, url, error) => imagePlaceholder),
          ),
          SizedBox(width: 10),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                (this.article.icon == null || this.article.icon.isEmpty)
                    ? Icon(Icons.album, color: MyColors.grey, size: 18)
                    : CircleAvatar(
                        radius: 15,
                        backgroundImage:
                            CachedNetworkImageProvider(this.article.icon),
                        backgroundColor: Colors.transparent,
                      ),
                SizedBox(width: 5),
                Text(this.article.publisher ?? "随行",
                    style: Theme.of(context).textTheme.captionGrey),
                SizedBox(width: 5),
                Expanded(child: MyDivider(thickness: 0.8))
              ]),
              SizedBox(height: 5),
              Expanded(
                  child: Text(this.article.title,
                      maxLines: maxLines,
                      style: Theme.of(context).textTheme.headline3)),
              Text(this.article.authorName,
                  style: Theme.of(context).textTheme.captionGrey),
            ],
          ))
        ]),
      ),
    );
  }
}
