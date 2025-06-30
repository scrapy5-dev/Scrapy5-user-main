/// response_code : "0"
/// msg : "Service Charge "
/// data : [{"id":"344","city_id":"5","state_id":"10","country_id":"1","charge":"50","cat_id":"287","catsub_id":"344","c_name":"Iron Waste","c_name_a":"","icon":"","sub_title":null,"description":null,"img":"65fe855202a48.jpeg","type":"vip","p_id":"343","m_cat_id":"21","mrp":"499","selling_price":"799","v_price":"250","v_selling_price":"249","unit":"","cat_image":"https://scrapy5.com/uploads/65fe855202a48.jpeg","cat_name":"Iron Waste"}]

class CityChargeModel {
  CityChargeModel({
      String? responseCode, 
      String? msg, 
      List<Data>? data,}){
    _responseCode = responseCode;
    _msg = msg;
    _data = data;
}

  CityChargeModel.fromJson(dynamic json) {
    _responseCode = json['response_code'];
    _msg = json['msg'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  String? _responseCode;
  String? _msg;
  List<Data>? _data;
CityChargeModel copyWith({  String? responseCode,
  String? msg,
  List<Data>? data,
}) => CityChargeModel(  responseCode: responseCode ?? _responseCode,
  msg: msg ?? _msg,
  data: data ?? _data,
);
  String? get responseCode => _responseCode;
  String? get msg => _msg;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['response_code'] = _responseCode;
    map['msg'] = _msg;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "344"
/// city_id : "5"
/// state_id : "10"
/// country_id : "1"
/// charge : "50"
/// cat_id : "287"
/// catsub_id : "344"
/// c_name : "Iron Waste"
/// c_name_a : ""
/// icon : ""
/// sub_title : null
/// description : null
/// img : "65fe855202a48.jpeg"
/// type : "vip"
/// p_id : "343"
/// m_cat_id : "21"
/// mrp : "499"
/// selling_price : "799"
/// v_price : "250"
/// v_selling_price : "249"
/// unit : ""
/// cat_image : "https://scrapy5.com/uploads/65fe855202a48.jpeg"
/// cat_name : "Iron Waste"

class Data {
  Data({
      String? id, 
      String? cityId, 
      String? stateId, 
      String? countryId, 
      String? charge, 
      String? catId, 
      String? catsubId, 
      String? cName, 
      String? cNameA, 
      String? icon, 
      dynamic subTitle, 
      dynamic description, 
      String? img, 
      String? type, 
      String? pId, 
      String? mCatId, 
      String? mrp, 
      String? sellingPrice, 
      String? vPrice, 
      String? vSellingPrice, 
      String? unit, 
      String? catImage, 
      String? catName,}){
    _id = id;
    _cityId = cityId;
    _stateId = stateId;
    _countryId = countryId;
    _charge = charge;
    _catId = catId;
    _catsubId = catsubId;
    _cName = cName;
    _cNameA = cNameA;
    _icon = icon;
    _subTitle = subTitle;
    _description = description;
    _img = img;
    _type = type;
    _pId = pId;
    _mCatId = mCatId;
    _mrp = mrp;
    _sellingPrice = sellingPrice;
    _vPrice = vPrice;
    _vSellingPrice = vSellingPrice;
    _unit = unit;
    _catImage = catImage;
    _catName = catName;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _cityId = json['city_id'];
    _stateId = json['state_id'];
    _countryId = json['country_id'];
    _charge = json['charge'];
    _catId = json['cat_id'];
    _catsubId = json['catsub_id'];
    _cName = json['c_name'];
    _cNameA = json['c_name_a'];
    _icon = json['icon'];
    _subTitle = json['sub_title'];
    _description = json['description'];
    _img = json['img'];
    _type = json['type'];
    _pId = json['p_id'];
    _mCatId = json['m_cat_id'];
    _mrp = json['mrp'];
    _sellingPrice = json['selling_price'];
    _vPrice = json['v_price'];
    _vSellingPrice = json['v_selling_price'];
    _unit = json['unit'];
    _catImage = json['cat_image'];
    _catName = json['cat_name'];
  }
  String? _id;
  String? _cityId;
  String? _stateId;
  String? _countryId;
  String? _charge;
  String? _catId;
  String? _catsubId;
  String? _cName;
  String? _cNameA;
  String? _icon;
  dynamic _subTitle;
  dynamic _description;
  String? _img;
  String? _type;
  String? _pId;
  String? _mCatId;
  String? _mrp;
  String? _sellingPrice;
  String? _vPrice;
  String? _vSellingPrice;
  String? _unit;
  String? _catImage;
  String? _catName;
Data copyWith({  String? id,
  String? cityId,
  String? stateId,
  String? countryId,
  String? charge,
  String? catId,
  String? catsubId,
  String? cName,
  String? cNameA,
  String? icon,
  dynamic subTitle,
  dynamic description,
  String? img,
  String? type,
  String? pId,
  String? mCatId,
  String? mrp,
  String? sellingPrice,
  String? vPrice,
  String? vSellingPrice,
  String? unit,
  String? catImage,
  String? catName,
}) => Data(  id: id ?? _id,
  cityId: cityId ?? _cityId,
  stateId: stateId ?? _stateId,
  countryId: countryId ?? _countryId,
  charge: charge ?? _charge,
  catId: catId ?? _catId,
  catsubId: catsubId ?? _catsubId,
  cName: cName ?? _cName,
  cNameA: cNameA ?? _cNameA,
  icon: icon ?? _icon,
  subTitle: subTitle ?? _subTitle,
  description: description ?? _description,
  img: img ?? _img,
  type: type ?? _type,
  pId: pId ?? _pId,
  mCatId: mCatId ?? _mCatId,
  mrp: mrp ?? _mrp,
  sellingPrice: sellingPrice ?? _sellingPrice,
  vPrice: vPrice ?? _vPrice,
  vSellingPrice: vSellingPrice ?? _vSellingPrice,
  unit: unit ?? _unit,
  catImage: catImage ?? _catImage,
  catName: catName ?? _catName,
);
  String? get id => _id;
  String? get cityId => _cityId;
  String? get stateId => _stateId;
  String? get countryId => _countryId;
  String? get charge => _charge;
  String? get catId => _catId;
  String? get catsubId => _catsubId;
  String? get cName => _cName;
  String? get cNameA => _cNameA;
  String? get icon => _icon;
  dynamic get subTitle => _subTitle;
  dynamic get description => _description;
  String? get img => _img;
  String? get type => _type;
  String? get pId => _pId;
  String? get mCatId => _mCatId;
  String? get mrp => _mrp;
  String? get sellingPrice => _sellingPrice;
  String? get vPrice => _vPrice;
  String? get vSellingPrice => _vSellingPrice;
  String? get unit => _unit;
  String? get catImage => _catImage;
  String? get catName => _catName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['city_id'] = _cityId;
    map['state_id'] = _stateId;
    map['country_id'] = _countryId;
    map['charge'] = _charge;
    map['cat_id'] = _catId;
    map['catsub_id'] = _catsubId;
    map['c_name'] = _cName;
    map['c_name_a'] = _cNameA;
    map['icon'] = _icon;
    map['sub_title'] = _subTitle;
    map['description'] = _description;
    map['img'] = _img;
    map['type'] = _type;
    map['p_id'] = _pId;
    map['m_cat_id'] = _mCatId;
    map['mrp'] = _mrp;
    map['selling_price'] = _sellingPrice;
    map['v_price'] = _vPrice;
    map['v_selling_price'] = _vSellingPrice;
    map['unit'] = _unit;
    map['cat_image'] = _catImage;
    map['cat_name'] = _catName;
    return map;
  }

}