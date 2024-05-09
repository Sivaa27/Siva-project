class Equipment {
  final int id;
  final String eq_name;
  final String eq_serial;
  final String eq_manuf;
  final String eq_hospital;
  final String eq_department;
  final String eq_ward;
  final String eq_pic;
  final String eq_class;
  final String eq_type;
  final String date;
  final String nextdate;

  Equipment({
    required this.id,
    required this.eq_name,
    required this.eq_serial,
    required this.eq_manuf,
    required this.eq_hospital,
    required this.eq_department,
    required this.eq_ward,
    required this.eq_pic,
    required this.eq_class,
    required this.eq_type,
    required this.date,
    required this.nextdate,
  });

  static Equipment fromJson(Map<String, dynamic> json) => Equipment(
    id: json['id'],
    eq_name: json['eq_name'],
    eq_serial: json['eq_serial'],
    eq_manuf: json['eq_manuf'],
    eq_hospital: json['eq_hospital'],
    eq_department: json['eq_department'],
    eq_ward: json['eq_ward'],
    eq_pic: json['eq_pic'],
    eq_class: json['eq_class'],
    eq_type: json['eq_type'],
    date: json['date'],
    nextdate: json['nextdate'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "eq_name": eq_name,
    "eq_serial": eq_serial,
    "eq_manuf": eq_manuf,
    "eq_hospital": eq_hospital,
    "eq_department": eq_department,
    "eq_ward": eq_ward,
    "eq_pic": eq_pic,
    "eq_class": eq_class,
    "eq_type": eq_type,
    "date": date,
    "nextdate": nextdate,
  };
}
