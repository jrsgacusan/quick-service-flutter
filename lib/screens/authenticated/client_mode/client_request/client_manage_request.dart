import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_service_clone/models/request.dart';
import 'package:quick_service_clone/screens/authenticated/client_mode/client_request/request_list.dart';
import 'package:quick_service_clone/services/auth_service.dart';
import 'package:quick_service_clone/services/database_service.dart';

class ClientManageRequest extends StatefulWidget {
  @override
  _ClientManageRequestState createState() => _ClientManageRequestState();
}

class _ClientManageRequestState extends State<ClientManageRequest> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Request>>.value(
      value: DatabaseService(uid: AuthService().currentUserUid).myRequests,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Manage requests'),
        ),
        body: RequestList(),
      ),
    );
  }
}
