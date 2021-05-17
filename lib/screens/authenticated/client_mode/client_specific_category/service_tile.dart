import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:quick_service_clone/models/service.dart';
import 'package:quick_service_clone/models/user_data.dart';
import 'package:quick_service_clone/services/database_service.dart';
import 'package:quick_service_clone/shared/constants.dart';
import 'package:quick_service_clone/shared/widgets/circle_img_widget.dart';
import 'package:quick_service_clone/shared/widgets/loading_widget.dart';
import 'package:transparent_image/transparent_image.dart';

class ServiceTile extends StatefulWidget {
  final Service service;

  ServiceTile({this.service});

  @override
  _ServiceTileState createState() => _ServiceTileState();
}

class _ServiceTileState extends State<ServiceTile> {
  UserData user;

  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return user == null
        ? _buildLoadingTile()
        : Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
              margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
              child: ListTile(
                onTap: () {
                  Navigator.pushNamed(context, '/client_specific_service',
                      arguments: [false, widget.service, user]);
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                leading: CircleImgWidget(
                  positionBot: 10,
                  positionLeft: 10,
                  imagePath: user.profileImageUrl,
                  width: 55,
                  height: 55,
                ),
                title: Text(
                  "${widget.service.title}",
                  style: TextStyle(fontSize: 18, letterSpacing: 2),
                ),
                subtitle: Text("Php ${widget.service.price}\n"
                    "Service provider rating: ${_computeUserRating()}"),
                isThreeLine: true,
              ),
            ),
          );
  }

  void _getUserData() async {
    final userData =
        await DatabaseService().getUserData(widget.service.userUid);
    setState(() {
      user = userData;
    });
  }

  String _computeUserRating() {
    String val = "${user.ratingsSummation / user.raterCount}/5";
    return val != "NaN/5" ? val : "0.0/5";
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
