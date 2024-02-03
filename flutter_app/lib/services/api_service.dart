import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test/config.dart';
import 'package:test/models/login_request.dart';
import 'package:test/models/login_response_model.dart';
import 'package:test/models/otp_request_model.dart';
import 'package:test/models/otp_response_model.dart';
import 'package:test/models/profile_request_model.dart';
import 'package:test/models/profile_response_model.dart';
import 'package:test/models/register_request_model.dart';
import 'package:test/models/register_response_model.dart';
import 'package:test/models/update_request_model.dart';
import 'package:test/models/update_response_model.dart';
import 'package:test/services/shared_service.dart';
class APIService{
  static var client=http.Client();
  static Future<int>login(LoginRequestModel model)async{
    print("\\\\\nLogin called!!\\\\\n");
    Map<String,String>requestHeaders={
      'Content-Type':'application/json',
    };
    var url=Uri.http(
      Config.apiURL,
      Config.loginAPI,
      );//url and endpoint
    var response=await client.post(
      url,
      headers: requestHeaders,
      body:jsonEncode(model.toJson())
    );

    if(response.statusCode==200){//login successful
      //SHARED SERVICE
      await SharedService.setLoginDetails(loginResponseJson(response.body));
      return 1;
    }
    else if(response.statusCode==400){
      return -1;
    }
    else{
      return 0;
    }
  }

  static Future<RegisterResponseModel>register(RegisterRequestModel model)async{
    Map<String,String>requestHeaders={
      'Content-Type':'application/json',
    };
    var url=Uri.http(Config.apiURL,Config.registerAPI);//url and endpoint
    var response=await client.post(
      url,
      headers: requestHeaders,
      body:jsonEncode(model.toJson())
    );

    return registerResponseModel(response.body);
  }

  static Future<OTPResponseModel>otp(OTPRequestModel model)async{
    print("\\\\\nOTP called!!\\\\\n");
    Map<String,String>requestHeaders={
      'Content-Type':'application/json',
    };
    var url=Uri.http(
      Config.apiURL,
      Config.otpAPI,
      );//url and endpoint
    var response=await client.post(
      url,
      headers: requestHeaders,
      body:jsonEncode(model.toJson())
    );

    if(response.statusCode==200){//login successful
      //SHARED SERVICE
      //await SharedService.setLoginDetails(loginResponseJson(response.body));
      //return true;
      return oTPResponseModel(response.body);
    }
    else{
      //return false;
      return oTPResponseModel(response.body);
    }
  }

  static Future<ProfileResponseModel>getUserProfile()async{
    print("\\\\\nViewing user profile !!\\\\\n");

    var loginDetails=await SharedService.loginDetails();

    Map<String,String>requestHeaders={
      'Content-Type':'application/json',
      'Authorization':'${loginDetails!.accessToken}',
    };
    var url=Uri.http(
      Config.apiURL,
      Config.userProfileAPI,
      );//url and endpoint
    ProfileRequestModel model=ProfileRequestModel(
      accessToken: loginDetails.accessToken,
      refreshToken: loginDetails.refreshToken,
    );
    var response=await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson())
    );

    if(response.statusCode==200){//login successful
      //SHARED SERVICE
      return profileResponseModel(response.body);
    }
    else{
      return profileResponseModel(response.body);
    }
  }

  static Future<UpdateResponseModel>updateUserProfile(String? email,String?  name,String? address)async{
    print("\\\\\nUpdating user profile !!\\\\\n");

    var loginDetails=await SharedService.loginDetails();

    Map<String,String>requestHeaders={
      'Content-Type':'application/json',
      'Authorization':'${loginDetails!.accessToken}',
    };
    var url=Uri.http(
      Config.apiURL,
      Config.userUpdateAPI+email!,
      );//url and endpoint
    print(url);
    UpdateRequestModel model=UpdateRequestModel(
      accessToken: loginDetails.accessToken,
      refreshToken: loginDetails.refreshToken,
      name:name,
      address:address,
    );
    var response=await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson())
    );
    print(response.body);
    if(response.statusCode==200){//login successful
      //SHARED SERVICE
      return updateResponseModel(response.body);
    }
    else{
      return updateResponseModel(response.body);
    }
  }
}