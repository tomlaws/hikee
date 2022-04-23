import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/button.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/components/core/text_input.dart';
import 'package:hikees/components/core/mutation_builder.dart';
import 'package:hikees/pages/topics/create/create_topic_controller.dart';

class CreateTopicPage extends GetView<CreateTopicController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HikeeAppBar(
        title: controller.isReplying
            ? Text('replyTopic'.tr)
            : Text('createTopic'.tr),
        actions: [
          MutationBuilder(
              userOnly: true,
              mutation: () async {
                if (controller.isReplying)
                  return await controller.createReply();
                return await controller.createTopic();
              },
              errorMapping: {
                'title': controller.titleController,
                'content': controller.contentController
              },
              builder: (mutate, loading) {
                return Button(
                  icon: Icon(Icons.send),
                  loading: loading,
                  onPressed: mutate,
                  backgroundColor: Colors.transparent,
                );
              })
        ],
      ),
      body: Column(
        children: [
          if (!controller.isReplying) ...[
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextInput(
                maxLines: 1,
                hintText: "title".tr,
                controller: controller.titleController,
              ),
            ),
          ],
          SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextInput(
                expand: true,
                hintText: "message".tr,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: controller.contentController,
              ),
            ),
          ),
          Obx(
            () => controller.images.length > 0
                ? SizedBox(
                    height: 104 + 16,
                    width: double.infinity,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                        child: Wrap(
                          spacing: 16,
                          children: controller.images
                              .map((image) => Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        width: 104,
                                        height: 104,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        child: Image.memory(image,
                                            fit: BoxFit.cover),
                                      ),
                                      Positioned(
                                          top: -4,
                                          right: -4,
                                          child: GestureDetector(
                                            onTap: () {
                                              controller.removeImage(image);
                                            },
                                            child: Container(
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 18,
                                                )),
                                          )),
                                    ],
                                  ))
                              .toList(),
                        )),
                  )
                : SizedBox(),
          ),
          Container(
              padding: EdgeInsets.all(16),
              child: SafeArea(
                child: Wrap(
                  spacing: 8.0,
                  children: [
                    Button(
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.image_rounded),
                          SizedBox(
                            width: 8,
                          ),
                          Text('addImage'.tr)
                        ]),
                        onPressed: () {
                          controller.pickImages();
                        },
                        backgroundColor: Colors.transparent,
                        secondary: true),
                    // Button(
                    //     icon: Icon(Icons.location_pin),
                    //     onPressed: () {},
                    //     backgroundColor: Colors.transparent,
                    //     secondary: true)
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // Widget _editor() {
  //   return LayoutBuilder(builder: (context, constraints) {
  //     final width = constraints.biggest.width;
  //     final height = constraints.biggest.height;
  //     return HtmlEditor(
  //       controller: controller.editorController,
  //       htmlToolbarOptions: HtmlToolbarOptions(
  //         //defaultToolbarButtons: [
  //         //StyleButtons(),
  //         //ParagraphButtons(
  //         //    lineHeight: false, caseConverter: false, textDirection: false),
  //         //InsertButtons(video: false, audio: false, table: false, hr: false)
  //         //],
  //         buttonBorderRadius: BorderRadius.circular(16),
  //         // customToolbarButtons: [
  //         //   ConstrainedBox(
  //         //     constraints: BoxConstraints(minWidth: width - 8),
  //         //     child: Row(
  //         //       children: [
  //         //         Button(
  //         //             icon: Icon(Icons.format_align_left_rounded),
  //         //             onPressed: () {
  //         //               controller.editorController.execCommand("JustifyLeft");
  //         //             },
  //         //             secondary: true,
  //         //             backgroundColor: Colors.transparent),
  //         //         Button(
  //         //             icon: Icon(Icons.format_align_center_rounded),
  //         //             onPressed: () {
  //         //               controller.editorController
  //         //                   .execCommand("JustifyCenter");
  //         //             },
  //         //             secondary: true,
  //         //             backgroundColor: Colors.transparent),
  //         //         Button(
  //         //             icon: Icon(Icons.format_align_right_rounded),
  //         //             onPressed: () {
  //         //               controller.editorController.execCommand("JustifyRight");
  //         //             },
  //         //             secondary: true,
  //         //             backgroundColor: Colors.transparent),
  //         //         Button(
  //         //             icon: Icon(Icons.image_rounded),
  //         //             onPressed: () {},
  //         //             secondary: true,
  //         //             backgroundColor: Colors.transparent)
  //         //       ],
  //         //     ),
  //         //   ),
  //         // ],
  //         mediaUploadInterceptor: (file, InsertFileType type) async {
  //           print(file.name); //filename
  //           print(file.size); //size in bytes
  //           print(file.extension); //MIME type (e.g. image/jpg)
  //           if (type == InsertFileType.image) {}
  //           // if (file.bytes != null && file.name != null) {
  //           //   final request =
  //           //       http.MultipartRequest('POST', Uri.parse("your_server_url"));
  //           //   request.files.add(http.MultipartFile.fromBytes("file", file.bytes,
  //           //       filename: file
  //           //           .name)); //your server may require a different key than "file"
  //           //   final response = await request.send();
  //           //   //try to insert as network image, but if it fails, then try to insert as base64:
  //           //   if (response.statusCode == 200) {
  //           //     controller.insertNetworkImage(response.body["url"],
  //           //         filename: file
  //           //             .name!); //where "url" is the url of the uploaded image returned in the body JSON
  //           //   } else {
  //           //     if (type == InsertFileType.image) {
  //           //       String base64Data = base64.encode(file.bytes!);
  //           //       String base64Image =
  //           //           """<img src="data:image/${file.extension};base64,$base64Data" data-filename="${file.name}"/>""";
  //           //       controller.insertHtml(base64Image);
  //           //     } else if (type == InsertFileType.video) {
  //           //       String base64Data = base64.encode(file.bytes!);
  //           //       String base64Image =
  //           //           """<video src="data:video/${file.extension};base64,$base64Data" data-filename="${file.name}"/>""";
  //           //       controller.insertHtml(base64Image);
  //           //     } else if (type == InsertFileType.audio) {
  //           //       String base64Data = base64.encode(file.bytes!);
  //           //       String base64Image =
  //           //           """<audio src="data:audio/${file.extension};base64,$base64Data" data-filename="${file.name}"/>""";
  //           //       controller.insertHtml(base64Image);
  //           //     }
  //           //   }
  //           // }
  //           return false;
  //         },
  //       ),
  //       htmlEditorOptions: HtmlEditorOptions(
  //         hint: "Your text here...",
  //       ),
  //       otherOptions: OtherOptions(
  //         height: 400,
  //       ),
  //     );
  //   });
  // }
}
