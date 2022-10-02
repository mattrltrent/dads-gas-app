import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:gas/circle_button.dart';

class ButtonRow extends StatefulWidget {
  const ButtonRow({
    super.key,
    required this.l1,
    required this.l2,
    required this.r1,
    required this.r2,
  });

  final VoidCallback l1;
  final VoidCallback l2;
  final VoidCallback r1;
  final VoidCallback r2;

  @override
  State<ButtonRow> createState() => _ButtonRowState();
}

class _ButtonRowState extends State<ButtonRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleButton(
          iconData: CupertinoIcons.minus_circle,
          onTap: () => widget.l2(),
        ),
        CircleButton(
          iconData: CupertinoIcons.minus,
          onTap: () => widget.l1(),
        ),
        CircleButton(
          iconData: CupertinoIcons.plus,
          onTap: () => widget.r1(),
        ),
        CircleButton(
          iconData: CupertinoIcons.plus_circle,
          onTap: () => widget.r2(),
        ),
      ],
    );
  }
}
