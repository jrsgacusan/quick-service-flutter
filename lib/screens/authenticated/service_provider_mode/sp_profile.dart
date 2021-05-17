import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_service_clone/models/user_data.dart';
import 'package:quick_service_clone/shared/widgets/bottom_form_widget.dart';
import 'package:quick_service_clone/shared/widgets/circle_img_clickable_widget.dart';
import 'package:quick_service_clone/shared/widgets/edit_form_widget.dart';
import 'package:quick_service_clone/shared/widgets/loading_widget.dart';

class SpProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    print(userData);
    return userData == null
        ? Loading(
            text: 'Fetching user data...',
          )
        : SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(18),
              child: Column(
                children: <Widget>[
                  CircleImgClickableWidget(
                    imagePath: userData.profileImageUrl,
                    onClicked: () {
                      Navigator.pushNamed(context, '/client_edit_profile');
                    },
                    icon: Icons.edit,
                    iconColor: Colors.teal,
                  ),
                  Divider(
                    height: 30,
                  ),
                  Text(
                    '${userData.name}',
                    style: TextStyle(fontSize: 24, letterSpacing: 2),
                  ),
                  Text(
                    'Service Provider Mode',
                  ),
                  Divider(
                    height: 30,
                  ),
                  _buildRowDigits("", 'Jobs Completed', userData.jobsCompleted,
                      context, userData),
                  SizedBox(
                    height: 12,
                  ),
                  _buildRowDigits(
                      "View reviews",
                      'Rating',
                      userData.raterCount != 0
                          ? (userData.ratingsSummation / userData.raterCount)
                              .toInt()
                          : 0,
                      context,
                      userData),
                  SizedBox(
                    height: 12,
                  ),
                  _builDetails(
                      context, "Seller Info", userData.sellerInfo, userData),
                  SizedBox(
                    height: 12,
                  ),
                  _builDetails(context, "Previous School",
                      userData.previousSchool, userData),
                  SizedBox(
                    height: 12,
                  ),
                  _builDetails(context, "Educational Attainment",
                      userData.educationalAttainment, userData),
                ],
              ),
            ),
          );
  }

  _buildRowDigits(String anotherS, String s, int jobsCompleted,
      BuildContext context, UserData userData) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                s,
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                width: 6,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/service_provider_reviews',
                      arguments: userData);
                },
                child: Text(
                  anotherS,
                  style: TextStyle(fontSize: 12, color: Colors.teal),
                ),
              ),
            ],
          ),
          Text(jobsCompleted.toString(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  _builDetails(BuildContext context, String s, String text, UserData userData) {
    int whichToEdit;
    if (text == userData.sellerInfo) {
      whichToEdit = 1;
    } else if (text == userData.previousSchool) {
      whichToEdit = 2;
    } else {
      whichToEdit = 3;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                s,
                style: TextStyle(fontSize: 24),
              ),
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: 12,
                  ),
                  onPressed: () {
                    BottomFormWidget(
                            context: context,
                            child: EditFormWidget(
                                whichToEdit: whichToEdit,
                                data: userData,
                                initVal: text))
                        .showForm();
                  })
            ],
          ),
          Text(
            text.length == 0 ? "Not yet edited." : text,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 16, letterSpacing: 1.5),
          ),
        ],
      ),
    );
  }
}
