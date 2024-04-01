class userHospital {
  final int id;
  final String name;
  final String email;
  final String hospital;
  final String token;

  userHospital({
    required this.id,
    required this.name,
    required this.email,
    required this.hospital,
    required this.token,
  });

  static userHospital fromJson(Map<String, dynamic> json) {
    return userHospital(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      hospital: json['hospital'],
      token: json['token'],
    );
  }
}
