import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quick_service_clone/models/user_data.dart';
import 'package:quick_service_clone/screens/authenticated/client_mode/client_specific_service/review_list.dart';

class ServiceProviderReviews extends StatefulWidget {
  @override
  _ServiceProviderReviewsState createState() => _ServiceProviderReviewsState();
}

class _ServiceProviderReviewsState extends State<ServiceProviderReviews> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserData user = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('${user.name}'),
      ),
      body: ReviewList(
        user: user,
      ),
    );
  }
}
