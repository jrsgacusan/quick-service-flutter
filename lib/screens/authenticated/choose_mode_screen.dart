import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_service_clone/models/user_data.dart';
import 'package:quick_service_clone/services/auth_service.dart';
import 'package:quick_service_clone/shared/widgets/button_widget.dart';

class ChooseModeScreen extends StatelessWidget {
  double height = AppBar().preferredSize.height;
  static const routeName = '/send_requirements_screen';

  @override
  Widget build(BuildContext context) {
    final myData = Provider.of<UserData>(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height,
        title: Text(
          'Choose mode',
          style: TextStyle(color: Colors.black54),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () async {
                await AuthService().signOut();
              },
              icon: Icon(Icons.logout),
              label: Text('')),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildFirstPart(context, myData),
            _buildSecondPart(context, myData)
          ],
        ),
      ),
    );
  }

  Widget _buildSecondPart(BuildContext context, UserData myData) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: (MediaQuery.of(context).size.height / 2) - height,
      child: Column(
        children: <Widget>[
          Expanded(
              child:
                  ClipOval(child: Image.asset('assets/service_provider.jpg'))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Use service provider mode to list different services and earn cash',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black54, letterSpacing: 2, fontSize: 18),
            ),
          ),
          RaisedGradientButton(
              child: Text(
                'Service Provider Mode',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              gradient: LinearGradient(
                colors: <Color>[Colors.tealAccent[400], Colors.teal],
              ),
              onPressed: () {
                if (myData.verifiedServiceProvider) {
                  Navigator.pushReplacementNamed(
                    context,
                    '/sp_home_screen',
                  );
                } else {
                  Navigator.pushNamed(
                    context,
                    '/send_requirements_screen',
                    arguments: [myData, false],
                  );
                }
              })
        ],
      ),
    );
  }

  Widget _buildFirstPart(BuildContext context, UserData myData) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: (MediaQuery.of(context).size.height / 2) - height,
      child: Column(
        children: <Widget>[
          Expanded(child: ClipOval(child: Image.asset('assets/client.jpg'))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Use client mode to book for quick services that you would need',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black54, letterSpacing: 2, fontSize: 18),
            ),
          ),
          RaisedGradientButton(
              child: Text(
                'Client Mode',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              gradient: LinearGradient(
                colors: <Color>[Colors.tealAccent[400], Colors.teal],
              ),
              onPressed: () {
                if (myData.verifiedClient) {
                  Navigator.pushReplacementNamed(
                    context,
                    '/client_home_screen',
                  );
                } else {
                  Navigator.pushNamed(
                    context,
                    '/send_requirements_screen',
                    arguments: [myData, true],
                  );
                }
              })
        ],
      ),
    );
  }
}
