import 'package:animations/widgets/floating_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingBottomNavBarWidget(
              imagePath: 'assets/images/animation_image.png',
              smallImagePath: 'assets/images/small_photo.png',
              maxWidth: MediaQuery.of(context).size.width,
            ),
          ),
        ],
      ),
    );
  }
}
