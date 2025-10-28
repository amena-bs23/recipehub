import '../../domain/entities/login_entity.dart';

class LoginResponseModel extends LoginResponseEntity {
  LoginResponseModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.image,
    required super.accessToken,
    required this.gender,
    required this.refreshToken,
  });

  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String gender;
  final String image;
  final String refreshToken;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
  return LoginResponseModel(
    id: json['id'] as int,
    username: json['username'] as String,
    email: json['email'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    image: json['image'] as String,
    accessToken: json['accessToken'] as String,
    gender: json['gender'] as String,
    refreshToken: json['refreshToken'] as String,
  );
}

}

class LoginRequestModel extends LoginRequestEntity {
  LoginRequestModel({required super.username, required super.password});

  factory LoginRequestModel.fromEntity(LoginRequestEntity entity) {
    return LoginRequestModel(
      username: entity.username,
      password: entity.password,
    );
  }

  Map<String, dynamic> toJson() {
  return {
    'username': username,
    'password': password,
  };
}

}
