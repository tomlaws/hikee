import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class RatingInput extends FormField<int> {
  RatingInput({
    String? label,
    String invalidRatingMessage = 'Error',
    InputDecoration decoration = const InputDecoration(),
    FormFieldSetter<int>? onSaved,
    FormFieldValidator<int>? validator,
    int initialValue = 0,
  }) : super(
            onSaved: onSaved,
            validator: validator ??
                (v) {
                  if (v == null || v < 1 || v > 5) {
                    return invalidRatingMessage;
                  }
                  return null;
                },
            initialValue: initialValue,
            builder: (FormFieldState<int> state) {
              final InputDecoration effectiveDecoration =
                  decoration.applyDefaults(
                Theme.of(state.context).inputDecorationTheme,
              );
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (label != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, left: 8),
                        child: Text(label,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54)),
                      ),
                    InputDecorator(
                      decoration: effectiveDecoration.copyWith(
                          errorText: state.errorText,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          isDense: true),
                      child: RatingBar.builder(
                        itemSize: 24,
                        glow: false,
                        initialRating: 0.0,
                        allowHalfRating: false,
                        itemCount: 5,
                        unratedColor: Colors.grey,
                        itemPadding: EdgeInsets.only(right: 4.0),
                        itemBuilder: (context, i) => Icon(
                          state.value != null && state.value! > i
                              ? LineAwesomeIcons.heart_1
                              : LineAwesomeIcons.heart,
                          color: Colors.pink.shade200,
                        ),
                        updateOnDrag: true,
                        onRatingUpdate: (double value) {
                          state.didChange(value.toInt());
                        },
                      ),
                    ),
                  ]);
            });
}
