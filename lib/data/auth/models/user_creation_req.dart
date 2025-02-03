class UserCreationReq {
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? age;
  int? gender;

  UserCreationReq({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });
}
