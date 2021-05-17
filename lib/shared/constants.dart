import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quick_service_clone/models/category.dart';

const light = const Color(0xFF63E5C5);
const dark = const Color(0xff14366F);
const defaultNewUser =
    'https://www.nicepng.com/png/full/73-730154_open-default-profile-picture-png.png';
const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,

  errorBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1)),
  focusedErrorBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2)),
  enabledBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1)),
  focusedBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.teal, width: 2)),
);

class Constants {
  static const String changeMode = 'Change mode';
  static const String signOut = 'Sign out';
  static const List<String> optionsMenu = [changeMode, signOut];

  static final computerRepair = ServiceCategory(
      name: 'Computer Repair', imagePath: 'assets/services_computer.png');
  static final homeCleaning = ServiceCategory(
      name: 'Home Cleaning', imagePath: 'assets/services_homecleaning.png');
  static final electrical = ServiceCategory(
      name: 'Electrical', imagePath: 'assets/services_electrical.png');
  static final delivery = ServiceCategory(
      name: 'Delivery', imagePath: 'assets/services_delivery.png');
  static final moving =
      ServiceCategory(name: 'Moving', imagePath: 'assets/services_moving.png');
  static final homeRepair = ServiceCategory(
      name: 'Home Repair', imagePath: 'assets/services_homerepair.png');
  static final aircon =
      ServiceCategory(name: 'Aircon', imagePath: 'assets/services_aircon.png');
  static final plumbing = ServiceCategory(
      name: 'Plumbing', imagePath: 'assets/services_plumbing.png');
  static final autoRepair = ServiceCategory(
      name: 'Auto Repair', imagePath: 'assets/services_auto.png');

  static final List<ServiceCategory> serviceCategories = [
    computerRepair,
    homeCleaning,
    electrical,
    delivery,
    moving,
    homeRepair,
    aircon,
    plumbing,
    autoRepair
  ];

  //status of service
  static const String active = 'Active';
  static const String inactive = 'Inactive';

  static const List<String> paymentMethods = [
    'Cash',
    'Bank transfer',
    'Bayad center'
  ];

  static const List<String> bookingStatus = ['New', 'Accepted', 'Completed'];
}
