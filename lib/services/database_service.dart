import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_service_clone/models/booking.dart';
import 'package:quick_service_clone/models/request.dart';
import 'package:quick_service_clone/models/review.dart';
import 'package:quick_service_clone/models/service.dart';
import 'package:quick_service_clone/models/verification.dart';
import 'package:quick_service_clone/models/user_data.dart';
import 'package:quick_service_clone/shared/constants.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  //Reference
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference clientVerification =
      FirebaseFirestore.instance.collection('client-verification');
  CollectionReference serviceProviderVerification =
      FirebaseFirestore.instance.collection('service-provider-verification');
  CollectionReference services =
      FirebaseFirestore.instance.collection('services');
  CollectionReference reviews =
      FirebaseFirestore.instance.collection('reviews');
  CollectionReference bookings =
      FirebaseFirestore.instance.collection('bookings');
  CollectionReference requests =
      FirebaseFirestore.instance.collection('requests');

  Future updateServiceProviderVerification(
      ServiceProviderVerification verificationData) async {
    return await serviceProviderVerification.doc(verificationData.uid).set({
      'uid': verificationData.uid,
      'name': verificationData.name,
      'number': verificationData.number,
      'selfieImage': verificationData.selfieImage,
      'validIDImage': verificationData.validIDImage,
      'certificationImage': verificationData.certificationImage
    });
  }

  Future updateClientVerification(ClientVerification verificationData) async {
    return await clientVerification.doc(verificationData.uid).set({
      'uid': verificationData.uid,
      'name': verificationData.name,
      'number': verificationData.number,
      'selfieImage': verificationData.selfieImage,
      'validIDImage': verificationData.validIDImage
    });
  }

  Future updateUserData(UserData userData) async {
    return await users.doc(uid).set({
      'uid': uid,
      'profileImageUrl': userData.profileImageUrl,
      'name': userData.name,
      'email': userData.email,
      'age': userData.age,
      'number': userData.number,
      'bio': userData.bio,
      'sellerInfo': userData.sellerInfo,
      'educationalAttainment': userData.educationalAttainment,
      'previousSchool': userData.previousSchool,
      'ratingsSummation': userData.ratingsSummation,
      'raterCount': userData.raterCount,
      'jobsCompleted': userData.jobsCompleted,
      'verifiedClient': userData.verifiedClient,
      'verifiedServiceProvider': userData.verifiedServiceProvider
    });
  }

  UserData _userDataFromSnapShot(DocumentSnapshot snapshot) {
    UserData data = UserData.Complete(
        uid: snapshot.data()['uid'],
        profileImageUrl: snapshot.data()['profileImageUrl'],
        name: snapshot.data()['name'],
        email: snapshot.data()['email'],
        age: snapshot.data()['age'],
        number: snapshot.data()['number'],
        bio: snapshot.data()['bio'],
        sellerInfo: snapshot.data()['sellerInfo'],
        educationalAttainment: snapshot.data()['educationalAttainment'],
        previousSchool: snapshot.data()['previousSchool'],
        raterCount: snapshot.data()['raterCount'],
        ratingsSummation: snapshot.data()['ratingsSummation'],
        jobsCompleted: snapshot.data()['jobsCompleted'],
        verifiedClient: snapshot.data()['verifiedClient'],
        verifiedServiceProvider: snapshot.data()['verifiedServiceProvider']);

    return data;
  }

  Stream<UserData> get myData {
    return users.doc(uid).snapshots().map(_userDataFromSnapShot);
  }

  Future<UserData> getUserData(String id) async {
    final docSnapshot = await users.doc(id).get();
    final data = _userDataFromSnapShot(docSnapshot);
    return data;
  }

  Stream<List<Service>> get activeServices {
    try {
      return services
          .where("userUid", isNotEqualTo: uid)
          .snapshots()
          .map(_activeServicesFromSnapshot);
    } catch (e) {
      print(e);
    }
  }

  List<Service> _activeServicesFromSnapshot(QuerySnapshot snapshot) {
    final _list = snapshot.docs.map((doc) {
      if (doc.data()['isActive']== true) {
        return Service(
          uid: doc.data()['uid'],
          userUid: doc.data()['userUid'],
          price: doc.data()['price'],
          title: doc.data()['title'],
          description: doc.data()['description'],
          category: doc.data()['category'],
          isActive: doc.data()['isActive'],
        );
      }
    }).toList();

    return _list;
  }

  List<Service> _serviceListFromSnapshot(QuerySnapshot snapshot) {
    final _list = snapshot.docs.map((doc) {
      return Service(
        uid: doc.data()['uid'],
        userUid: doc.data()['userUid'],
        price: doc.data()['price'],
        title: doc.data()['title'],
        description: doc.data()['description'],
        category: doc.data()['category'],
        isActive: doc.data()['isActive'],
      );
    }).toList();

    return _list;
  }

  Future<List<Review>> fetchReviews(String serviceProviderUid) async {
    try {
      QuerySnapshot snapshot = await reviews
          .doc(serviceProviderUid)
          .collection('user-reviews')
          .get();
      return _reviewListFromSnapshot(snapshot);
    } catch (e) {
      print(e);
    }
  }

  List<Review> _reviewListFromSnapshot(QuerySnapshot snapshot) {
    final _list = snapshot.docs.map((doc) {
      return Review.Complete(
        uid: doc.data()['uid'],
        rating: doc.data()['rating'],
        review: doc.data()['review'],
        reviewerUid: doc.data()['reviewerUid'],
        timeStamp: doc.data()['timeStamp'],
      );
    });
    return _list.toList();
  }

  _incrementTotalJobsCompleted(String uid) async {
    final data = await getUserData(uid);
    data.jobsCompleted += 1;
    await updateUserData(data);
  }

  Future<bool> updateBooking(Booking booking) async {
    try {
      final clientBookingsRef =
          bookings.doc('client').collection(booking.clientUid);
      final spBookingsRef = bookings
          .doc('service-provider')
          .collection(booking.serviceProviderUid);

      await clientBookingsRef.doc(booking.uid).set({
        'uid': booking.uid,
        'category': booking.category,
        'clientUid': booking.clientUid,
        'serviceProviderUid': booking.serviceProviderUid,
        'serviceTitle': booking.serviceTitle,
        'serviceDescription': booking.serviceDescription,
        'paymentMethod': booking.paymentMethod,
        'price': booking.price,
        'address': booking.address,
        'bookingDateTime': booking.bookingDateTime,
        'status': (booking.isConfirmedByClient &&
                booking.isConfirmedByServiceProvider)
            ? Constants.bookingStatus[2]
            : booking.status,
        'isConfirmedByClient': booking.isConfirmedByClient,
        'isConfirmedByServiceProvider': booking.isConfirmedByServiceProvider,
      });
      await spBookingsRef.doc(booking.uid).set({
        'uid': booking.uid,
        'category': booking.category,
        'clientUid': booking.clientUid,
        'serviceProviderUid': booking.serviceProviderUid,
        'serviceTitle': booking.serviceTitle,
        'serviceDescription': booking.serviceDescription,
        'paymentMethod': booking.paymentMethod,
        'price': booking.price,
        'address': booking.address,
        'bookingDateTime': booking.bookingDateTime,
        'status': (booking.isConfirmedByClient &&
                booking.isConfirmedByServiceProvider)
            ? Constants.bookingStatus[2]
            : booking.status,
        'isConfirmedByClient': booking.isConfirmedByClient,
        'isConfirmedByServiceProvider': booking.isConfirmedByServiceProvider,
      });
      (booking.isConfirmedByClient && booking.isConfirmedByServiceProvider)
          ? _incrementTotalJobsCompleted(booking.serviceProviderUid)
          : null;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> createBooking(Booking booking) async {
    try {
      final clientBookingsRef =
          bookings.doc('client').collection(booking.clientUid);
      final spBookingsRef = bookings
          .doc('service-provider')
          .collection(booking.serviceProviderUid);

      await clientBookingsRef.add({
        'category': booking.category,
        'clientUid': booking.clientUid,
        'serviceProviderUid': booking.serviceProviderUid,
        'serviceTitle': booking.serviceTitle,
        'serviceDescription': booking.serviceDescription,
        'paymentMethod': booking.paymentMethod,
        'price': booking.price,
        'address': booking.address,
        'bookingDateTime': booking.bookingDateTime,
        'status': booking.status,
        'isConfirmedByClient': booking.isConfirmedByClient,
        'isConfirmedByServiceProvider': booking.isConfirmedByServiceProvider,
      }).then((value) async {
        clientBookingsRef.doc(value.id).update({'uid': value.id});
        await spBookingsRef.doc(value.id).set({
          'uid': value.id,
          'category': booking.category,
          'clientUid': booking.clientUid,
          'serviceProviderUid': booking.serviceProviderUid,
          'serviceTitle': booking.serviceTitle,
          'serviceDescription': booking.serviceDescription,
          'paymentMethod': booking.paymentMethod,
          'price': booking.price,
          'address': booking.address,
          'bookingDateTime': booking.bookingDateTime,
          'status': booking.status,
          'isConfirmedByClient': booking.isConfirmedByClient,
          'isConfirmedByServiceProvider': booking.isConfirmedByServiceProvider,
        });
      });

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Stream<List<Booking>> get getClientBookings {
    final clientBookingsRef = bookings.doc('client').collection(uid);
    return clientBookingsRef.snapshots().map(_bookingsListFromSnapshot);
  }

  Stream<List<Booking>> get getServiceProviderBookings {
    final clientBookingsRef = bookings.doc('service-provider').collection(uid);
    return clientBookingsRef.snapshots().map(_bookingsListFromSnapshot);
  }

  List<Booking> _bookingsListFromSnapshot(QuerySnapshot snapshot) {
    final _list = snapshot.docs.map((doc) {
      return Booking.Complete(
          category: doc.data()['category'],
          uid: doc.data()['uid'],
          clientUid: doc.data()['clientUid'],
          serviceProviderUid: doc.data()['serviceProviderUid'],
          serviceTitle: doc.data()['serviceTitle'],
          serviceDescription: doc.data()['serviceDescription'],
          address: doc.data()['address'],
          price: doc.data()['price'],
          bookingDateTime: doc.data()['bookingDateTime'],
          paymentMethod: doc.data()['paymentMethod'],
          status: doc.data()['status'],
          isConfirmedByClient: doc.data()['isConfirmedByClient'],
          isConfirmedByServiceProvider:
              doc.data()['isConfirmedByServiceProvider']);
    });
    return _list.toList();
  }

  Future<dynamic> deleteBooking(Booking booking) async {
    try {
      final clientBookingsRef =
          bookings.doc('client').collection(booking.clientUid);
      await clientBookingsRef.doc(booking.uid).delete();
      final spBookingsRef = bookings
          .doc('service-provider')
          .collection(booking.serviceProviderUid);
      await spBookingsRef.doc(booking.uid).delete();
      return true;
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future updateRequest(Request request) async {
    try {
      if (request.uid == null) {
        await requests.add({
          'title': request.title,
          'description': request.description,
          'category': request.category,
          'price': request.price,
          'requestedBy': request.requestedBy
        }).then((value) async {
          await requests.doc(value.id).update({'uid': value.id});
        });
      } else {
        await requests.doc(request.uid).update({
          'title': request.title,
          'description': request.description,
          'category': request.category,
          'price': request.price,
          'requestedBy': request.requestedBy
        });
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Stream<List<Request>> get myRequests {
    return requests
        .where("requestedBy", isEqualTo: uid)
        .snapshots()
        .map(_requestListFromQuerySnapShot);
  }

  Stream<List<Request>> get clientRequests {
    return requests
        .where("requestedBy", isNotEqualTo: uid)
        .snapshots()
        .map(_requestListFromQuerySnapShot);
  }

  List<Request> _requestListFromQuerySnapShot(QuerySnapshot snapshot) {
    final _list = snapshot.docs.map((doc) {
      return Request.Complete(
          uid: doc.data()['uid'],
          title: doc.data()['title'],
          requestedBy: doc.data()['requestedBy'],
          category: doc.data()['category'],
          price: doc.data()['price'],
          description: doc.data()['description']);
    }).toList();
    return _list;
  }

  Future<bool> deleteRequest(Request request) async {
    try {
      await requests.doc(request.uid).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
