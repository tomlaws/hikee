import 'package:flutter/material.dart';
import 'package:hikee/models/topic.dart';
import 'package:hikee/utils/time.dart';

class TopicTile extends StatefulWidget {
  final Topic topic;
  final void Function()? onTap;
  const TopicTile({Key? key, required this.topic, this.onTap})
      : super(key: key);

  @override
  _TopicTileState createState() => _TopicTileState();
}

class _TopicTileState extends State<TopicTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 3)]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(top: 16.0, left: 16, right: 16, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(widget.topic.user.nickname,
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.green[500])),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(3.0)),
                          width: 6,
                          height: 6,
                        ),
                        Text(
                          TimeUtils.timeAgoSinceDate(widget.topic.createdAt),
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                    Row(children: [
                      Row(
                        children: [
                          Icon(
                            Icons.chat_bubble,
                            size: 16,
                            color: Colors.green[200],
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(widget.topic.replyCount.toString(),
                              style: TextStyle(color: Colors.green[300]))
                        ],
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.thumb_up,
                            size: 16,
                            color: Colors.blue[200],
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(widget.topic.likeCount.toString(),
                              style: TextStyle(color: Colors.blue[300]))
                        ],
                      )
                    ]),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 16.0, left: 16, right: 16),
                child: Text(
                    widget.topic.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,),
              )
            ],
          ),
        ));
  }
}
