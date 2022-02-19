import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/button.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/shimmer.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/components/trails/trail_tile.dart';
import 'package:hikee/components/core/mutation_builder.dart';
import 'package:hikee/models/event.dart';
import 'package:hikee/pages/event/event_binding.dart';
import 'package:hikee/pages/event/event_page.dart';
import 'package:hikee/pages/events/create_event/create_event_controller.dart';
import 'package:hikee/pages/trail/trail_controller.dart';
import 'package:hikee/pages/trail/trail_events/trail_events_controller.dart';
import 'package:intl/intl.dart';

class CreateEventPage extends GetView<CreateEventController> {
  @override
  Widget build(BuildContext context) {
    final trailController =
        Get.put(TrailController(), tag: 'create-event-${controller.trailId}');
    return Scaffold(
        appBar: HikeeAppBar(
          title: Text('Create Event'),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
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
                      label: 'Event name',
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextInput(
                      controller: controller.descriptionController,
                      label: 'Description',
                      maxLines: 5,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextInput(
                      controller: controller.dateController,
                      label: 'Date & Time',
                      onTap: () {
                        _showDatePicker(context);
                      },
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    blurRadius: 16,
                    spreadRadius: -8,
                    color: Colors.black.withOpacity(.09),
                    offset: Offset(0, -6))
              ]),
              child: MutationBuilder<Event>(
                  userOnly: true,
                  mutation: () {
                    return controller.createEvent();
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
                      minWidth: double.infinity,
                      onPressed: () {
                        mutate();
                      },
                      child: Text('Create Event'),
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
                    child: Text('OK'),
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
