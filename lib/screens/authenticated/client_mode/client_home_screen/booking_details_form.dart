import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_service_clone/models/booking.dart';
import 'package:quick_service_clone/screens/authenticated/client_mode/client_specific_service/personal_details.dart';
import 'package:quick_service_clone/services/database_service.dart';
import 'package:quick_service_clone/shared/constants.dart';
import 'package:quick_service_clone/shared/widgets/bottom_form_widget.dart';
import 'package:quick_service_clone/shared/widgets/button_widget.dart';
import 'package:quick_service_clone/shared/widgets/snackbar_widget.dart';

class BookingDetailsForm extends StatefulWidget {
  bool isClientMode;
  Booking booking;

  BookingDetailsForm({this.booking, this.isClientMode});

  @override
  _BookingDetailsFormState createState() => _BookingDetailsFormState();
}

class _BookingDetailsFormState extends State<BookingDetailsForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Text(
              'BOOKING DETAILS',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 24,
                letterSpacing: 2,
              ),
            ),
          ),
          Divider(
            height: 16,
          ),
          _buildDetails(widget.booking),
          Divider(
            height: 16,
          ),
          widget.isClientMode
              ? _buildViewProfileBtn(widget.booking.serviceProviderUid)
              : _buildViewProfileBtn(widget.booking.clientUid),
          SizedBox(
            height: 8,
          ),
          widget.isClientMode
              ? _buildClientModeBtns()
              : _buildServiceProviderModeBtns(),
        ],
      ),
    );
  }

  _buildDetails(Booking booking) {
    TextStyle style = TextStyle(fontSize: 18, letterSpacing: 1.5, height: 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Service title: ${booking.serviceTitle}',
          textAlign: TextAlign.justify,
          style: style,
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          'Category: ${booking.category}',
          textAlign: TextAlign.justify,
          style: style,
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          'Service description: ${booking.serviceDescription}',
          textAlign: TextAlign.justify,
          style: style,
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          'Price: Php ${booking.price}',
          textAlign: TextAlign.justify,
          style: style,
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          'Address: ${booking.address}',
          textAlign: TextAlign.justify,
          style: style,
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          'Date and time: ${booking.bookingDateTime}',
          textAlign: TextAlign.justify,
          style: style,
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          'Payment method: ${booking.paymentMethod}',
          textAlign: TextAlign.justify,
          style: style,
        ),
      ],
    );
  }

  Widget _buildViewProfileBtn(String uid) {
    return RaisedGradientButton(
        child: Text(
          widget.isClientMode
              ? 'View Service Provider profile'
              : 'View Client profile',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        gradient: LinearGradient(
          colors: <Color>[Colors.tealAccent[400], Colors.teal],
        ),
        onPressed: () async {
          final result = await DatabaseService().getUserData(uid);

          BottomFormWidget(
                  child: PersonalDetails(
                    user: result,
                  ),
                  context: context)
              .showForm();
        });
  }

  Widget _buildServiceProviderModeBtns() {
    return widget.booking.status == Constants.bookingStatus[0]
        ? _buildAcceptDecline()
        : (widget.booking.status == Constants.bookingStatus[1]
            ? _buildConfirmBtn()
            : SizedBox(
                height: 0,
              ));
  }

  Widget _buildClientModeBtns() {
    return widget.booking.status == Constants.bookingStatus[0]
        ? RaisedGradientButton(
            child: Text(
              'Cancel booking',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            gradient: LinearGradient(
              colors: <Color>[Colors.redAccent[400], Colors.red],
            ),
            onPressed: () async {
              dynamic result =
                  await DatabaseService().deleteBooking(widget.booking);
              String message;
              if (result) {
                message = "Booking cancelled.";
              } else {
                message = result.toString();
              }
              SnackbarWidget(
                      context: context,
                      label: '',
                      onPressed: () {},
                      text: message)
                  .showSnackbar();
              Navigator.pop(context);
            })
        : (widget.booking.status == Constants.bookingStatus[1]
            ? _buildConfirmBtn()
            : RaisedGradientButton(
                child: Text(
                  'Add review',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                gradient: LinearGradient(
                  colors: <Color>[Colors.tealAccent[400], Colors.teal],
                ),
                onPressed: () async {
                  //TODO add a review
                }));
  }

  Widget _buildConfirmBtn() {
    return RaisedGradientButton(
        child: Text(
          'Confirm booking',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        gradient: LinearGradient(
          colors: <Color>[Colors.tealAccent[400], Colors.teal],
        ),
        onPressed: () async {
          if (widget.isClientMode
              ? widget.booking.isConfirmedByClient
              : widget.booking.isConfirmedByServiceProvider) {
            SnackbarWidget(
                    context: context,
                    label: '',
                    onPressed: () {},
                    text:
                        "You already confirmed this booking. Wait for the other party's confirmation.")
                .showSnackbar();
          } else {
            Booking bookingEdited = widget.booking;
            widget.isClientMode
                ? bookingEdited.isConfirmedByClient = true
                : bookingEdited.isConfirmedByServiceProvider = true;
            dynamic result =
                await DatabaseService(uid: bookingEdited.serviceProviderUid)
                    .updateBooking(bookingEdited);
            String message;
            if (result) {
              message = "Booking confirmed.";
            } else {
              message = result.toString();
            }
            if (bookingEdited.isConfirmedByClient &&
                bookingEdited.isConfirmedByServiceProvider) {
              SnackbarWidget(
                      context: context,
                      label: '',
                      onPressed: () {},
                      text: "Booking is now completed.")
                  .showSnackbar();
            } else {
              SnackbarWidget(
                      context: context,
                      label: '',
                      onPressed: () {},
                      text: message)
                  .showSnackbar();
            }
          }
          Navigator.pop(context);
        });
  }

  _buildAcceptDecline() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: RaisedGradientButton(
              child: Text(
                'Decline booking',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              gradient: LinearGradient(
                colors: <Color>[Colors.redAccent[400], Colors.red],
              ),
              onPressed: () async {
                dynamic result =
                    await DatabaseService().deleteBooking(widget.booking);
                String message;
                if (result) {
                  message = "Booking declined.";
                } else {
                  message = result.toString();
                }
                SnackbarWidget(
                        context: context,
                        label: '',
                        onPressed: () {},
                        text: message)
                    .showSnackbar();
                Navigator.pop(context);
              }),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          flex: 1,
          child: RaisedGradientButton(
              child: Text(
                'Accept booking',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              gradient: LinearGradient(
                colors: <Color>[Colors.greenAccent[400], Colors.green],
              ),
              onPressed: () async {
                Booking _booking = widget.booking;
                _booking.status = Constants.bookingStatus[1];
                final result = await DatabaseService().updateBooking(_booking);
                if (result) {
                  Get.snackbar("Booking",
                      "Booking accepted, please stay connected with the client through the messaging feature.");
                } else {
                  Get.snackbar("Booking", "Booking declined.");
                }
                Navigator.pop(context);
              }),
        ),
      ],
    );
  }
}
