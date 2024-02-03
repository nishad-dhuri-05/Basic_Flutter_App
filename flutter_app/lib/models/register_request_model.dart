class RegisterRequestModel {
  String? email;
  String? name;
  String? contact;
  String? address;

  RegisterRequestModel({this.email, this.name, this.contact, this.address});

  RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    contact = json['contact'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['name'] = this.name;
    data['contact'] = this.contact;
    data['address'] = this.address;
    return data;
  }
}