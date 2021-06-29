import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/text_input.dart';
import 'package:hikee/models/panel_position.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PanelController _pc = new PanelController();
  double _collapsedPanelHeight = 180;
  double _panelHeaderHeight = 60;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SlidingUpPanel(
            controller: _pc,
            parallaxEnabled: true,
            renderPanelSheet: false,
            maxHeight: MediaQuery.of(context).size.height,
            minHeight: _collapsedPanelHeight,
            color: Colors.transparent,
            onPanelSlide: (position) {
              Provider.of<PanelPosition>(context, listen: false)
                  .update(position);
            },
            panel: _panel(context),
            body: _body()));
  }

  Widget _panel(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Consumer<PanelPosition>(
            builder: (_, pos, __) => IgnorePointer(
                ignoring: pos.position == 0,
                child: Container(
                  height: _panelHeaderHeight,
                  color: Colors.transparent,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  child: Opacity(
                      opacity: pos.position,
                      child: Text(
                        'Discover',
                        style: TextStyle(color: Colors.white, fontSize: 32),
                      )),
                ))),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(26), topRight: Radius.circular(26)),
            ),
            child: Padding(
                padding: EdgeInsets.all(18),
                child: Column(
                  children: [
                    TextInput(
                      hintText: 'Search...',
                    )
                  ],
                )),
          ),
        )
      ],
    ));
  }

  Widget _body() {
    return Container(
        padding: EdgeInsets.only(
            bottom: _collapsedPanelHeight - (_panelHeaderHeight / 2)),
        color: Color(0xFF5DB075),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Consumer<PanelPosition>(
                      builder: (_, pos, __) => Opacity(
                          opacity: 1 - pos.position,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              DefaultTextStyle(
                                style: TextStyle(color: Colors.white),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 18, vertical: 12),
                                          height: _panelHeaderHeight,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Good Morning',
                                            style: TextStyle(fontSize: 32),
                                          ),
                                        ),
                                        Button(
                                          icon: Icon(LineAwesomeIcons.bars,
                                              color: Colors.white, size: 32),
                                          onPressed: () {},
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: Center(
                                child: Button(
                                  invert: true,
                                  child: Text('Set Your Goal'),
                                  onPressed: () {},
                                ),
                              ))
                            ],
                          )))),
              Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [],
                    ),
                    Button(
                      icon: Icon(
                        LineAwesomeIcons.alternate_undo,
                        color: Theme.of(context).primaryColor,
                      ),
                      invert: true,
                      onPressed: () {
                        // do your thing here
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
    return GestureDetector(
      onPanUpdate: (d) {
        if (d.delta.dy < 0 && _pc.isPanelClosed) _pc.open();
        if (d.delta.dy > 0 && _pc.isPanelOpen) _pc.close();
      },
      child: Container(
        color: Color(0xFF5DB075),
      ),
    );
  }
}
