import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../configurations/theme.dart';
import '../../providers/article/article_provider.dart';
import '../../providers/article/articles_provider.dart';
import '../../widgets/aricle_paragraph.dart';
import 'bottom_bar.dart';
import 'comments.dart';

class ArticleScreen extends StatefulWidget {
  static const routeName = '/article_screen';
  @override
  _ArticleScreen createState() => _ArticleScreen();
}

class _ArticleScreen extends State<ArticleScreen> {
  var _isLoading = false;
  var _isInit = true;
  String _articleId;
  List<Paragraph> _content = [];
  ScrollController _hideButtonController = new ScrollController();
  var _isVisible = true;

  @override
  void initState() {
    super.initState();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible)
          setState(() {
            _isVisible = false;
          });
      }
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isVisible)
          setState(() {
            _isVisible = true;
          });
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _articleId = ModalRoute.of(context).settings.arguments as String;
      Provider.of<ArticlesProvider>(context)
          .fetchArticleConentById(_articleId)
          .catchError((err) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }).then((content) {
        setState(() {
          _isLoading = false;
        });
        _content = content;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
    final loadedArticle = Provider.of<ArticlesProvider>(
      context,
      listen: false,
    ).findById(_articleId);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _hideButtonController,
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
                    // Text(
                    //   loadedArticle.title ?? "",
                    //   style: Theme.of(context).textTheme.headerSmall1,
                    // ),
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
                                      image: (loadedArticle.imageUrl == null ||
                                              loadedArticle.imageUrl == "")
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
                                (loadedArticle.icon == null ||
                                        loadedArticle.icon == "")
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
                                // Text(
                                //   loadedArticle.author,
                                //   style:
                                //       Theme.of(context).textTheme.captionSmall2,
                                // ),
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
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : _content.isEmpty
                              ? Center(
                                  child: Text("content is missing"),
                                )
                              : Column(children: [
                                  ..._content.map((e) => ArticleParagraph(e))
                                ]),
                    ),
                    Comments(articleId: _articleId),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: _isVisible ? 60.0 : 0.0,
        child: _isVisible
            ? BottomBar(_articleId)
            : Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
              ),
      ),
    );
  }
}
