import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/text_input.dart';
import 'package:hikees/models/topic.dart';
import 'package:hikees/models/topic_reply.dart';
import 'package:hikees/pages/topic/topic_controller.dart';
import 'package:hikees/providers/topic.dart';
import 'package:hikees/providers/upload.dart';
import 'package:hikees/utils/dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:collection';

class CreateTopicController extends GetxController {
  final _topicProvider = Get.put(TopicProvider());
  final _uploadProvider = Get.put(UploadProvider());
  final ImagePicker _picker = ImagePicker();
  final titleController = TextInputController();
  final contentController = TextInputController();
  final images = RxList<Uint8List>();
  final imageNames = RxList<String>();
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
      imageNames.add(file.name);
    }
  }

  void removeImage(Uint8List image) {
    var i = images.indexOf(image);
    images.removeAt(i);
    imageNames.removeAt(i);
  }

  Future<Topic?> createTopic() async {
    var title = titleController.text;
    var content = contentController.text;
    if (images.length > 12) {
      DialogUtils.showSimpleDialog('Error', Text('12 images at max'));
      return null;
    }
    return Get.showOverlay(
        asyncFunction: () async {
          var futures = <Future<String?>>[];
          for (int i = 0; i < images.length; i++) {
            futures.add(_uploadProvider.uploadBytes(images[i], imageNames[i]));
          }
          List<String?> uploadedImages = await Future.wait(futures);
          List<String> nonNullImages =
              uploadedImages.whereType<String>().toList();
          try {
            Topic topic = await _topicProvider.createTopic(
                title: title,
                content: content,
                images: nonNullImages,
                categoryId: categoryId);
            Get.offAndToNamed('/topics/${topic.id}');
            return topic;
          } catch (ex) {
            throw ex;
          }
        },
        loadingWidget: Center(child: CircularProgressIndicator()));
  }

  Future<TopicReply?> createReply() async {
    if (images.length > 12) {
      DialogUtils.showSimpleDialog('Error', Text('12 images at max'));
      return null;
    }
    var content = contentController.text;
    return Get.showOverlay(
        asyncFunction: () async {
          var futures = <Future<String?>>[];
          for (int i = 0; i < images.length; i++) {
            futures.add(_uploadProvider.uploadBytes(images[i], imageNames[i]));
          }
          List<String?> uploadedImages = await Future.wait(futures);
          List<String> nonNullImages =
              uploadedImages.whereType<String>().toList();
          try {
            TopicReply reply = await _topicProvider.createTopicReply(
                content: content, images: nonNullImages, topicId: topicId!);
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
          } catch (ex) {
            throw ex;
          }
        },
        loadingWidget: Center(child: CircularProgressIndicator()));
  }
}
