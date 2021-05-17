import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class CircleImgClickableWidget extends StatelessWidget {
  String imagePath;
  VoidCallback onClicked;
  Color iconColor;
  IconData icon;

  CircleImgClickableWidget({this.imagePath, this.onClicked, this.iconColor, this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          _buildImage2(),
          Positioned(bottom: 0, right: 4, child: _buildEditIcon()),
        ],
      ),
    );
  }

  Widget _buildImage2() {
    return Stack(children: [
      Positioned(bottom: 45, left: 45, child: CircularProgressIndicator()),
      ClipOval(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onClicked,
            child: FadeInImage.memoryNetwork(
              width: 128,
              height: 128,
              fit: BoxFit.cover,
              placeholder: kTransparentImage,
              image: imagePath,
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _buildImage() {
    final image = NetworkImage(imagePath);

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(
            onTap: onClicked,
          ),
        ),
      ),
    );
  }

  Widget _buildEditIcon() {
    return _buildCircle(
      color: Colors.white,
      all: 3.0,
      child: _buildCircle(
        color: iconColor,
        all: 8.0,
        child: Icon(
          icon,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCircle({Color color, double all, Widget child}) {
    return ClipOval(
      child: Container(
        color: color,
        child: child,
        padding: EdgeInsets.all(all),
      ),
    );
  }
}
