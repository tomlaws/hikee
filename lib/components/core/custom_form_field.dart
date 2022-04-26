import 'package:flutter/material.dart';

class CustomFormField<T> extends FormField<T> {
  CustomFormField(
      {String? label,
      String invalidRatingMessage = 'Error',
      InputDecoration decoration = const InputDecoration(),
      FormFieldSetter<T>? onSaved,
      FormFieldValidator<T>? validator,
      T? initialValue,
      required Widget Function(void Function(T)) builder})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<T> state) {
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
                      child: builder(state.didChange),
                    ),
                  ]);
            });
}
