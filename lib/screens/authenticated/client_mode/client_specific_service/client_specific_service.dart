import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quick_service_clone/models/service.dart';
import 'package:quick_service_clone/models/user_data.dart';
import 'package:quick_service_clone/screens/authenticated/client_mode/client_specific_service/client_booking_form.dart';
import 'package:quick_service_clone/screens/authenticated/client_mode/client_specific_service/personal_details.dart';
import 'package:quick_service_clone/shared/widgets/bottom_form_widget.dart';
import 'package:quick_service_clone/shared/widgets/button_widget.dart';

class ClientSpecificService extends StatefulWidget {
  @override
  _ClientSpecificServiceState createState() => _ClientSpecificServiceState();
}

class _ClientSpecificServiceState extends State<ClientSpecificService> {
  //Dummy data
  static List<String> imgList = [
    'https://images.unsplash.com/photo-1592169813474-dd0c8e52e3bf?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80',
    'https://images.unsplash.com/photo-1618297817149-d703265028b8?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80',
    'https://images.unsplash.com/photo-1619293741048-dc91fdfd1644?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80'
  ];

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List settings = ModalRoute.of(context).settings.arguments as List;
    final bool isViewMode = settings[0];
    final Service service = settings[1];
    final UserData user = settings[2];

    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          //show bottom sheet
          BottomFormWidget(
              context: context,
              child: ClientBookingForm(
                service: service,
              )).showForm();
        },
        icon: Icon(Icons.create),
        label: Text('Book now'),
        elevation: 0,
        backgroundColor: Colors.teal.withOpacity(0.2),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildImageSlider(user, service),
              SizedBox(
                height: 8,
              ),
              _buildFirstPart(service, user),
              SizedBox(
                height: 24,
              ),
              _buildNumberDetails(service, user),
              SizedBox(
                height: 24,
              ),
              _buildAboutPart(user.sellerInfo, 'About service provider'),
              SizedBox(
                height: 24,
              ),
              _buildAboutPart(service.description, 'About this service'),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black54),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  Widget _buildImageSlider(UserData user, Service service) {
    return Container(
        child: CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 2,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        initialPage: 0,
        autoPlay: true,
      ),
      items: imageSliders,
    ));
  }

  final List<Widget> imageSliders = imgList
      .map((item) => Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(item, fit: BoxFit.cover, width: 1000.0),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(0, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Text(
                            '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ))
      .toList();

  Widget _buildFirstPart(Service service, UserData user) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          '${service.title}',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      SizedBox(
        height: 2,
      ),
      Text(
        '${service.category}',
        style: TextStyle(color: Colors.grey, fontSize: 18),
      ),
      SizedBox(
        height: 16,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60),
        child: RaisedGradientButton(
            child: Text(
              'Service Provider Details',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            gradient: LinearGradient(
              colors: <Color>[Colors.tealAccent[400], Colors.teal],
            ),
            onPressed: () {
              print('Clicked');
              BottomFormWidget(
                  context: context,
                  child: PersonalDetails(
                    user: user,
                  )).showForm();
            }),
      ),
    ]);
  }

  Widget _buildNumberDetails(Service service, UserData user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildNumber(service.price.toString(), 'Price (Php)'),
            _buildDivider(),
            _buildNumber(_getRating(user), 'User rating'),
            _buildDivider(),
            _buildNumber(user.jobsCompleted.toString(), 'Jobs completed'),
          ],
        ),
      ),
    );
  }

  _buildNumber(String value, String s) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
        ),
        SizedBox(height: 2),
        Text(
          s,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
        ),
      ],
    );
  }

  String _getRating(UserData user) {
    final rating = user.ratingsSummation / user.raterCount;
    final string = rating;
    if (rating.toString() == 'NaN') {
      return "0";
    } else {
      return string.toString();
    }
  }

  Widget _buildDivider() {
    return Container(height: 24, child: VerticalDivider());
  }

  Widget _buildAboutPart(String text, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              text.length == 0 ? 'Null' : text,
              style: TextStyle(fontSize: 16, height: 1.4, letterSpacing: 1.5),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
