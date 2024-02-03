
import 'dart:convert';

UpdateResponseModel updateResponseModel(String str) => 
UpdateResponseModel.fromJson(json.decode(str));
class UpdateResponseModel {
  bool? success;
  String? message;

  UpdateResponseModel({this.success, this.message});

  UpdateResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}