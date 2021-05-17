import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quick_service_clone/models/booking.dart';
import 'package:quick_service_clone/models/service.dart';
import 'package:quick_service_clone/models/user_data.dart';
import 'package:quick_service_clone/screens/authenticated/client_mode/client_home_screen/manage_bookings.dart';
import 'package:quick_service_clone/screens/authenticated/client_mode/client_home_screen/client_search.dart';
import 'package:quick_service_clone/screens/authenticated/client_mode/client_home_screen/client_service_categories.dart';
import 'package:quick_service_clone/screens/authenticated/client_mode/client_specific_category/client_specific_category.dart';
import 'package:quick_service_clone/screens/authenticated/client_mode/client_specific_service/client_specific_service.dart';
import 'package:quick_service_clone/services/auth_service.dart';
import 'package:quick_service_clone/services/database_service.dart';
import 'package:quick_service_clone/shared/constants.dart';

import 'client_profile.dart';

class ClientHomeScreen extends StatefulWidget {
  @override
  _ClientHomeScreenState createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  int _currentIndex = 0;
  List<Widget> _list;

  List<String> _titles = [
    'Service Categories',
    'Search',
    'Manage Bookings',
    'Profile'
  ];

  //choices
  @override
  void initState() {
    _list = [
      ClientServiceCategories(
        callback: () {
          setState(() {
            _currentIndex = 1;
          });
        },
      ),
      StreamProvider<List<Service>>.value(
          value:
              DatabaseService(uid: AuthService().currentUserUid).activeServices,
          child: ClientSearch()),
      StreamProvider<List<Booking>>.value(
          value: DatabaseService(uid: AuthService().currentUserUid)
              .getClientBookings, //TODO,
          child: ManageBookings(
            isClientMode: true,
          )),
      ClientProfile(),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamProvider<UserData>.value(
      value: user != null ? DatabaseService(uid: user.uid).myData : null,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black54),
          elevation: 0,
          title: Text(
            '${_titles[_currentIndex]}',
            style: TextStyle(color: Colors.grey[600]),
          ),
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            TextButton.icon(
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
                icon: Icon(Icons.search),
                label: Text('')),
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
        ),
        body: _list[_currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black54)],
          ),
          child: BottomNavigationBar(
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
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_rounded),
                label: 'Bookings',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
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
}
