//Simple user entity
import 'package:intl/intl.dart';

class SimpleUser {
  int? id;
  String? name;
  String? surname;
  DateTime? birthDt;
  String? gender;
  String? email;
  String? tel;
  String? avatarImg;

  SimpleUser(
      {this.id,
      this.name,
      this.surname,
      this.birthDt,
      this.gender,
      this.email,
      this.tel,
      this.avatarImg});

  //Json -> SimpleUser
  factory SimpleUser.fromJson(Map<String, dynamic> json) {
    final birthDtInfo = json['birthDt'];
    DateFormat format = DateFormat('yyyy-MM-dd');
    DateTime birthInCorrectFormat = format.parse(birthDtInfo);

    return SimpleUser(
      id: json['userId'],
      name: json['name'],
      surname: json['surname'],
      birthDt: birthInCorrectFormat,
      gender: json['gender'],
      email: json['email'],
      tel: json['tel'],
    );
  }

  //SimpleUser -> Json
  Map<String, dynamic> toJson() {
    String birthDtInCorrectFormat = DateFormat('yyyy-MM-dd').format(birthDt!);

    return {
      'userId': id,
      'name': name,
      'surname': surname,
      'birthDt': birthDtInCorrectFormat,
      'gender': gender,
      'email': email,
      'tel': tel,
    };
  }

  Map<String, dynamic> toJsonForCreateEvent() {
    return {
      'userId': id,
    };
  }
}
