class Hospital{

  final String name;

  Hospital({
    required this.name,
  });

  static Hospital fromJson(json)=> Hospital(
    name: json['hosp_name'],
  );

  Map<String,dynamic> toJson()=>{
    "hosp_name":name,
  };

}