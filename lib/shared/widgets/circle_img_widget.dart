import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class CircleImgWidget extends StatelessWidget {
  double width;
  double height;
  String imagePath;
  double positionBot;
  double positionLeft;

  CircleImgWidget(
      {this.width,
      this.imagePath,
      this.height,
      this.positionBot,
      this.positionLeft});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
          bottom: positionBot,
          left: positionLeft,
          child: CircularProgressIndicator()),
      ClipOval(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            child: FadeInImage.memoryNetwork(
              width: width,
              height: height,
              fit: BoxFit.cover,
              placeholder: kTransparentImage,
              image: imagePath,
            ),
          ),
        ),
      ),
      // Positioned(bottom: positionBot, left: positionLeft, child: CircularProgressIndicator()),
    ]);
  }
}
