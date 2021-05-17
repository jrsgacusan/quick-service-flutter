import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_service_clone/shared/constants.dart';

class ClientServiceCategories extends StatefulWidget {
  Function callback;

  ClientServiceCategories({this.callback});

  @override
  _ClientServiceCategoriesState createState() =>
      _ClientServiceCategoriesState();
}

class _ClientServiceCategoriesState extends State<ClientServiceCategories> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        children: <Widget>[
          Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage('assets/client.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      colors: [
                        Colors.black.withOpacity(.5),
                        Colors.black.withOpacity(.3)
                      ])),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'SERVICES AT DOOR STEP',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: widget.callback,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 40),
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text(
                              'Book Now',
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: Constants.serviceCategories
                  .map((serviceCategory) => Card(
                      elevation: 0,
                      color: Colors.transparent,
                      child: GestureDetector(
                        onTap: () {
                          print(serviceCategory.name.toString());
                          Navigator.pushNamed(
                              context, '/client_specific_category',
                              arguments: serviceCategory.name);
                        },
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                      fit: BoxFit.contain,
                                      image: AssetImage(
                                          serviceCategory.imagePath)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${serviceCategory.name}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black54,
                                  letterSpacing: 2,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
