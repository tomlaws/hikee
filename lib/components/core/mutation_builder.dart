import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/text_input.dart';
import 'package:hikees/models/error/error_response.dart';
import 'package:hikees/providers/auth.dart';

class MutationBuilder<T> extends StatefulWidget {
  const MutationBuilder(
      {Key? key,
      this.userOnly = false,
      required this.mutation,
      this.onDone,
      this.errorMapping,
      required this.builder})
      : super(key: key);
  final bool userOnly;
  final Future<T?> Function() mutation;
  final void Function(T?)? onDone;
  //final void Function(ErrorResponse)? onError;
  final Map<String, TextInputController>? errorMapping;
  final Widget Function(void Function() mutate, bool) builder;
  @override
  _MutationBuilderState<T> createState() => _MutationBuilderState<T>();
}

class _MutationBuilderState<T> extends State<MutationBuilder<T>> {
  final ValueNotifier<bool> _loading = ValueNotifier<bool>(false);
  T? result;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      builder: (BuildContext context, bool loading, Widget? child) {
        return widget.builder(() async {
          if (loading) return;
          if (widget.userOnly) {
            var auth = Get.find<AuthProvider>();
            if (!auth.loggedIn.value) {
              Get.toNamed('/login');
              return;
            }
          }
          _loading.value = true;
          WidgetsBinding.instance?.addPostFrameCallback((_) async {
            try {
              //await Future.delayed(Duration(seconds: 2));
              result = await widget.mutation();
              if (widget.onDone != null) {
                widget.onDone!(result);
              }
            } catch (ex) {
              print(ex);
              if (widget.errorMapping != null && ex is ErrorResponse) {
                //errorMapping
                _handleError(ex);
              }
            }
            _loading.value = false;
          });
        }, loading);
      },
      valueListenable: _loading,
    );
  }

  _handleError(ErrorResponse response) {
    widget.errorMapping?.forEach((key, value) {
      String? error = response.getFieldError(key);
      if (error == null) {
        value.error = null;
      } else {
        value.error = "$error".trParams({'field': '$key'.tr});
      }
    });
  }
}
