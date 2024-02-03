import 'dart:convert';
import 'dart:ffi';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter/material.dart';
import 'package:test/models/login_response_model.dart';

class SharedService{
  static Future<bool> isLoggedIn() async {
    var isKeyExist=await APICacheManager().isAPICacheKeyExist("login_details");
    return isKeyExist;
  }

  static Future<LoginResponseModel?> loginDetails() async{
    var isKeyExist=await APICacheManager().isAPICacheKeyExist("login_details");
    
    if(isKeyExist){
      var cacheData=await APICacheManager().getCacheData("login_details");
      return loginResponseJson(cacheData.syncData);//decode the incoming data to make the model
    }
  }

  static Future<void> setLoginDetails(LoginResponseModel model)async {
    APICacheDBModel cacheDBModel=APICacheDBModel(
      key: "login_details",
      syncData: jsonEncode(model.toJson()),
      );
      await APICacheManager().addCacheData(cacheDBModel);
      //to save data in cache
  }

  //BuildContext Needed as we need to redirect the user to login page from here

  static Future<void> logout(BuildContext context)async {
    await APICacheManager().deleteCache("login_details");
    Navigator.pushNamedAndRemoveUntil(context, "/otp", (route) => false);
  }
}