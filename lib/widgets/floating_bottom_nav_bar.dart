import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

class FloatingBottomNavBarWidget extends StatefulWidget {
  const FloatingBottomNavBarWidget({
    Key? key,
    required this.maxWidth,
    this.baseWidth = 185.0,
    this.baseHeight = 70.0,
    required this.imagePath,
    required this.text,
    required this.smallImagePath,
    this.foldedLeftIcon,
    this.color,
  }) : super(key: key);
  final double maxWidth;
  final double baseWidth;
  final double baseHeight;
  final String text;
  final Widget? foldedLeftIcon;
  final String imagePath;
  final Color? color;
  final String smallImagePath;
  @override
  _FloatingBottomNavBarWidgetState createState() =>
      _FloatingBottomNavBarWidgetState();
}

class _FloatingBottomNavBarWidgetState extends State<FloatingBottomNavBarWidget>
    with SingleTickerProviderStateMixin {
  late Animation<double> width;
  late Animation<double> height;
  late Animation<double> padding;
  late AnimationController controller;
  late Tween<double> widthTween;
  late Tween<double> paddingTween;
  late Tween<double> heightTween;
  double substraction = 0;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: kTabScrollDuration,
    );
    widthTween = Tween<double>(
      begin: 0,
      end: widget.maxWidth,
    );
    paddingTween = Tween<double>(
      begin: -20,
      end: 0,
    );
    heightTween = Tween<double>(
      begin: 0,
      end: _maxHeight - baseHeight,
    );
    width = widthTween.animate(controller);
    height = heightTween.animate(controller);
    padding = paddingTween.animate(controller);
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, padding.value),
      child: GestureDetector(
        onTap: _expandOrFold,
        onVerticalDragEnd: _foldOrExpandFromVelocity,
        onVerticalDragUpdate: _changeSizeContainerSizeFromDrag,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: _widthValue,
          curve: Curves.easeInOut,
          padding: const EdgeInsets.only(
            top: 15,
            bottom: 10,
            left: 15,
            right: 15,
          ),
          decoration: BoxDecoration(
            color: widget.color ?? BottomNavBarColors.primary,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(
                    controller.status == AnimationStatus.dismissed ? 20 : 30),
                bottom: Radius.circular(
                    (controller.status == AnimationStatus.dismissed ||
                            controller.isAnimating)
                        ? 20
                        : 0)),
          ),
          height: _heigthValue,
          constraints: BoxConstraints(
            minWidth: baseWidth,
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: _maxHeight,
            minHeight: baseHeight,
          ),
          child: controller.status == AnimationStatus.dismissed ||
                  controller.status == AnimationStatus.forward
              ? _FoldedContent(
                  widget: widget,
                )
              : _ExpandedContent(
                  widget: widget,
                ),
        ),
      ),
    );
  }

  void _expandOrFold() {
    if (controller.value > 0) {
      final currentHeight = height.value + substraction;
      controller.reverse(from: currentHeight / 100);
    } else
      controller.animateTo(1);

    substraction = 0;
  }

  void _changeSizeContainerSizeFromDrag(DragUpdateDetails details) {
    if (details.delta.dy > 0) {
      setState(() {
        substraction = substraction - _maxHeight * .01;
      });
    } else {
      setState(() {
        substraction = substraction + _maxHeight * .01;
      });
    }
  }

  void _foldOrExpandFromVelocity(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity > 1000 || (_heigthValue < _maxHeight / 2 && velocity >= 0)) {
      controller.reverse(from: _heigthValue / _maxHeight);
    } else {
      setState(() {
        substraction = 0;
      });
    }
  }

  double get baseWidth => widget.baseWidth;
  double get baseHeight => widget.baseHeight;

  double get _maxHeight => 500;
  double get _widthValue {
    final withToReturn = baseWidth + width.value + substraction;
    return withToReturn;
  }

  double get _heigthValue {
    final heightToReturn = baseHeight + height.value + substraction;
    return heightToReturn;
  }
}

class _FoldedContent extends StatelessWidget {
  const _FoldedContent({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final FloatingBottomNavBarWidget widget;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 10, end: 0),
      duration: const Duration(
        milliseconds: 600,
      ),
      builder: (context, value, child) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Transform.translate(
            offset: Offset(0, value),
            child: widget.foldedLeftIcon ??
                Icon(
                  Icons.copy_rounded,
                  color: BottomNavBarColors.secondary,
                ),
          ),
          Hero(
            tag: widget.imagePath,
            child: _RoundedPhoto(
              path: widget.imagePath,
              size: 45,
            ),
          ),
          Transform.translate(
            offset: Offset(0, value),
            child: _RoundedPhoto(
              path: widget.smallImagePath,
              size: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandedContent extends StatelessWidget {
  const _ExpandedContent({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final FloatingBottomNavBarWidget widget;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 20,
          ),
          Hero(
            tag: widget.imagePath,
            child: Container(
              width: 120,
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  widget.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Text(
            widget.text,
            style: TextStyle(
              color: BottomNavBarColors.secondary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 600),
            tween: Tween<double>(
              begin: 0,
              end: 1,
            ),
            builder: (context, value, child) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Opacity(
                  opacity: value,
                  child: Icon(
                    CupertinoIcons.shuffle,
                    color: BottomNavBarColors.secondary,
                  ),
                ),
                Opacity(
                  opacity: value,
                  child: Icon(
                    CupertinoIcons.pause,
                    color: BottomNavBarColors.secondary,
                    size: 36,
                  ),
                ),
                Opacity(
                  opacity: value,
                  child: Icon(
                    Icons.speed_outlined,
                    color: BottomNavBarColors.secondary,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundedPhoto extends StatelessWidget {
  const _RoundedPhoto({
    Key? key,
    required this.path,
    required this.size,
  }) : super(key: key);
  final String path;
  final double size;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size,
      backgroundImage: AssetImage(
        path,
      ),
    );
  }
}
