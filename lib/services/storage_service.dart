import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:quick_service_clone/models/verification.dart';
import 'package:quick_service_clone/models/user_data.dart';
import 'package:quick_service_clone/services/database_service.dart';

class StorageService {
  //Uid
  final String uid;

  StorageService({this.uid});

  //references
  final Reference profileImagesRef =
      FirebaseStorage.instance.ref('profile-images');
  final Reference clientRequirementsRef =
      FirebaseStorage.instance.ref('client-requirements');
  final Reference serviceProviderRequirementsRef =
      FirebaseStorage.instance.ref('service-provider-requirements');

  Future uploadProfileImage(File image) async {
    try {
      Reference ref = profileImagesRef.child('/$uid');
      await ref.putFile(image);
      return 'successful';
    } catch (e) {
      //return an error message not a user
      return e;
    }
  }

  Future uploadServiceProviderRequirements(
      File selfie, File validID, File certifcation, UserData user) async {
    try {
      Reference selfieRef =
          clientRequirementsRef.child(uid).child('selfie-image');
      await selfieRef.putFile(selfie);

      Reference validIDRef =
          clientRequirementsRef.child(uid).child('validID-image');
      await validIDRef.putFile(validID);

      Reference certificationRef =
          clientRequirementsRef.child(uid).child('certification-image');
      await certificationRef.putFile(certifcation);

      Map urls = new Map();
      await selfieRef
          .getDownloadURL()
          .then((value) => urls['selfieUrl'] = value);
      await validIDRef
          .getDownloadURL()
          .then((value) => urls['validIDUrl'] = value);
      await certificationRef
          .getDownloadURL()
          .then((value) => urls['certificationUrl'] = value);
      print(urls);

      ServiceProviderVerification verificationData =
          ServiceProviderVerification(
              uid: uid,
              name: user.name,
              number: user.number,
              selfieImage: urls['selfieUrl'],
              validIDImage: urls['validIDUrl'],
              certificationImage: urls['certificationUrl']);

      await DatabaseService()
          .updateServiceProviderVerification(verificationData);
      print('Service provider verifcation created.');
    } catch (e) {
      print('Storage Service - uploadServiceProviderRequirements() -$e ');
      return e;
    }
  }

  Future uploadClientRequirements(
      File selfie, File validID, UserData user) async {
    try {
      Reference selfieRef =
          clientRequirementsRef.child(uid).child('selfie-image');
      await selfieRef.putFile(selfie);

      Reference validIDRef =
          clientRequirementsRef.child(uid).child('validID-image');
      await validIDRef.putFile(validID);

      Map urls = new Map();
      await selfieRef
          .getDownloadURL()
          .then((value) => urls['selfieUrl'] = value);
      await validIDRef
          .getDownloadURL()
          .then((value) => urls['validIDUrl'] = value);
      print(urls);

      ClientVerification verificationData = ClientVerification(
          uid: uid,
          name: user.name,
          number: user.number,
          selfieImage: urls['selfieUrl'],
          validIDImage: urls['validIDUrl']);

      await DatabaseService().updateClientVerification(verificationData);

      print('Client verifcation created.');
      return urls;
    } catch (e) {
      print('Upload failed - Storage Service - uploadClientRequirements');
      print(e);
      return e;
    }
  }
}
