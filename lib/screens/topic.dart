import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/future_selector.dart';
import 'package:hikee/components/core/infinite_scroll.dart';
import 'package:hikee/models/topic.dart';
import 'package:hikee/models/topic_reply.dart';
import 'package:hikee/models/user.dart';
import 'package:hikee/providers/auth.dart';
import 'package:hikee/providers/topic.dart';
import 'package:hikee/providers/topic_replies.dart';
import 'package:hikee/screens/create_topic.dart';
import 'package:hikee/utils/time.dart';
import 'package:provider/provider.dart';

class TopicPage extends StatefulWidget {
  final int id;
  const TopicPage({Key? key, required this.id}) : super(key: key);

  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: FutureSelector<TopicProvider, Topic>(
          init: (tp) => tp.getTopic(widget.id),
          selector: (_, tp) => tp.topic,
          builder: (_, topic, __) {
            return Column(children: [
              HikeeAppBar(title: Text(topic.title)),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      _post(
                          user: topic.user,
                          content: topic.content,
                          createdAt: topic.createdAt),
                      SizedBox(height: 16),
                      InfiniteScroll<TopicRepliesProvider, TopicReply>(
                          empty: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('No replies yet'),
                          ),
                          shrinkWrap: true,
                          selector: (p) => p.items,
                          padding: EdgeInsets.zero,
                          separator: SizedBox(height: 8),
                          builder: (reply) {
                            return _post(
                                user: reply.user,
                                content: reply.content,
                                createdAt: reply.createdAt);
                          },
                          fetch: (next) {
                            return context
                                .read<TopicRepliesProvider>()
                                .fetch(next);
                          }),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: SizedBox(
                          width: double.infinity,
                          child: Button(
                            onPressed: () {
                              context.read<AuthProvider>().mustLogin(context,
                                  () {
                                Navigator.of(context, rootNavigator: true)
                                    .push(CupertinoPageRoute(
                                        builder: (_) => CreateTopicPage(
                                              reply: true,
                                            )));
                              });
                            },
                            child: Text('Reply'),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ]);
          },
        ));
  }

  Widget _post(
      {required User user,
      required String content,
      required DateTime createdAt}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 3)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(user.nickname,
                  style: TextStyle(
                      fontWeight: FontWeight.w900, color: Colors.green[500])),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(3.0)),
                width: 6,
                height: 6,
              ),
              Text(
                TimeUtils.timeAgoSinceDate(createdAt),
                style: TextStyle(color: Colors.grey[500]),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Text(content)
        ],
      ),
    );
  }
}
