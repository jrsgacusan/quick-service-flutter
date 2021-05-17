import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String uid;
  String reviewerUid;
  String review;
  int rating;
  Timestamp timeStamp;

  Review.Complete(
      {this.uid, this.reviewerUid, this.review, this.rating, this.timeStamp});

  Review.New({
    String uid,
    String reviewerUid,
    String review,
    int rating,
  }) {
    this.timeStamp = DateTime.now().millisecondsSinceEpoch as Timestamp;
  }
}
