import 'package:quick_service_clone/shared/constants.dart';

class Booking {
  String uid ;
  String clientUid;
  String serviceProviderUid;
  String category;
  String serviceTitle;
  String serviceDescription;
  String paymentMethod;
  double price;
  String address;
  String bookingDateTime;
  String status;
  bool isConfirmedByClient;
  bool isConfirmedByServiceProvider;

  Booking.New({
    this.category,
    this.clientUid,
    this.serviceProviderUid,
    this.serviceTitle,
    this.serviceDescription,
    this.address,
    this.price,
    this.bookingDateTime,
    this.paymentMethod,
  }) {
    this.uid = "";
    this.status = Constants.bookingStatus[0]; // New
    this.isConfirmedByClient = false;
    this.isConfirmedByServiceProvider = false;
  }

  Booking.Complete({
    this.uid,
    this.category,
    this.clientUid,
    this.serviceProviderUid,
    this.serviceTitle,
    this.serviceDescription,
    this.address,
    this.price,
    this.bookingDateTime,
    this.paymentMethod,
    this.status,
    this.isConfirmedByClient,
    this.isConfirmedByServiceProvider,
  });
}
