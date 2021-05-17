import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_service_clone/models/request.dart';
import 'package:quick_service_clone/models/user_data.dart';
import 'package:quick_service_clone/shared/widgets/loading_widget.dart';
import 'package:quick_service_clone/shared/widgets/options_widget.dart';
import 'package:quick_service_clone/shared/widgets/circle_img_clickable_widget.dart';

class ClientProfile extends StatefulWidget {
  @override
  _ClientProfileState createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile> {
  @override
  Widget build(BuildContext context) {
    final myData = Provider.of<UserData>(context);
    if (myData == null) {
      return Loading(
        text: 'Fetching user data...',
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              CircleImgClickableWidget(
                imagePath: myData.profileImageUrl,
                icon: Icons.edit,
                onClicked: () {
                  Navigator.pushNamed(context, '/client_edit_profile');
                },
                iconColor: Colors.teal,
              ),
              Divider(
                height: 40,
                color: Colors.grey[800],
              ),
              Text(
                '${myData.name}',
                style: TextStyle(fontSize: 24, letterSpacing: 2),
              ),
              Text('Client mode'),
              Divider(
                height: 40,
                color: Colors.grey[800],
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: OptionWidget(
                        optionsLabel: 'Create request',
                        onPressed: () {
                          print('Clicked');
                          Navigator.pushNamed(context, '/client_request',
                              arguments: Request.Empty());
                        },
                        icon: Icons.edit,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: OptionWidget(
                        optionsLabel: 'Manage request',
                        onPressed: () {
                          print('Clicked');
                          Navigator.pushNamed(context, '/client_manage_request',
                              arguments: Request.Empty());
                        },
                        icon: Icons.view_list,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
