import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_service_clone/models/service.dart';
import 'package:quick_service_clone/screens/authenticated/client_mode/client_specific_category/service_list.dart';

import 'package:quick_service_clone/services/auth_service.dart';
import 'package:quick_service_clone/services/database_service.dart';

class ClientSpecificCategory extends StatefulWidget {
  @override
  _ClientSpecificCategoryState createState() => _ClientSpecificCategoryState();
}

class _ClientSpecificCategoryState extends State<ClientSpecificCategory> {
  @override
  Widget build(BuildContext context) {
    final serviceCategory = ModalRoute.of(context).settings.arguments;

    return StreamProvider<List<Service>>.value(
      value: DatabaseService(uid: AuthService().currentUserUid).activeServices,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(serviceCategory),
            actions: <Widget>[
              TextButton.icon(
                  style: TextButton.styleFrom(primary: Colors.white),
                  onPressed: () {},
                  icon: Icon(Icons.filter_alt),
                  label: Text(
                    'Filter',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
          body: ServiceList(
            category: serviceCategory,
          )),
    );
  }
}
