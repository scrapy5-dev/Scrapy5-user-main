
class GetScrapCartModel {
  String responseCode;
  String msg;
  List<CartData> data;
  String imagePath;

  GetScrapCartModel({
    required this.responseCode,
    required this.msg,
    required this.data,
    required this.imagePath,
  });

  factory GetScrapCartModel.fromJson(Map<String, dynamic> json) => GetScrapCartModel(
    responseCode: json["response_code"],
    msg: json["msg"],
    data: List<CartData>.from(json["data"].map((x) => CartData.fromJson(x))),
    imagePath: json["image_path"]??"",
  );

  Map<String, dynamic> toJson() => {
    "response_code": responseCode,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "image_path": imagePath,
  };
}

class CartData {
  String? id;
  String? cName;
  String? cNameA;
  String ?icon;
  String? subTitle;
  String? description;
  String? img;
  String? type;
  String? pId;
  String? mCatId;
  String ?categories;
  String? msid;
  String? subName;
  String? subimage;
  String? unit;
  String? masterCategory;
  String ?categoryId;
  String? subcategoryId;
  String? userId;
  String? image;
  DateTime? cratedDate;
  String? qty;
  String? name;
  String? total;
  String? price;
  String? scrapName;

  CartData({
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
    this.unit,
    this.categories,
    this.msid,
    this.subName,
    this.subimage,
    this.masterCategory,
    this.categoryId,
    this.subcategoryId,
    this.userId,
    this.image,
    this.cratedDate,
    this.qty,
    this.name,
    this.total,
    this.price,
    this.scrapName,
  });

  factory CartData.fromJson(Map<String, dynamic> json) => CartData(
    id: json["id"]??"",
    cName: json["c_name"]??"",
    cNameA: json["c_name_a"]??"",
    icon: json["icon"]??"",
    subTitle: json["sub_title"]??"",
    description: json["description"]??"",
    img: json["img"]??"",
    type: json["type"]??"",
    pId: json["p_id"]??"",
    mCatId: json["m_cat_id"]??"",
    categories: json["categories"]??"",
    msid: json["msid"]??"",
    subName: json["sub_name"]??"",
    subimage: json["subimage"]??"",
    unit: json["unit"],
    masterCategory: json["master_category"]??"",
    categoryId: json["category_id"]??"",
    subcategoryId: json["subcategory_id"]??"",
    userId: json["user_id"]??"",
    image: json["image"]??"",
    cratedDate: DateTime.parse(json["crated_date"]),
    qty: json["qty"]??"",
    name: json["name"]??"",
    total: json["total"]??"",
    price: json["price"]??"",
    scrapName: json["scrap_name"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "c_name": cName,
    "c_name_a": cNameA,
    "icon": icon,
    "sub_title": subTitle,
    "description": description,
    "img": img,
    "type": type,
    "p_id": pId,
    "m_cat_id": mCatId,
    "categories": categories,
    "msid": msid,
    "sub_name": subName,
    "subimage": subimage,
    "master_category": masterCategory,
    "category_id": categoryId,
    "subcategory_id": subcategoryId,
    "user_id": userId,
    "image": image,
    "uniy": unit,
    "crated_date": cratedDate,
    "qty": qty,
    "name": name,
    "total": total,
    "price": price,
    "scrap_name": scrapName,
  };
}
