import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/shimmer.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/components/trail_tile.dart';
import 'package:hikee/components/mutation_builder.dart';
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
                    Text('Venue'),
                    SizedBox(
                      height: 16,
                    ),
                    trailController.obx(
                        (state) => TrailTile(
                              trail: state!,
                              onTap: () {},
                            ),
                        onLoading: Shimmer(
                          height: 100,
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text('Name'),
                    ),
                    TextInput(
                      controller: controller.nameController,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text('Description'),
                    ),
                    TextInput(
                      controller: controller.descriptionController,
                      maxLines: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text('Date'),
                    ),
                    TextInput(
                      controller: controller.dateController,
                      onTap: () {
                        _showDatePicker(context);
                      },
                    )
                  ],
                ),
              ),
            ),
            MutationBuilder<Event>(mutation: () {
              return controller.createEvent();
            }, onDone: (evt) {
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
            }, builder: (mutate, loading) {
              return Button(
                radius: 0,
                safeArea: true,
                minWidth: double.infinity,
                onPressed: () {
                  mutate();
                },
                child: Text('CREATE'),
              );
            })
          ],
        ));
  }

  DateTime _dateTime = DateTime.now();
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
                          _dateTime = val;
                        }),
                  ),
                  // Close the modal
                  CupertinoButton(
                    child: Text('OK'),
                    onPressed: () {
                      controller.dateController.text =
                          DateFormat('yyyy-MM-dd HH:mm').format(_dateTime);
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              ),
            ));
  }
}
