import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/article/articles_provider.dart';

import '../../configurations/theme.dart';
import '../../model/comment.dart';
import '../../screens/personal_management_screen/personal_management_screen.dart';
import '../../widgets/aricle_paragraph.dart';
import '../../widgets/comment.dart' as widget;
import '../../widgets/slide_dots.dart';

class ArticleScreen extends StatefulWidget {
  static const routeName = '/article_screen';
  @override
  _ArticleScreen createState() => _ArticleScreen();
}

class _ArticleScreen extends State<ArticleScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  String getCreatedDuration(DateTime createdDate) {
    int timeDiffInHours =
        DateTime.now().toUtc().difference(createdDate).inHours;
    int timeDiffInDays = 0;
    int timeDiffInMonths = 0;
    int timeDiffInYears = 0;
    if (timeDiffInHours > 24 * 365) {
      timeDiffInYears = timeDiffInHours ~/ (24 * 365);
      //timeDiffInHours %= timeDiffInHours;
    } else if (timeDiffInHours > 24 * 30) {
      timeDiffInMonths = timeDiffInHours ~/ (24 * 30);
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

  @override
  Widget build(BuildContext context) {
    final articleId = ModalRoute.of(context).settings.arguments as String;
    final loadedArticle = Provider.of<ArticlesProvider>(
      context,
      listen: false,
    ).findById(articleId);
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Theme.of(context).appBarTheme.color,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      loadedArticle.title ?? "",
                      style: Theme.of(context).textTheme.headerSmall1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          loadedArticle.publisher ?? "随行",
                          style: Theme.of(context).textTheme.captionSmall2,
                        ),
                        Container(
                            height: 10,
                            child: VerticalDivider(
                                color: Color.fromARGB(255, 128, 128, 128))),
                        Text(
                          loadedArticle.author ?? "匿名",
                          style: Theme.of(context).textTheme.captionSmall2,
                        ),
                      ],
                    ),
                  ]),
              floating: true,
              expandedHeight: 50,
              actions: [
                Placeholder(
                  color: Theme.of(context).appBarTheme.color,
                  fallbackWidth: 40,
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                      placeholder: AssetImage(
                                          'assets/images/placeholder.png'),
                                      image: loadedArticle.imageUrl == null
                                          ? AssetImage(
                                              'assets/images/placeholder.png')
                                          : NetworkImage(
                                              loadedArticle.imageUrl),
                                      // "https://blog.sevenponds.com/wp-content/uploads/2018/12/800px-Vincent_van_Gogh_-_Self-Portrait_-_Google_Art_Project_454045.jpg"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 20.0, bottom: 10),
                            child: Text(
                              loadedArticle.title ?? "",
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                loadedArticle.icon == null
                                    ? Icon(Icons.album)
                                    : Image(
                                        image: NetworkImage(
                                          loadedArticle.icon,
                                        ),
                                        width: 30,
                                        height: 30,
                                        color: null,
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.center,
                                      ),
                                Text(
                                  loadedArticle.publisher ?? "随行",
                                  style:
                                      Theme.of(context).textTheme.captionSmall2,
                                ),
                                Container(
                                    height: 20,
                                    child: VerticalDivider(
                                        color: Color.fromARGB(
                                            255, 128, 128, 128))),
                                Text(
                                  loadedArticle.author,
                                  style:
                                      Theme.of(context).textTheme.captionSmall2,
                                ),
                                Text(
                                  getCreatedDuration(loadedArticle.createdDate),
                                  style:
                                      Theme.of(context).textTheme.captionSmall2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Center(
                      child: Column(children: [
                        ...loadedArticle.content
                            .map((e) => ArticleParagraph(e)),
                      ]),
                    ),
                    Comments(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Comments extends StatelessWidget {
  //List<Comment> commentList;
  Comments({
    Key key,
  }) : super(key: key);
  //Comment(List<Comment> commentList) {}

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: Container(
          height: 500,
          child: ListView.separated(
            itemBuilder: (ctx, i) => widget.Comment(
                i,
                commentList[i].author.user_name,
                commentList[i].author.avatar_url,
                commentList[i].content,
                commentList[i].createdDate,
                commentList[i].number_of_likes,
                commentList[i].list_of_comment),
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemCount: commentList.length,
          ),
        ),
      ),
    );
  }
}
