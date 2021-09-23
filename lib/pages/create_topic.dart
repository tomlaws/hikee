import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/mutation_builder.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/models/topic.dart';
import 'package:hikee/models/topic_reply.dart';
import 'package:hikee/old_providers/topic_replies.dart';
import 'package:hikee/old_providers/topics.dart';
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
      backgroundColor: Colors.white,
      appBar: HikeeAppBar(
        closeIcon: Icons.clear,
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
              if (topicOrReply is TopicReply) {
                Navigator.of(context, rootNavigator: true).pop();
              }
              if (topicOrReply is Topic) {
                Routemaster.of(context).push('/topics/${topicOrReply.id}');
                Navigator.of(context).pop();
              }
            },
            builder: (mutate, loading) => Padding(
              padding: EdgeInsets.all(8),
              child: SizedBox(
                height: 40,
                width: 40,
                child: Button(
                  loading: loading,
                  onPressed: mutate,
                  backgroundColor: Colors.transparent,
                  icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
                ),
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
              Padding(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                child: TextInput(
                  controller: _titleController,
                  hintText: "Title",
                ),
              ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: TextInput(
                  controller: _contentController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  hintText: "Say something...",
                  expand: true,
                ),
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
