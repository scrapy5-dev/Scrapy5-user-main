
class GetSubCatModelHome {
  String responseCode;
  String msg;
  List<SubcatModell> data;

  GetSubCatModelHome({
    required this.responseCode,
    required this.msg,
    required this.data,
  });

  factory GetSubCatModelHome.fromJson(Map<String, dynamic> json) => GetSubCatModelHome(
    responseCode: json["response_code"],
    msg: json["msg"],
    data: List<SubcatModell>.from(json["data"].map((x) => SubcatModell.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "response_code": responseCode,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class SubcatModell {
  String ?id;
  String? cName;
  String? cNameA;
  String? icon;
  String ?subTitle;
  String? description;
  String? img;
  Type? type;
  String ?pId;
  String? mCatId;

  SubcatModell({
    this.id,
    this.cName,
    this.cNameA,
    this.icon,
    this.subTitle,
    this.description,
    this.img,
    this.type,
    this.pId,
    this.mCatId,
  });

  factory SubcatModell.fromJson(Map<String, dynamic> json) => SubcatModell(
    id: json["id"]??"",
    cName: json["c_name"]??"",
    cNameA: json["c_name_a"]??"",
    icon: json["icon"]??"",
    subTitle: json["sub_title"]??"",
    description: json["description"]??"",
    img: json["img"]??"",
    type: typeValues.map[json["type"]],
    pId: json["p_id"],
    mCatId: json["m_cat_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "c_name": cName,
    "c_name_a": cNameA,
    "icon": icon,
    "sub_title": subTitle,
    "description": description,
    "img": img,
    "type": typeValues.reverse[type],
    "p_id": pId,
    "m_cat_id": mCatId,
  };
}

enum Type {
  VIP
}

final typeValues = EnumValues({
  "vip": Type.VIP
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
