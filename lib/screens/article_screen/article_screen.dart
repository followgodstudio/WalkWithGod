import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/article/article_provider.dart';
import '../../utils/utils.dart';
import '../../configurations/theme.dart';
import '../../model/comment.dart';
import '../../providers/article/articles_provider.dart';
import '../../widgets/aricle_paragraph.dart';
import '../../widgets/comment.dart' as widget;

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _articleId = ModalRoute.of(context).settings.arguments as String;
      Provider.of<ArticlesProvider>(context, listen: true)
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
      });
    }
    _isInit = false;
    super.didChangeDependencies();
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        loadedArticle.title ?? "",
                        style: Theme.of(context).textTheme.headerSmall1,
                      ),
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
                  fallbackWidth: 60,
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
                            padding: const EdgeInsets.only(
                                bottom: 10.0, left: 3, right: 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                loadedArticle.icon == null ||
                                        loadedArticle.icon.isEmpty
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
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text(
                                    loadedArticle.publisher ?? "随行",
                                    style: Theme.of(context)
                                        .textTheme
                                        .captionSmall2,
                                  ),
                                ),
                                Container(
                                    height: 12,
                                    child: VerticalDivider(
                                        color: Color.fromARGB(
                                            255, 128, 128, 128))),
                                Expanded(
                                  child: Text(
                                    loadedArticle.author ?? "匿名",
                                    style: Theme.of(context)
                                        .textTheme
                                        .captionSmall2,
                                  ),
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
                        child: _isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Consumer<ArticlesProvider>(
                                builder: (context, data, _) {
                                _content = data.articles
                                    .firstWhere((e) => e.id == _articleId)
                                    .content;
                                return _content == null || _content.isEmpty
                                    ? Center(
                                        child: Text("content is missing"),
                                      )
                                    : Column(children: [
                                        ..._content
                                            .map((e) => ArticleParagraph(e))
                                      ]);
                              })),
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
