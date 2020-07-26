import 'package:flutter/material.dart';

<<<<<<< HEAD
<<<<<<< HEAD
class TotalSaved extends StatelessWidget {
=======
class TotalSaved extends StatefulWidget {
  TotalSaved({Key key}) : super(key: key);

  @override
  _TotalSavedState createState() => _TotalSavedState();
}

class _TotalSavedState extends State<TotalSaved> {
>>>>>>> WIP saved posts
=======
class TotalSaved extends StatelessWidget {
>>>>>>> add comments section
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Container(
                color: Color.fromARGB(255, 255, 235, 133),
                width: 8,
                height: 50,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("您一共收藏了23篇文章",
                        style: Theme.of(context).textTheme.bodyText2,
                        textAlign: TextAlign.left),
                    SizedBox(height: 8.0)
                  ],
                ),
              ),
              FlatButton(
                  textColor: Color.fromARGB(255, 7, 59, 76),
                  onPressed: null,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                        height: 30,
                        width: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: Color.fromARGB(255, 240, 240, 240),
                        ),
                        child: Center(
                          child: Text(
                            "查看全部",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        )),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
