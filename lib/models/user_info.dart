import 'package:equatable/equatable.dart';

class UserInformation extends Equatable {
  String id;
  String name;
  String email;
  String password;
  String? profilePic;
  DateTime birthday;

  UserInformation({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.profilePic,
    required this.birthday,
  });

  @override
  List<Object?> get props => [id, name, email, password, profilePic, birthday];
}