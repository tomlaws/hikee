import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hikee/components/text_input.dart';

class RouteReviewDialog extends StatefulWidget {
  const RouteReviewDialog({Key? key}) : super(key: key);

  @override
  _RouteReviewDialogState createState() => _RouteReviewDialogState();
}

class _RouteReviewDialogState extends State<RouteReviewDialog> {
  TextInputController _contentController = TextInputController();
  int _rating = 0;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create review'),
      content: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          RatingBar.builder(
            itemSize: 24,
            initialRating: _rating.toDouble(),
            allowHalfRating: false,
            itemCount: 5,
            unratedColor: Colors.grey,
            itemPadding: EdgeInsets.only(right: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            updateOnDrag: true,
            onRatingUpdate: (double value) {
              setState(() {
                _rating = value.toInt();
              });
            },
          ),
          Container(
            height: 8,
          ),
          TextInput(controller: _contentController)
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(null);
          },
        ),
        TextButton(
          child: const Text('Submit'),
          onPressed: () {
            Map<String, dynamic> result = {
              'content': _contentController.text,
              'rating': _rating,
            };
            Navigator.of(context).pop(result);
          },
        ),
      ],
    );
  }
}
