class ScarpFormGetcatDataModel {
  int? status;
  String? msg;
  List<Categories>? categories;

  ScarpFormGetcatDataModel({this.status, this.msg, this.categories});

  ScarpFormGetcatDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['categories'] != null) {
      categories = <Categories>[];
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
  String? icon;
  String? subTitle;
  String? description;
  String? img;
  String? type;
  String? pId;
  String? mCatId;

  Categories(
      {this.id,
        this.cName,
        this.cNameA,
        this.icon,
        this.subTitle,
        this.description,
        this.img,
        this.type,
        this.pId,
        this.mCatId});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cName = json['c_name'];
    cNameA = json['c_name_a'];
    icon = json['icon'];
    subTitle = json['sub_title'];
    description = json['description'];
    img = json['img'];
    type = json['type'];
    pId = json['p_id'];
    mCatId = json['m_cat_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['c_name'] = this.cName;
    data['c_name_a'] = this.cNameA;
    data['icon'] = this.icon;
    data['sub_title'] = this.subTitle;
    data['description'] = this.description;
    data['img'] = this.img;
    data['type'] = this.type;
    data['p_id'] = this.pId;
    data['m_cat_id'] = this.mCatId;
    return data;
  }
}