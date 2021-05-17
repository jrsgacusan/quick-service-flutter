class UserData {
  String uid;
  String profileImageUrl;
  String name;
  String email;
  int age;
  int number;
  String bio;
  String sellerInfo;
  String educationalAttainment;
  String previousSchool;
  int ratingsSummation;
  int raterCount;
  int jobsCompleted;
  bool verifiedServiceProvider;
  bool verifiedClient;

  //new user
  UserData.NewUser(
      {this.uid,
      this.profileImageUrl,
      this.name,
      this.email,
      this.age,
      this.number,
      this.bio,

 }) {
    this.verifiedClient = false;
    this.verifiedServiceProvider = false;
    this.ratingsSummation = 0;
    this.raterCount = 0;
    this.jobsCompleted = 0;
    this.sellerInfo = "";
    this.educationalAttainment = "";
    this.previousSchool = "";
  }

  UserData.Complete({
    this.uid,
    this.profileImageUrl,
    this.name,
    this.email,
    this.age,
    this.number,
    this.bio,
    this.verifiedClient ,
    this.verifiedServiceProvider ,
    this.ratingsSummation ,
    this.raterCount ,
    this.jobsCompleted ,
    this.sellerInfo,
    this.educationalAttainment ,
    this.previousSchool ,
});

}
