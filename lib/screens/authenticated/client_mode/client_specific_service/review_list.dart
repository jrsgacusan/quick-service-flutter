import 'package:flutter/material.dart';
import 'package:quick_service_clone/models/review.dart';
import 'package:quick_service_clone/models/user_data.dart';
import 'package:quick_service_clone/screens/authenticated/client_mode/client_specific_service/review_tile.dart';

import 'package:quick_service_clone/services/database_service.dart';
import 'package:quick_service_clone/shared/widgets/loading_widget.dart';
import 'package:quick_service_clone/shared/widgets/no_result_widget.dart';

class ReviewList extends StatefulWidget {
  UserData user;

  ReviewList({this.user});

  @override
  _ReviewListState createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  List<Review> reviews = [];
  bool isLoading = false;

  @override
  void initState() {
    _fetchReviews(widget.user);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading(text: 'Fetching reviews...')
        : (reviews.length != 0 || reviews.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  return ReviewTile(
                    review: reviews[index],
                  );
                },
              )
            : NoResultWidget(
                imagePath: 'assets/no_result_brocolli.png',
                text: 'No reviews found...',
              ));
  }

  void _fetchReviews(UserData user) async {
    setState(() {
      isLoading = true;
    });
    final list = await DatabaseService().fetchReviews(user.uid);
    setState(() {
      isLoading = false;
      reviews = list;
    });
    print(reviews[0]);
  }
}
