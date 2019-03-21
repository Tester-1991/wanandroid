import 'package:flutter/material.dart';

///收藏列表布局
class CollectItem extends StatelessWidget {
  final itemData;

  CollectItem(this.itemData);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Container(
        height: 120.0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ///标题
              Text(
                itemData['title'],
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 18.0),
                child: Text(
                  "作者: " + itemData['author'],
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(
          ),
        )),
      ),
    );
  }
}
