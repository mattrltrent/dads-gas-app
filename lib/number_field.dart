import 'package:flutter/material.dart';
import 'package:gas/home.dart';
import 'package:gas/typography.dart';
import 'package:http/http.dart';

class NumberField extends StatelessWidget {
  const NumberField({
    super.key,
    required this.boxFocused,
    required this.whichBoxThisIs,
    required this.value,
    required this.postFix,
  });

  final String value;
  final BoxFocused boxFocused;
  final BoxFocused whichBoxThisIs;
  final String postFix;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Editing...",
            style: kBody.copyWith(
              color: whichBoxThisIs == boxFocused ? Colors.black.withOpacity(0.2) : Colors.transparent,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              border: Border.all(
                color: whichBoxThisIs == boxFocused ? Colors.lightBlueAccent : Colors.transparent,
                width: 2,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Text(
              value + " " + postFix,
              style: kTitle.copyWith(
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
