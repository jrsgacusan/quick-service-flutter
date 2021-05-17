import 'package:quick_service_clone/shared/constants.dart';

class Service {
  String uid;
  String userUid;
  double price;
  String title;
  String description;
  String category;
  bool isActive;




  Service(
      {this.uid,
      this.userUid,
      this.price,
      this.title,
      this.description,
      this.category,
      this.isActive});
}
