import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  final Widget? child;
  final bool? inAsyncCall;

  const CustomLoading(
      {super.key,
        @required this.child,
        @required this.inAsyncCall});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    widgetList.add(child!);
    if (inAsyncCall!) {
      const modal = Stack(
        children: [
          Opacity(
            opacity: 0.7,
            child: ModalBarrier(dismissible: false, color: Colors.grey),
          ),
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      );
      widgetList.add(modal);
    }
    return Stack(
      children: widgetList,
    );
  }
}