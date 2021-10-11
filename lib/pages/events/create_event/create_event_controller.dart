import 'package:get/get.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/models/event.dart';
import 'package:hikee/providers/event.dart';
import 'package:intl/intl.dart';

class CreateEventController extends GetxController {
  final _eventProvider = Get.put(EventProvider());
  late int routeId;

  final TextInputController nameController = TextInputController();
  final TextInputController descriptionController = TextInputController();
  final TextInputController dateController = TextInputController();

  @override
  void onInit() {
    super.onInit();
    routeId = Get.arguments['routeId'];
  }

  @override
  void onClose() {
    dateController.dispose();
    super.onClose();
  }

  Future<Event> createEvent() async {
    var name = nameController.text;
    var description = descriptionController.text;
    var date = DateFormat('yyyy-MM-dd HH:mm').parse(dateController.text);
    var utcDate = date.toUtc();
    var event = await _eventProvider.createEvent(
        name: name, description: description, date: utcDate, routeId: routeId);
    return event;
  }
}
