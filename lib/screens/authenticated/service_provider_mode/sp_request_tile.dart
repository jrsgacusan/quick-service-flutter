import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:quick_service_clone/models/request.dart';
import 'package:quick_service_clone/screens/authenticated/client_mode/client_specific_service/personal_details.dart';
import 'package:quick_service_clone/services/database_service.dart';
import 'package:quick_service_clone/shared/constants.dart';
import 'package:quick_service_clone/shared/widgets/bottom_form_widget.dart';

class SpRequestTile extends StatelessWidget {
  Request request;
  VoidCallback function;
  VoidCallback functionStop;

  SpRequestTile({this.request, this.function, this.functionStop});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: Card(
          child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: _getColor(request.category),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              width: double.infinity,
              padding: EdgeInsets.all(12),
              child: Center(
                  child: Text(
                request.category,
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2),
              )),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  request.title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: .5),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Php ${request.price.toString()}",
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: .5),
                ),
              ],
            ),
            Text(
              request.description,
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, letterSpacing: 1.5),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                    onPressed: () async {
                      function();
                      final user = await DatabaseService()
                          .getUserData(request.requestedBy);
                      functionStop();
                      BottomFormWidget(
                          context: context,
                          child: PersonalDetails(
                            user: user,
                          )).showForm();
                    },
                    child: Text('View Profile')),
                MaterialButton(onPressed: () {}, child: Text('Send Message')),
              ],
            ),
          ],
        ),
      )),
    );
  }

  Color _getColor(String category) {
    List list = Constants.serviceCategories.map((e) => e.name).toList();
    if (category == list[0]) {
      return Colors.redAccent;
    }
    if (category == list[1]) {
      return Colors.purpleAccent;
    }
    if (category == list[2]) {
      return Colors.blueAccent;
    }
    if (category == list[3]) {
      return Colors.orangeAccent;
    }
    if (category == list[4]) {
      return Colors.deepPurpleAccent;
    }
    if (category == list[5]) {
      return Colors.lightBlueAccent;
    }
    if (category == list[6]) {
      return Colors.pinkAccent;
    }
    if (category == list[7]) {
      return Colors.green;
    }
    if (category == list[8]) {
      return Colors.amberAccent;
    }
  }
}
