import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_service_clone/models/request.dart';
import 'package:quick_service_clone/services/database_service.dart';
import 'package:quick_service_clone/shared/widgets/snackbar_widget.dart';

class RequestTile extends StatelessWidget {
  Request request;

  RequestTile({this.request});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                request.title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    letterSpacing: 2),
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                request.category,
                style: TextStyle(letterSpacing: 3, fontSize: 18),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () async {}, child: Text('VIEW MESSAGES')),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/client_request',
                            arguments: request);
                      },
                      child: Text('EDIT')),
                  TextButton(
                      onPressed: () async {
                        final result =
                            await DatabaseService().deleteRequest(request);
                        if (result) {
                          Get.snackbar('Request deletion',
                              'Request successfully deleted.');
                        }
                      },
                      child: Text('DELETE'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
