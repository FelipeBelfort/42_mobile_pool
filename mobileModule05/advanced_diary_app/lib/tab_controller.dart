import 'package:flutter/material.dart';


class DefaultTabControllerListener extends StatefulWidget {
  const DefaultTabControllerListener({
    required this.onTabChanged,
    required this.child,
    super.key,
  });

  final ValueChanged<int> onTabChanged;
  final Widget child;

  @override
  State<DefaultTabControllerListener> createState() => _DefaultTabControllerListener();
}

class _DefaultTabControllerListener extends State<DefaultTabControllerListener> {
  late TabController _controller;

  void _listener() {
    final TabController? controller = _controller;

    if (controller == null || controller.indexIsChanging) {
      return;
    }
    widget.onTabChanged(controller.index);
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
