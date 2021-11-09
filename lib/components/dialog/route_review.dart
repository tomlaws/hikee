import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/dialog/base.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/models/error/error_response.dart';

class TrailReviewDialog extends BaseDialog {
  const TrailReviewDialog({Key? key, required this.trailId}) : super(key: key);
  final int trailId;

  @override
  _TrailReviewDialogState createState() => _TrailReviewDialogState();
}

class _TrailReviewDialogState extends State<TrailReviewDialog> {
  TextInputController _contentController = TextInputController();
  int _rating = 0;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('How would you rate this trail?'),
        SizedBox(
          height: 8,
        ),
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
        SizedBox(
          height: 16,
        ),
        Text('Comment'),
        SizedBox(
          height: 8,
        ),
        TextInput(
          controller: _contentController,
          maxLines: 3,
        )
      ],
    );
    List<Widget> buttons = [
      Button(
        child: const Text('CANCEL'),
        backgroundColor: Colors.grey,
        onPressed: () {
          Navigator.of(context).pop(null);
        },
      ),
      Button(
        child: const Text('SUBMIT'),
        onPressed: () async {
          try {
            Map<String, dynamic> result = {
              'content': _contentController.text,
              'rating': _rating,
            };
            String content = _contentController.text;
            int rating = _rating;
            //await context
            //    .read<TrailReviewsProvider>()
            //   .createTrailReview(widget.trailId, content, rating);
            Navigator.of(context).pop(result);
          } catch (ex) {
            if (ex is ErrorResponse) {
              _contentController.error = ex.getFieldError('content');
            }
          }
        },
      ),
    ];
    return super.widget.build(context, content, buttons);
  }
}
