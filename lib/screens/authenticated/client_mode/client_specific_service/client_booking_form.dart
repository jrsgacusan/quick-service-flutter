import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:quick_service_clone/models/booking.dart';
import 'package:quick_service_clone/models/service.dart';
import 'package:quick_service_clone/services/auth_service.dart';
import 'package:quick_service_clone/services/database_service.dart';
import 'package:quick_service_clone/shared/constants.dart';
import 'package:quick_service_clone/shared/widgets/button_widget.dart';
import 'package:quick_service_clone/shared/widgets/snackbar_widget.dart';

class ClientBookingForm extends StatefulWidget {
  final Service service;

  ClientBookingForm({this.service});

  @override
  _ClientBookingFormState createState() => _ClientBookingFormState();
}

class _ClientBookingFormState extends State<ClientBookingForm> {
  final _formKey = GlobalKey<FormState>();

  String _currentAddress;
  String _currentMethod = Constants.paymentMethods[0];
  DateTime _bookingDateTime;
  final _currentDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _currentAddress == null ||
              _currentAddress == "" ||
              _bookingDateTime == null
          ? Colors.red[50]
          : Colors.green[50],
      padding: EdgeInsets.symmetric(horizontal: 36, vertical: 16),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Text(
              'Booking form',
              style: TextStyle(
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black54),
            ),
            Divider(
              height: 18,
            ),
            TextFormField(
              validator: (val) {
                return val.isEmpty ? 'Enter your address' : null;
              },
              onChanged: (val) {
                setState(() {
                  _currentAddress = val;
                });
              },
              decoration: textInputDecoration.copyWith(hintText: 'Address'),
            ),
            SizedBox(
              height: 12,
            ),
            DropdownButtonFormField(
              decoration: textInputDecoration,
              value: _currentMethod ?? Constants.paymentMethods[0],
              items: Constants.paymentMethods.map((method) {
                return DropdownMenuItem(
                  value: method,
                  child: Text('$method'),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _currentMethod = val;
                });
              },
            ),
            SizedBox(
              height: 12,
            ),
            DateTimePicker(
              type: DateTimePickerType.dateTime,
              decoration: textInputDecoration.copyWith(
                  hintText: 'Date and time needed'),
              initialValue: "",
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              dateLabelText: 'Date',
              onChanged: (val) {
                setState(() {
                  _bookingDateTime = _convertToDateTimeFromString(val);
                });
              },
              validator: (val) {
                if (_bookingDateTime == null) {
                  return "Select date and time.";
                }
                String result;
                if (_bookingDateTime.millisecondsSinceEpoch <
                    _currentDateTime.millisecondsSinceEpoch) {
                  result = "Invalid date and time.";
                } else {
                  if (!(_bookingDateTime.hour >= 8 &&
                      _bookingDateTime.hour <= 20)) {
                    result = "Invalid time.";
                  } else {
                    if (_bookingDateTime.hour >= 20 &&
                        _bookingDateTime.minute >= 1) {
                      result = "Invalid time.";
                    }
                  }
                }

                if (result == null || result == "") {
                  return null;
                } else {
                  return result;
                }
              },
            ),
            SizedBox(
              height: 12,
            ),
            RaisedGradientButton(
                child: Text(
                  'Book now',
                  style: TextStyle(color: Colors.white),
                ),
                gradient: LinearGradient(
                  colors: _currentAddress == null ||
                          _currentAddress == "" ||
                          _bookingDateTime == null
                      ? <Color>[Colors.redAccent[100], Colors.red]
                      : <Color>[Colors.tealAccent[400], Colors.teal],
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    print('Save to database.');

                    //Create the booking
                    final booking = Booking.New(
                        category: widget.service.category,
                        clientUid: AuthService().currentUserUid,
                        serviceProviderUid: widget.service.userUid,
                        serviceTitle: widget.service.title,
                        serviceDescription: widget.service.description,
                        address: _currentAddress,
                        bookingDateTime: _bookingDateTime.toString(),
                        price: widget.service.price,
                        paymentMethod: _currentMethod);
                    await DatabaseService().createBooking(booking);
                    SnackbarWidget(
                      context: context,
                      text: "Booking successfuly created.",
                      onPressed: () {},
                      label: '',
                    ).showSnackbar();
                    Navigator.pop(context);
                  }
                }),
          ],
        ),
      ),
    );
  }

  DateTime _convertToDateTimeFromString(String dateTime) {
    DateTime date = DateTime.parse(dateTime);

    return date;
  }
}
