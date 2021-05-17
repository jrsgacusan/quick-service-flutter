class ClientVerification {
  String uid;
  String name;
  int number;
  String selfieImage;
  String validIDImage;

  ClientVerification(
      {this.uid, this.name, this.number, this.selfieImage, this.validIDImage});
}

class ServiceProviderVerification {
  String uid;
  String name;
  int number;
  String selfieImage;
  String validIDImage;
  String certificationImage;

  ServiceProviderVerification(
      {this.uid,
      this.name,
      this.number,
      this.selfieImage,
      this.validIDImage,
      this.certificationImage});
}
