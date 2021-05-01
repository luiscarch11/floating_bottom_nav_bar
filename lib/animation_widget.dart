import 'dart:math';

import 'package:flutter/material.dart';

class AnimationWidget extends StatefulWidget {
  @override
  _AnimationWidgetState createState() => _AnimationWidgetState();
}

class _AnimationWidgetState extends State<AnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> width;
  late Animation<double> textWidth;
  late Animation<double> height;
  late Animation<double> flipValue;
  late bool isExpanded;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    controller.addListener(() {
      setState(() {});
      if (controller.isDismissed) isExpanded = false;
    });
    flipValue = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(controller);

    width = Tween<double>(begin: 100, end: 200).animate(controller);
    textWidth = Tween<double>(begin: 20, end: 100).animate(controller);
    isExpanded = false;
    height = Tween<double>(begin: 100, end: 200).animate(controller);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              color: Colors.green,
              width: width.value,
              height: height.value,
              child: Center(
                child: Container(
                  width: textWidth.value,
                  child: AnimatedSwitcher(
                    duration: const Duration(
                      seconds: 1,
                    ),
                    child: isExpanded ||
                            controller.status == AnimationStatus.forward
                        ? Text(
                            'holaaaaaaaa',
                            overflow: TextOverflow.ellipsis,
                          )
                        : Icon(Icons.ac_unit),
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(flipValue.value, flipValue.value * 100),
              child: Container(
                color: Colors.red,
                width: 100,
                height: 100,
              ),
            ),
            Container(
              color: Colors.pink,
              width: 100,
              height: 100,
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            controller.isCompleted
                ? controller.reverse()
                : controller.forward();
            if (!isExpanded) isExpanded = !isExpanded;
          },
          child: Text('press me'),
        ),
      ],
    );
  }
}
