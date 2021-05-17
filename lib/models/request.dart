class Request {
  String uid;
  String title;
  String description;
  double price;
  String category;
  String requestedBy;

  Request.New({this.title, this.price, this.category, this.description, this.requestedBy});

  Request.Complete(
      {this.uid, this.title, this.price, this.category, this.description, this.requestedBy});

  Request.Empty({this.uid});
}
