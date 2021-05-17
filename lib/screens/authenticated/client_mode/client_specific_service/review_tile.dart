import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:quick_service_clone/models/review.dart';
import 'package:quick_service_clone/models/user_data.dart';
import 'package:quick_service_clone/services/database_service.dart';
import 'package:quick_service_clone/shared/constants.dart';
import 'package:quick_service_clone/shared/widgets/circle_img_widget.dart';
import 'package:quick_service_clone/shared/widgets/loading_widget.dart';
import 'package:transparent_image/transparent_image.dart';

class ReviewTile extends StatefulWidget {
  Review review;

  ReviewTile({this.review});

  @override
  _ReviewTileState createState() => _ReviewTileState();
}

class _ReviewTileState extends State<ReviewTile> {
  UserData user;
  bool isLoading = false;

  @override
  void initState() {
    _fetchUserData(widget.review.reviewerUid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? _buildLoadingTile()
        : Card(
            margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: CircleImgWidget(
                positionBot: 10,
                positionLeft: 10,
                imagePath: user.profileImageUrl,
                width: 55,
                height: 55,
              ),
              title: Text(
                "${user.name} gave ${widget.review.rating} star(s)",
                style: TextStyle(fontSize: 18, letterSpacing: 2),
              ),
              subtitle: Text(
                "${widget.review.review}",
                textAlign: TextAlign.justify,
              ),
              isThreeLine: true,
            ),
          );
  }

  void _fetchUserData(String reviewerUid) async {
    setState(() {
      isLoading = true;
    });
    final data = await DatabaseService().getUserData(reviewerUid);
    setState(() {
      user = data;
      isLoading = false;
    });
  }

  _buildLoadingTile() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: SpinKitCubeGrid(
            color: Colors.teal,
            size: 45,
          ),
        ),
      ),
    );
  }
}
