import 'package:flutter/widgets.dart';
import 'package:hikee/models/route.dart';

class HikingRouteTile extends StatefulWidget {
  final HikingRoute route;
  final void Function()? onTap;
  const HikingRouteTile({Key? key, required this.route, this.onTap})
      : super(key: key);

  @override
  _HikingRouteTileState createState() => _HikingRouteTileState();
}

class _HikingRouteTileState extends State<HikingRouteTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 180,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.route.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(widget.route.name_en,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}
