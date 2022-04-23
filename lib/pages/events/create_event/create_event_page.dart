import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/bottom_bar.dart';
import 'package:hikees/components/core/button.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/components/core/shimmer.dart';
import 'package:hikees/components/core/text_input.dart';
import 'package:hikees/components/trails/trail_tile.dart';
import 'package:hikees/components/core/mutation_builder.dart';
import 'package:hikees/models/event.dart';
import 'package:hikees/pages/event/event_binding.dart';
import 'package:hikees/pages/event/event_page.dart';
import 'package:hikees/pages/events/create_event/create_event_controller.dart';
import 'package:hikees/pages/trail/trail_controller.dart';
import 'package:hikees/pages/trail/trail_events/trail_events_controller.dart';
import 'package:intl/intl.dart';

class CreateEventPage extends GetView<CreateEventController> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final trailController =
        Get.put(TrailController(), tag: 'create-event-${controller.trailId}');
    return Scaffold(
        appBar: HikeeAppBar(
          title: Text('createEvent'.tr),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      trailController.obx(
                          (state) => TrailTile(
                                trail: state!,
                                onTap: () {},
                              ),
                          onLoading: Shimmer(
                            height: 100,
                          )),
                      SizedBox(
                        height: 16,
                      ),
                      TextInput(
                        controller: controller.nameController,
                        label: 'eventName'.tr,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'fieldCannotBeEmpty'
                                .trParams({'field': 'eventName'.tr});
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextInput(
                        controller: controller.descriptionController,
                        label: 'description'.tr,
                        maxLines: 5,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextInput(
                        controller: controller.dateController,
                        label: 'date'.tr,
                        onTap: () {
                          _showDatePicker(context);
                        },
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'fieldCannotBeEmpty'
                                .trParams({'field': 'date'.tr});
                          }
                          return null;
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            BottomBar(
              child: MutationBuilder<Event>(
                  userOnly: true,
                  mutation: () {
                    if (_formKey.currentState?.validate() == true)
                      return controller.createEvent();
                    else
                      throw Error();
                  },
                  onDone: (evt) {
                    if (evt != null) {
                      var id = evt.id;
                      Get.back();
                      Get.to(EventPage(),
                          transition: Transition.cupertino,
                          arguments: {'id': id},
                          binding: EventBinding());
                      var c = Get.find<TrailEventsController>();
                      c.refetch();
                    }
                  },
                  builder: (mutate, loading) {
                    return Button(
                      loading: loading,
                      minWidth: double.infinity,
                      onPressed: () {
                        mutate();
                      },
                      child: Text('createEvent'.tr),
                    );
                  }),
            )
          ],
        ));
  }

  void _showDatePicker(ctx) {
    double height = 200;
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: height + 100,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  Container(
                    height: height,
                    child: CupertinoDatePicker(
                        minimumDate: DateTime.now(),
                        maximumDate:
                            DateTime.now().add(const Duration(days: 365)),
                        initialDateTime: DateTime.now(),
                        onDateTimeChanged: (val) {
                          controller.dateTime.value = val;
                        }),
                  ),
                  // Close the modal
                  CupertinoButton(
                    child: Text('ok'.tr),
                    onPressed: () {
                      controller.dateController.text =
                          DateFormat('yyyy-MM-dd HH:mm')
                              .format(controller.dateTime.value);
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              ),
            ));
  }
}
