import 'package:flutter/material.dart';
import 'package:wanandroid/ui/WebViewPage.dart';

///文章列表
class ArticleItem extends StatelessWidget {
  final itemData;

  ArticleItem(this.itemData);

  @override
  Widget build(BuildContext context) {
    ///时间与作者
    Row author = Row(
      children: <Widget>[
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "作者: ",
                ),
                TextSpan(
                  text: itemData["author"],
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
        ),
        Text(itemData["niceDate"]),
      ],
    );

    ///标题
    Text title = Text(
      itemData['title'],
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
      textAlign: TextAlign.start,
    );

    ///章节
    Text chapterName = Text(
      itemData["chapterName"],
      style: TextStyle(color: Theme.of(context).primaryColor),
    );

    ///列布局
    Column column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10.0),
          child: author,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          child: title,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
          child: chapterName,
        ),
      ],
    );

    return Card(
      elevation: 4.0,
      child: InkWell(
        child: column,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            itemData['url'] = itemData['link'];
            return WebViewPage(itemData);
          }));
        },
      ),
    );
  }
}
