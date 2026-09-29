import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_janpanese/core/widgets/app_empty_state.dart';
import 'package:practice_janpanese/core/widgets/app_error_view.dart';
import 'package:practice_janpanese/core/widgets/app_loading.dart';

/// Generic wrapper that handles loading / error / optional empty / data
/// for every list screen, so all states look identical across the app.
///
/// [isEmpty] is called when data is loaded to decide whether to show
/// [AppEmptyState] instead of calling [data].
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    super.key,
    required this.value,
    required this.data,
    this.isEmpty,
    this.emptyMessage,
    this.emptyIcon,
    this.onRetry,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final bool Function(T data)? isEmpty;
  final String? emptyMessage;
  final IconData? emptyIcon;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => value.when(
        loading: () => const AppLoading(),
        error: (e, __) => AppErrorView(
          onRetry: onRetry ?? () {},
          message: e.toString(),
        ),
        data: (value) {
          if (isEmpty != null && isEmpty!(value)) {
            return AppEmptyState(
              message: emptyMessage ?? '',
              icon: emptyIcon,
            );
          }
          return data(value);
        },
      );
}
