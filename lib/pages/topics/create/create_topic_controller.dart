import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/models/topic.dart';
import 'package:hikee/providers/topic.dart';
import 'package:image_picker/image_picker.dart';

class CreateTopicController extends GetxController {
  final _topicProvider = Get.put(TopicProvider());
  final ImagePicker _picker = ImagePicker();
  final titleController = TextInputController();
  final contentController = TextInputController();
  final images = RxList<Uint8List>();
  int? categoryId;

  @override
  void onInit() {
    super.onInit();
    categoryId = Get.arguments?['categoryId'];
  }

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    super.onClose();
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
    return Get.showOverlay(
        asyncFunction: () async {
          try {
            var title = titleController.text;
            var content = contentController.text;
            Topic topic = await _topicProvider.createTopic(
                title: title,
                content: content,
                images: images,
                categoryId: categoryId);
            Get.offAndToNamed('/topics/${topic.id}');
            return topic;
          } catch (ex) {
            throw ex;
          }
        },
        loadingWidget: Center(child: CircularProgressIndicator()));
  }
}
