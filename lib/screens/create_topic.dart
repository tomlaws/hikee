import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/mutation_builder.dart';
import 'package:hikee/components/text_input.dart';
import 'package:hikee/models/topic.dart';
import 'package:hikee/models/topic_reply.dart';
import 'package:hikee/providers/topic_replies.dart';
import 'package:hikee/providers/topics.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

class CreateTopicPage extends StatefulWidget {
  const CreateTopicPage({Key? key, this.reply = false}) : super(key: key);
  final bool reply;

  @override
  _CreateTopicPageState createState() => _CreateTopicPageState();
}

class _CreateTopicPageState extends State<CreateTopicPage> {
  TextInputController _titleController = TextInputController();
  TextInputController _contentController = TextInputController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HikeeAppBar(
        leading: Button(
          invert: true,
          onPressed: () {
            Navigator.of(context).pop();
          },
          radius: 0,
          child: Row(
            children: [
              Icon(Icons.clear, color: Theme.of(context).primaryColor),
            ],
          ),
        ),
        title: Text(
          widget.reply ? 'Reply Topic' : 'New Topic',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        actions: [
          MutationBuilder(
            mutation: () async {
              if (widget.reply) {
                TopicReply reply = await context
                    .read<TopicRepliesProvider>()
                    .createReply(_contentController.text);
                return reply;
              } else {
                Topic topic = await context.read<TopicsProvider>().createTopic(
                    _titleController.text, _contentController.text);
                return topic;
              }
            },
            onDone: (topicOrReply) {
              print(topicOrReply.runtimeType);
              if (topicOrReply is TopicReply) {
                Navigator.of(context, rootNavigator: true).pop();
              }
              if (topicOrReply is Topic) {
                Routemaster.of(context).push('/topics/${topicOrReply.id}');
                Navigator.of(context).pop();
              }
            },
            builder: (mutate, loading) => Button(
              loading: loading,
              invert: true,
              onPressed: mutate,
              radius: 0,
              child: Row(
                children: [
                  Icon(Icons.send, color: Theme.of(context).primaryColor),
                  SizedBox(
                    width: 8,
                  ),
                  Text(widget.reply ? 'REPLY' : 'POST')
                ],
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          children: [
            if (!widget.reply)
              TextInput(
                controller: _titleController,
                hintText: "Title",
                radius: 0,
                transparent: true,
              ),
            Divider(
              height: 1,
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextInput(
                      controller: _contentController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      hintText: "Say something...",
                      expand: true,
                      radius: 0,
                      transparent: true,
                    ),
                  ),
                ],
              ),
            ),
            SafeArea(
                child: Container(
              height: 56,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: Offset(0, 0),
                ),
              ]),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                      child: Button(
                          backgroundColor: Colors.transparent,
                          radius: 0,
                          icon: Icon(
                            Icons.image,
                            color: Colors.black54,
                          ),
                          onPressed: () {})),
                  Expanded(
                      child: Button(
                          backgroundColor: Colors.transparent,
                          radius: 0,
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.black54,
                          ),
                          onPressed: () {})),
                  Expanded(
                      child: Button(
                          backgroundColor: Colors.transparent,
                          radius: 0,
                          icon: Icon(
                            Icons.location_on,
                            color: Colors.black54,
                          ),
                          onPressed: () {}))
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
