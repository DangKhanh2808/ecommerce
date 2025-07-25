class UserEntity {
  final String userId;
  final String email;
  final String firstName;
  final String lastName;
  final String image;
  final int gender;
  final String role;

  UserEntity({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.image,
    required this.role,
  });
}
