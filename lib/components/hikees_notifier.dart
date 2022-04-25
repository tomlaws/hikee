import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Getx default obx is showing ugly error when there the http request is failed
// instead we use loading widget for error state if possible
extension StateExt<T> on StateMixin<T> {
  Widget hobx(
    NotifierBuilder<T?> widget, {
    Widget Function(String? error)? onError,
    Widget? onLoading,
    Widget? onEmpty,
  }) {
    return SimpleBuilder(builder: (_) {
      if (status.isLoading) {
        return onLoading ?? const Center(child: CircularProgressIndicator());
      } else if (status.isError) {
        if (onLoading != null) return onLoading;
        return onError != null
            ? onError(status.errorMessage)
            : Center(child: Text('-'));
      } else if (status.isEmpty) {
        return onEmpty != null
            ? onEmpty
            : SizedBox.shrink(); // Also can be widget(null); but is risky
      }
      return widget(value);
    });
  }
}
