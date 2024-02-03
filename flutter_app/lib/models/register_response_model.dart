import 'dart:convert';

RegisterResponseModel registerResponseModel(String str)=>
RegisterResponseModel.fromJson(json.decode(str));

class RegisterResponseModel {
  bool? success;
  String? accessToken;
  String? refreshToken;
  String? message;

  RegisterResponseModel(
      {this.success, this.accessToken, this.refreshToken, this.message});

  RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['accessToken'] = this.accessToken;
    data['refreshToken'] = this.refreshToken;
    data['message'] = this.message;
    return data;
  }
}