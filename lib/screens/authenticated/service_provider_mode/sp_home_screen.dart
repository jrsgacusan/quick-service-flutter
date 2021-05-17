import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_service_clone/models/booking.dart';
import 'package:quick_service_clone/models/request.dart';
import 'package:quick_service_clone/models/user_data.dart';
import 'package:quick_service_clone/screens/authenticated/client_mode/client_home_screen/manage_bookings.dart';
import 'package:quick_service_clone/screens/authenticated/service_provider_mode/sp_profile.dart';
import 'package:quick_service_clone/screens/authenticated/service_provider_mode/sp_request.dart';
import 'package:quick_service_clone/screens/authenticated/service_provider_mode/sp_services.dart';
import 'package:quick_service_clone/services/auth_service.dart';
import 'package:quick_service_clone/services/database_service.dart';
import 'package:quick_service_clone/shared/constants.dart';

class SpHomeScreen extends StatefulWidget {
  @override
  _SpHomeScreenState createState() => _SpHomeScreenState();
}

class _SpHomeScreenState extends State<SpHomeScreen> {
  int _currentIndex = 3;
  List<Widget> _list;

  List<String> _titles = ['Services', 'Bookings', 'Client requests', 'Profile'];

  @override
  void initState() {
    setState(() {
      _list = [
        SpServices(),
        StreamProvider<List<Booking>>.value(
            value: DatabaseService(uid: AuthService().currentUserUid)
                .getServiceProviderBookings,
            child: ManageBookings(
              isClientMode: false,
            )),
        StreamProvider<List<Request>>.value(
            value: DatabaseService(uid: AuthService().currentUserUid)
                .clientRequests,
            child: SpRequest()),
        SpProfile(),
      ];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserData>.value(
      value: DatabaseService(uid: AuthService().currentUserUid).myData,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: _list[_currentIndex],
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  void _choiceAction(String choice, BuildContext context) async {
    if (choice == Constants.signOut) {
      await AuthService().signOut();
      Navigator.pushReplacementNamed(context, '/wrapper');
    } else {
      Navigator.pushReplacementNamed(context, '/wrapper');
    }
  }

  _buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black54),
      elevation: 0,
      title: Text(
        '${_titles[_currentIndex]}',
        style: TextStyle(color: Colors.grey[600]),
      ),
      backgroundColor: Colors.transparent,
      actions: <Widget>[
        TextButton.icon(
            onPressed: () {}, icon: Icon(Icons.message), label: Text('')),
        PopupMenuButton<String>(
          elevation: 1,
          onSelected: (choice) {
            _choiceAction(choice, context);
          },
          itemBuilder: (BuildContext context) {
            return Constants.optionsMenu
                .map((menuItem) => PopupMenuItem<String>(
                    value: menuItem, child: Text('$menuItem')))
                .toList();
          },
        )
      ],
    );
  }

  _buildBottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      currentIndex: _currentIndex,
      elevation: 0,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Services',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt_rounded),
          label: 'Bookings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.request_page_rounded),
          label: 'Requests',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
