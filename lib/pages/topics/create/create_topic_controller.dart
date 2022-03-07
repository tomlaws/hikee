import 'dart:typed_data';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/text_input.dart';
import 'package:hikees/models/topic.dart';
import 'package:hikees/models/topic_reply.dart';
import 'package:hikees/pages/topic/topic_controller.dart';
import 'package:hikees/providers/topic.dart';
import 'package:image_picker/image_picker.dart';

class CreateTopicController extends GetxController {
  final _topicProvider = Get.put(TopicProvider());
  final ImagePicker _picker = ImagePicker();
  final titleController = TextInputController();
  final contentController = TextInputController();
  final images = RxList<Uint8List>();
  int? topicId;
  int? categoryId;

  @override
  void onInit() {
    super.onInit();
    categoryId = Get.arguments?['categoryId'];
    topicId = int.tryParse(Get.parameters['topicId'] ?? '');
  }

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    super.onClose();
  }

  bool get isReplying {
    return topicId != null;
  }

  void pickImages() async {
    List<XFile> files =
        await _picker.pickMultiImage(imageQuality: 80, maxWidth: 1280) ?? [];
    for (var file in files) {
      images.add(await file.readAsBytes());
    }
  }

  void removeImage(Uint8List image) {
    images.remove(image);
  }

  Future<Topic?> createTopic() async {
    var title = titleController.text;
    var content = contentController.text;
    Topic topic = await _topicProvider.createTopic(
        title: title, content: content, images: images, categoryId: categoryId);
    Get.offAndToNamed('/topics/${topic.id}');
    return topic;
    // return Get.showOverlay(
    //     asyncFunction: () async {
    //       try {
    //         var title = titleController.text;
    //         var content = contentController.text;
    //         Topic topic = await _topicProvider.createTopic(
    //             title: title,
    //             content: content,
    //             images: images,
    //             categoryId: categoryId);
    //         Get.offAndToNamed('/topics/${topic.id}');
    //         return topic;
    //       } catch (ex) {
    //         throw ex;
    //       }
    //     },
    //     loadingWidget: Center(child: CircularProgressIndicator()));
  }

  Future<TopicReply?> createReply() async {
    var content = contentController.text;
    TopicReply reply = await _topicProvider.createTopicReply(
        content: content, images: images, topicId: topicId!);
    var topicController = Get.find<TopicController>();
    var repliesState = topicController.topicReplyController.state;
    if (repliesState?.hasMore == false) {
      repliesState?..data.add(reply);
      topicController.topicReplyController.forceUpdate(repliesState);
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        topicController.scrollController.animateTo(
          topicController.scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 500),
        );
      });
    }
    Get.back();
    return reply;
  }
}
