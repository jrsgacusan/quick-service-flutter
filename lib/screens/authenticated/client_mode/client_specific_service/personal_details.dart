import 'package:flutter/material.dart';
import 'package:quick_service_clone/models/user_data.dart';
import 'package:quick_service_clone/shared/constants.dart';
import 'package:quick_service_clone/shared/widgets/circle_img_clickable_widget.dart';

class PersonalDetails extends StatelessWidget {
  final UserData user;

  PersonalDetails({this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: <Widget>[
          CircleImgClickableWidget(
            imagePath: user.profileImageUrl,
            onClicked: () {},
            iconColor: Colors.teal,
            icon: Icons.message,
          ),
          SizedBox(
            height: 8,
          ),
          _buildNameWithViewRating(context),
          Divider(
            height: 24,
          ),
          _buildDetails(),
          Divider(
            height: 24,
          ),
          _buildVerified(),
          Divider(
            height: 24,
          ),
          _buildAbout()
        ],
      ),
    );
  }

  Widget _buildDetails() {
    return IntrinsicHeight(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildUserDetails(user.age.toString(), 'Age'),
              _buildDivider(),
              _buildUserDetails(user.number.toString(), 'Number'),
              _buildDivider(),
              _buildUserDetails(user.email, 'Email'),
              _buildDivider(),
              _buildUserDetails(
                  user.previousSchool == "" ? "Null" : user.previousSchool,
                  'Previous school'),
              _buildDivider(),
              _buildUserDetails(
                  user.educationalAttainment == ""
                      ? "Null"
                      : user.educationalAttainment,
                  'Educational attainment'),
              _buildDivider(),
              _buildUserDetails(_dispalyRating(user), 'Rating'),
              _buildDivider(),
              _buildUserDetails('${user.jobsCompleted}', 'Jobs completed'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
        height: 24,
        child: VerticalDivider(
          width: 24,
        ));
  }

  Widget _buildUserDetails(String text, String s) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 2,
        ),
        Text(s)
      ],
    );
  }

  Widget _buildAbout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Bio',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            user.bio == "" || user.bio == null
                ? "Bio net yet edited"
                : user.bio,
            style: TextStyle(fontSize: 16, height: 1.4, letterSpacing: 1.5),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildNameWithViewRating(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          user.name,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 8,
        ),
        FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, '/service_provider_reviews',
                arguments: user);
          },
          label: Text(
            'View reviews',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.teal,
          elevation: 0,
          icon: Icon(
            Icons.rate_review,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  Widget _buildVerified() {
    return IntrinsicHeight(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Verified Client',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(
                  user.verifiedClient ? Icons.check_circle : Icons.cancel,
                  color: user.verifiedClient ? Colors.green : Colors.red,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Verified Service Provider',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(
                  user.verifiedServiceProvider
                      ? Icons.check_circle
                      : Icons.cancel,
                  color:
                      user.verifiedServiceProvider ? Colors.green : Colors.red,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _dispalyRating(UserData user) {
  String s;
  s = (user.ratingsSummation / user.raterCount).toString() == "NaN"
      ? "0"
      : (user.ratingsSummation / user.raterCount).toString();
  return s;
}
