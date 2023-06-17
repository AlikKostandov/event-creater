//Simple user entity
class SimpleUser {
  int? id;
  String name;
  String surname;
  String birthDt;
  String gender;
  String email;
  String? tel;
  String? regDt;

  SimpleUser(
      {this.id,
      required this.name,
      required this.surname,
      required this.birthDt,
      required this.gender,
      required this.email,
      this.tel,
      this.regDt});

  //Json -> SimpleUser
  factory SimpleUser.fromJson(Map<String, dynamic> json) {
    return SimpleUser(
      id: json['userid'],
      name: json['name'],
      surname: json['surname'],
      birthDt: json['birthDt'],
      gender: json['gender'],
      email: json['email'],
      tel: json['tel'],
      regDt: json['registrationDt'],
    );
  }

  //SimpleUser -> Json
  Map<String, dynamic> toJson() {
    return {
      'userId': id,
      'name': name,
      'surname': surname,
      'birthDt': birthDt,
      'gender': gender,
      'email': email,
      'tel': tel,
      'registrationDt': regDt
    };
  }
}
