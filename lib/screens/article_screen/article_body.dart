import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../screens/personal_management_screen/headline/network_screen.dart';

import '../../configurations/theme.dart';
import '../../providers/article/article_provider.dart';
import '../../providers/article/articles_provider.dart';
import '../../utils/utils.dart';
import '../../widgets/aricle_paragraph.dart';

class ArticleBody extends StatelessWidget {
  final String articleId;
  ArticleBody(this.articleId);
  @override
  Widget build(BuildContext context) {
    final loadedArticle = Provider.of<ArticlesProvider>(
      context,
      listen: false,
    ).findById(articleId);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Hero(
        tag: loadedArticle.id,
        child: Container(
          height: 200,
          child: Stack(
            children: <Widget>[
              Center(
                child: FadeInImage(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  placeholder: AssetImage('assets/images/placeholder.png'),
                  image: (loadedArticle.imageUrl == null ||
                          loadedArticle.imageUrl == "")
                      ? AssetImage('assets/images/placeholder.png')
                      : NetworkImage(loadedArticle.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 10),
        child: Text(
          loadedArticle.title ?? "",
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 10.0, left: 3, right: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            loadedArticle.icon == null || loadedArticle.icon.isEmpty
                ? Icon(Icons.album)
                : GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        NetworkScreen.routeName,
                        arguments: loadedArticle.author,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                      child: CircleAvatar(
                          radius: 12.0,
                          backgroundColor: Theme.of(context).canvasColor,
                          backgroundImage: NetworkImage(loadedArticle.icon)),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(
                loadedArticle.publisher ?? "随行",
                style: Theme.of(context).textTheme.captionSmall2,
              ),
            ),
            Container(
                height: 12,
                child:
                    VerticalDivider(color: Color.fromARGB(255, 128, 128, 128))),
            Expanded(
              child: Text(
                loadedArticle.author ?? "匿名",
                style: Theme.of(context).textTheme.captionSmall2,
              ),
            ),
            Text(
              getCreatedDuration(loadedArticle.createdDate),
              style: Theme.of(context).textTheme.captionSmall2,
            ),
          ],
        ),
      ),
      Divider(),
      Center(child: Consumer<ArticlesProvider>(builder: (context, data, _) {
        List<Paragraph> _content =
            data.articles.firstWhere((e) => e.id == articleId).content;
        return _content == null || _content.isEmpty
            ? Center(
                child: Text("content is missing"),
              )
            : Column(children: [..._content.map((e) => ArticleParagraph(e))]);
      }))
    ]);
  }
}
