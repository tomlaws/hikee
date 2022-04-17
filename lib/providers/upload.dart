import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:hikees/providers/shared/base.dart';
import 'package:image_picker/image_picker.dart';

class UploadProvider extends BaseProvider {
  Future<String?> upload(XFile file) async {
    Uint8List data = await file.readAsBytes();
    var params = {
      'file': MultipartFile(
        data,
        filename: '${file.name}',
      )
    };
    final form = FormData(params);
    var res = await post('upload', form);
    return res.bodyString;
  }

  Future<String?> uploadBytes(Uint8List data, String name) async {
    var params = {
      'file': MultipartFile(
        data,
        filename: name,
      )
    };
    final form = FormData(params);
    var res = await post('upload', form);
    return res.bodyString;
  }
}
