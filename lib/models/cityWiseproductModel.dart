
class GetCityWiseModel {
  String responseCode;
  String msg;
  List<CitywiseList> data;

  GetCityWiseModel({
    required this.responseCode,
    required this.msg,
    required this.data,
  });

  factory GetCityWiseModel.fromJson(Map<String, dynamic> json) => GetCityWiseModel(
    responseCode: json["response_code"],
    msg: json["msg"],
    data: List<CitywiseList>.from(json["data"].map((x) => CitywiseList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "response_code": responseCode,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class CitywiseList {
  String ?id;
  String? cityId;
  String ?stateId;
  String? countryId;
  String? charge;
  String ?catId;
  String? catsubId;
  String? catImage;
  String ?catName;

  CitywiseList({
    this.id,
    this.cityId,
    this.stateId,
    this.countryId,
    this.charge,
    this.catId,
    this.catsubId,
    this.catImage,
    this.catName,
  });

  factory CitywiseList.fromJson(Map<String, dynamic> json) => CitywiseList(
    id: json["id"],
    cityId: json["city_id"],
    stateId: json["state_id"],
    countryId: json["country_id"],
    charge: json["charge"],
    catId: json["cat_id"],
    catsubId: json["catsub_id"],
    catImage: json["cat_image"],
    catName: json["cat_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "city_id": cityId,
    "state_id": stateId,
    "country_id": countryId,
    "charge": charge,
    "cat_id": catId,
    "catsub_id": catsubId,
    "cat_image": catImage,
    "cat_name": catName,
  };
}
