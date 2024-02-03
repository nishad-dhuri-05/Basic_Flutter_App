import 'dart:convert';

LoginResponseModel loginResponseJson(String str)=>
LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  bool? success;
  User? user;
  String? message;
  String? accessToken;
  String? refreshToken;

  LoginResponseModel(
      {this.success,
      this.user,
      this.message,
      this.accessToken,
      this.refreshToken});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    message = json['message'];
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['message'] = this.message;
    data['accessToken'] = this.accessToken;
    data['refreshToken'] = this.refreshToken;
    return data;
  }
}

class User {
  String? sId;
  String? email;
  String? name;
  int? iV;

  User({this.sId, this.email, this.name, this.iV});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    name = json['name'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['name'] = this.name;
    data['__v'] = this.iV;
    return data;
  }
}