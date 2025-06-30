// ignore: camel_case_types

class AllCateModel {
  int? status;
  String? msg;
  List<Categories>? categories;

  AllCateModel({this.status, this.msg, this.categories});

  AllCateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['categories'] != null) {
      categories = List<Categories>.empty(growable: true);
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  String? id;
  String? cName;
  String? cNameA;
  String? description;
  String? subTittle;
  String? icon;
  String? img;
  String? type;
  String?pId;
  String?mid;
  String? mrp;
  String? sellingPrice;
  String? vprice;
  String? vSellingPrice;
  String? unit;
  bool? dataV = false;

  Categories(
      {this.id,
        this.cName,
        this.description,
        this.subTittle,
        this.cNameA,
        this.icon,
        this.img,
        this.type,
        this.pId,
        this.mid,
        this.mrp,
        this.sellingPrice,
        this.vprice,
        this.vSellingPrice,
        this.unit,
        this.dataV});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cName = json['c_name'];
    cNameA = json['c_name_a'];
    icon = json['icon'];
    img = json['img'];
    subTittle = json['sub_title'];
    description = json['description'];
    type = json['type'];
    pId = json['p_id'];
    mid = json['m_cat_id'];
    mrp = json['mrp'];
    sellingPrice = json['selling_price'];
    vprice = json['v_price'];
    vSellingPrice = json['v_selling_price'];
    dataV = json['dataV'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['c_name'] = this.cName;
    data['c_name_a'] = this.cNameA;
    data['icon'] = this.icon;
    data['description'] = this.description;
    data['sub_title'] = this.subTittle;
    data['img'] = this.img;
    data['type'] = this.type;
    data['p_id'] = this.pId;
    data['m_cat_id'] = this.mid;
    data['mrp'] = this.mrp;
    data['selling_price'] = this.sellingPrice;
    data['v_price'] = this.vprice;
    data['v_selling_price'] = this.vSellingPrice;
    data['dataV'] = this.dataV;
    data['unit'] = this.unit;
    return data;
  }
}