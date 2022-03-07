import 'package:get/get.dart';
import 'package:hikees/components/core/text_input.dart';
import 'package:hikees/models/event.dart';
import 'package:hikees/providers/event.dart';
import 'package:intl/intl.dart';

class CreateEventController extends GetxController {
  final _eventProvider = Get.put(EventProvider());
  late int trailId;

  final TextInputController nameController = TextInputController();
  final TextInputController descriptionController = TextInputController();
  final TextInputController dateController = TextInputController();
  final dateTime = Rx(DateTime.now());

  @override
  void onInit() {
    super.onInit();
    trailId = int.parse(Get.parameters['trailId']!);
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
        name: name, description: description, date: utcDate, trailId: trailId);
    return event;
  }
}
