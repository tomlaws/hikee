import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hikee/models/panel_position.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PanelController _pc = new PanelController();
  double position = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SlidingUpPanel(
            controller: _pc,
            parallaxEnabled: true,
            maxHeight: MediaQuery.of(context).size.height,
            minHeight: 180,
            boxShadow: [],
            color: Colors.transparent,
            onPanelSlide: (position) {
              context.read<PanelPosition>().update(position);
            },
            panelBuilder: (_sc) => ChangeNotifierProvider(
                create: (context) => PanelPosition(),
                child: _panel(context, _sc)),
            body: _body()));
  }

  Widget _panel(BuildContext context, ScrollController sc) {
    return SafeArea(
        child: Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: AnimatedOpacity(
            opacity: context.watch<PanelPosition>().position,
            duration: const Duration(milliseconds: 1),
            child: Text(
              'Discover',
              style: TextStyle(color: Colors.white, fontSize: 32),
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32), topRight: Radius.circular(32)),
            ),
            child: Center(child: Text('Content')),
          ),
        )
      ],
    ));
  }

  Widget _body() {
    return Container(
        color: Color(0xFF5DB075),
        child: SafeArea(
          child: Stack(
            children: [Center(child: Text('Content'))],
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
