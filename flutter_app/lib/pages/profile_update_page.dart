import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:test/config.dart';
import 'package:test/pages/otp_page.dart';
import 'package:test/services/api_service.dart';
import 'package:test/services/shared_service.dart';

class ProfileUpdate extends StatefulWidget {
  final String email;
  final String name;
  final String contact;
  final String address;
  const ProfileUpdate({super.key,required this.email,required this.name,required this.contact,required this.address});

  @override
  State<ProfileUpdate> createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  bool isAPIcallProcess=false;//used for overshowing loader and all
  //when we are on login page
  bool hidePassword=true;
  GlobalKey<FormState> globalFormKey=GlobalKey<FormState>();
  String? email1;
  String? name1;//? means the value can be null
  String? contact1;
  String? address1;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
        title: Text("DEPLAB1"),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: (){
              SharedService.logout(context);
            }, 
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ))
        ],
      ),
        backgroundColor: HexColor("#283B71"),
        body: ProgressHUD(
          key: UniqueKey(), inAsyncCall: isAPIcallProcess,
          opacity: 0.3, child: Form(
            key: globalFormKey,
            child: _updateUI(context),
          ),),
      ),
      );
  }
  Widget _updateUI(BuildContext context){
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding:EdgeInsets.only(
            left: 20,
            bottom: 30,
            top: 50,
          ),
          child: Text("Edit Profile",style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ) ,
          textAlign: TextAlign.center,
          )
      ),
      FormHelper.inputFieldWidget(
        context,
        "email",
        "EMail", 
        (onValidateVal){
          if(onValidateVal.isEmpty){
            return "Email can't be empty";
          }
          else if(!onValidateVal.toString().isValidEmail()){
            return "Please enter a email with iitrpr domain";
          }
          return null;
       }, 
       (onSavedVal){
          email1=onSavedVal;
       },
       initialValue: widget.email,
       isReadonly: true,
       prefixIcon: const Icon(Icons.email),
       borderFocusColor: Colors.white,
       prefixIconColor: Colors.white,
       borderColor: Colors.white,
       textColor: Colors.white,
       hintColor: Colors.white.withOpacity(0.7),
       borderRadius: 10,
       showPrefixIcon: true,
       ),
       Padding(
         padding: const EdgeInsets.only(top:10 ),
         child: FormHelper.inputFieldWidget(
          context,
          "name",
          "Name", 
          (onValidateVal){
            if(onValidateVal.isEmpty){
              return "Name can't be empty";
            }
            return null;
         }, 
         (onSavedVal){
            name1=onSavedVal;
         },
          initialValue: widget.name,
         prefixIcon: const Icon(Icons.person),
         borderFocusColor: Colors.white,
         prefixIconColor: Colors.white,
         borderColor: Colors.white,
         textColor: Colors.white,
         hintColor: Colors.white.withOpacity(0.7),
         borderRadius: 10,
         showPrefixIcon: true,
         ),
       ),
       Padding(
         padding: const EdgeInsets.only(top: 10),
         child: FormHelper.inputFieldWidget(
          context,
          "contact",
          "Phone No", 
          (onValidateVal){
            if(onValidateVal.isEmpty){
              return "Phone No can't be empty";
            }
            else if(!onValidateVal.toString().isValidNumber()){
            return "Please enter a valid phone number";
          }
            return null;
         }, 
         (onSavedVal){
            contact1=onSavedVal;
         },
         initialValue: widget.contact,
         isReadonly: true,
         prefixIcon: const Icon(Icons.phone_android_outlined),
         borderFocusColor: Colors.white,
         prefixIconColor: Colors.white,
         borderColor: Colors.white,
         textColor: Colors.white,
         hintColor: Colors.white.withOpacity(0.7),
         borderRadius: 10,
         showPrefixIcon: true,
         isNumeric: true,
         maxLength: 10,
         ),
       ),
      Padding(
         padding: const EdgeInsets.only(top: 10),
         child: FormHelper.inputFieldWidget(
          context,
          "address",
          "Address", 
          (onValidateVal){
            if(onValidateVal.isEmpty){
              return "Address can't be empty";
            }
            return null;
         }, 
         (onSavedVal){
            address1=onSavedVal;
         },
         initialValue: widget.address,
         prefixIcon: const Icon(Icons.home),
         borderFocusColor: Colors.white,
         prefixIconColor: Colors.white,
         borderColor: Colors.white,
         textColor: Colors.white,
         hintColor: Colors.white.withOpacity(0.7),
         borderRadius: 10,
         showPrefixIcon: true,
         ),
       ),
       const SizedBox(
        height: 20,
       ),
       Center(
         child: FormHelper.submitButton("Update",
         (){
          if(validateAndSave()){
            setState(() {
              isAPIcallProcess=true;
            });

           
            APIService.updateUserProfile(email1, name1, address1).then((response){

              setState(() {
              isAPIcallProcess=false;//after successful login,we remove the loader
            });
            print("\n\n\n\n");
            print(response.success);
            print("\n\n\n\n");
              if(response.success==false){
                FormHelper.showSimpleAlertDialog(
                  context, 
                  Config.appName, 
                  response.message ?? "Failed to update",
                  "OK", 
                  (){
                    Navigator.pop(context);
                  },
                  );
              }
              else if(response!=null){
                FormHelper.showSimpleAlertDialog(
                  context, 
                  Config.appName, 
                  "Updated Successfully", 
                  "OK", 
                  (){
                    Navigator.pushNamedAndRemoveUntil(context,"/home", (route) => false); //remove all previous routes
                  },
                  );
                
                //Navigator.pushNamedAndRemoveUntil(context,"/home", (route) => false); //remove all previous routes
              }
              else{
                FormHelper.showSimpleAlertDialog(
                  context, 
                  Config.appName, 
                  response.message ?? "Failed to update",
                  "OK", 
                  (){
                    Navigator.pop(context);
                  },
                  );
              }
            });
          }
         },
         btnColor:HexColor("#283B71"),
         borderColor: Colors.white,
         txtColor: Colors.white,
         borderRadius: 10,
         ),
       ),
       SizedBox(
        height: 10,
       ),
       Center(
         child: Text("OR",
         style:TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.white,
         ) ,),
       ),
       SizedBox(
        height: 10,
       ),
       Padding(
         padding: const EdgeInsets.only(right: 25,top: 10),
         child: Align(
          alignment: Alignment.center,
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: "Exit without updating?"
                ),
                TextSpan(
                  text: 'Home',
                  style: const TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer:TapGestureRecognizer()..onTap=(){
                    print("Going to Home page!!");
                    Navigator.pushNamedAndRemoveUntil(context,"/home", (route) => false); //remove all previous routes
                  },
                )
              ]
            )
            ),
         ),
       ),
        ],
      ),
    );
  }


  bool validateAndSave(){
    final form=globalFormKey.currentState;
    if(form!.validate()){
      form.save();
      return true;
    }
    return false;
  }
}