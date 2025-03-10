import 'package:flutter/material.dart';

// class tabManager extends State<WeatherHomePage> {

//   @override
//   Widget build(BuildContext context) {
//   // Widget showTabs(Tab tabs, String searchedText) {
//     return TabBarView(
//               children: tabs.map((Tab tab) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text('${tab.text}'),
//                       Text(searchedText),
//                     ],
//                     ),
//                 );
//               }).toList(),
//               );
//   }
// }

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
