import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gas/touchable_opacity.dart';
import 'package:gas/typography.dart';

class SimpleTextButton extends StatelessWidget {
  const SimpleTextButton({
    required this.onTap,
    required this.text,
    this.tooltip,
    this.isErrorText = false,
    this.infiniteWidth = false,
    this.horizontalPadding = 0,
    this.secondaryColors = false,
    this.thirdColors = false,
    Key? key,
  }) : super(key: key);

  final bool secondaryColors;
  final bool thirdColors;
  final double horizontalPadding;
  final Function onTap;
  final String? tooltip;
  final String text;
  final bool isErrorText;
  final bool infiniteWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: TouchableOpacity(
        tooltip: tooltip,
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Container(
          width: infiniteWidth ? double.infinity : null,
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: kBody.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
