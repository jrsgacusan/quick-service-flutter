import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_service_clone/models/booking.dart';
import 'package:quick_service_clone/screens/authenticated/client_mode/client_home_screen/booking_details_form.dart';
import 'package:quick_service_clone/shared/constants.dart';
import 'package:quick_service_clone/shared/widgets/bottom_form_widget.dart';
import 'package:quick_service_clone/shared/widgets/loading_widget.dart';
import 'package:quick_service_clone/shared/widgets/no_result_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ManageBookings extends StatefulWidget {
  bool isClientMode;

  ManageBookings({this.isClientMode});

  @override
  _ManageBookingsState createState() => _ManageBookingsState();
}

class _ManageBookingsState extends State<ManageBookings> {
  PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    final _bookings = Provider.of<List<Booking>>(context);

    return _bookings == null
        ? Loading(
            text: 'Fetching your bookings...',
          )
        : Stack(
            alignment: Alignment.topCenter,
            children: [
              SmoothPageIndicator(
                  controller: _controller, // PageController
                  count: 3,
                  effect: WormEffect(
                      dotWidth: 10,
                      dotHeight: 10,
                      activeDotColor: Colors.teal), // your preferred effect
                  onDotClicked: (index) {
                    return _controller.animateToPage(index,
                        duration: Duration(microseconds: 500),
                        curve: Curves.bounceInOut);
                  }),
              PageView(
                controller: _controller,
                children: [
                  _page(Constants.bookingStatus[0], _bookings),
                  _page(Constants.bookingStatus[1], _bookings),
                  _page(Constants.bookingStatus[2], _bookings),
                ],
              ),
            ],
          );
  }

  Widget _page(String bookingStatus, List<Booking> bookings) {
    final _bookingsToDisplay =
        bookings.where((booking) => booking.status == bookingStatus).toList();

    return Column(
      children: [
        SizedBox(
          height: 16,
        ),
        Text(
          bookingStatus,
          style: TextStyle(fontSize: 24, letterSpacing: 2),
        ),
        Divider(
          height: 18,
        ),
        Expanded(
          child: _bookingsToDisplay.isEmpty
              ? NoResultWidget(
                  imagePath: 'assets/no_result_brocolli.png',
                  text: 'No $bookingStatus bookings found.',
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                    children: _bookingsToDisplay
                        .map((booking) => Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  print('tapped');
                                  BottomFormWidget(
                                      context: context,
                                      child: BookingDetailsForm(
                                        isClientMode: widget.isClientMode,
                                        booking: booking,
                                      )).showForm();
                                },
                                child: Card(
                                    elevation: 2,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            booking.serviceTitle,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 18, letterSpacing: 2),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(_displayReadableDate(
                                                  booking.bookingDateTime)),
                                              Text(_displayReadableTime(
                                                  booking.bookingDateTime)),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            'Php ${booking.price}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ))
                        .toList(),
                  ),
                ),
        ),
      ],
    );
  }

  String _displayReadableDate(String bookingDateTime) {
    final dateTime = DateTime.parse(bookingDateTime);
    final string =
        '${getMonth(dateTime.month)} ${dateTime.day}, ${dateTime.year}';
    return string;
  }

  String _displayReadableTime(String bookingDateTime) {
    final dateTime = DateTime.parse(bookingDateTime);
    final amOrPM = dateTime.hour <= 11 ? "AM" : "PM";
    final string = "${dateTime.hour}:${dateTime.minute} $amOrPM";
    return string;
  }

  String getMonth(int month) {
    switch (month) {
      case 1:
        {
          return "January";
        }
        break;
      case 2:
        {
          return "February";
        }
        break;
      case 3:
        {
          return "March";
        }
        break;
      case 4:
        {
          return "April";
        }
        break;
      case 5:
        {
          return "May";
        }
        break;
      case 6:
        {
          return "June";
        }
        break;
      case 7:
        {
          return "July";
        }
        break;
      case 8:
        {
          return "August";
        }
        break;
      case 9:
        {
          return "September";
        }
        break;
      case 10:
        {
          return "October";
        }
        break;
      case 11:
        {
          return "November";
        }
        break;
      case 12:
        {
          return "December";
        }
        break;
    }
  }
}
