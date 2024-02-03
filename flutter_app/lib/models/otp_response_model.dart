import 'dart:convert';

OTPResponseModel oTPResponseModel(String str)=>
OTPResponseModel.fromJson(json.decode(str));

class OTPResponseModel {
  bool? userExists;
  String? message;

  OTPResponseModel({this.userExists, this.message});

  OTPResponseModel.fromJson(Map<String, dynamic> json) {
    userExists = json['userExists'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userExists'] = this.userExists;
    data['message'] = this.message;
    return data;
  }
}