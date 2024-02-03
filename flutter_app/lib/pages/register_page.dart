import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:test/config.dart';
import 'package:test/models/register_request_model.dart';
import 'package:test/pages/otp_page.dart';
import 'package:test/services/api_service.dart';

class RegisterPage extends StatefulWidget {
  final String data;
  //const RegisterPage({super.key});
  RegisterPage({super.key,required this.data});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isAPIcallProcess=false;//used for overshowing loader and all
  //when we are on login page
  bool hidePassword=true;
  GlobalKey<FormState> globalFormKey=GlobalKey<FormState>();
  String? email;
  String? name;//? means the value can be null
  String? contact;
  String? address;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("#283B71"),
        body: ProgressHUD(
          key: UniqueKey(), inAsyncCall: isAPIcallProcess,
          opacity: 0.3, child: Form(
            key: globalFormKey,
            child: _registerUI(context),
          ),),
      ),
      );
  }
  Widget _registerUI(BuildContext context){
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/3,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/IITRprLogo.png",
                    width: 250,
                    fit: BoxFit.contain,
                  ),
                )
              ],
            ),
          ),
          const Padding(padding:EdgeInsets.only(
            left: 20,
            bottom: 30,
            top: 50,
          ),
          child: Text("Register",style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ) ,
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
          email=onSavedVal;
       },
       initialValue: widget.data,
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
            name=onSavedVal;
         },
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
            contact=onSavedVal;
         },
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
            address=onSavedVal;
         },
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
         child: FormHelper.submitButton("Register",
         (){
          if(validateAndSave()){
            setState(() {
              isAPIcallProcess=true;
            });

            RegisterRequestModel model=RegisterRequestModel(
              email:email!,
              name:name!,
              contact:contact!,
              address:address!
            );

            APIService.register(model).then((response){

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
                  response.message ?? "Invalid",
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
                  "Registered successfully. Please login to the account", 
                  "OK", 
                  (){
                    Navigator.pushNamedAndRemoveUntil(context,"/otp", (route) => false); //remove all previous routes
                  },
                  );
                
                //Navigator.pushNamedAndRemoveUntil(context,"/home", (route) => false); //remove all previous routes
              }
              else{
                FormHelper.showSimpleAlertDialog(
                  context, 
                  Config.appName, 
                  response.message ?? "Invalid",
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
                  text: "Already have a account?"
                ),
                TextSpan(
                  text: 'Login',
                  style: const TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer:TapGestureRecognizer()..onTap=(){
                    print("Going to Login page!!");
                    Navigator.pushNamedAndRemoveUntil(context,"/otp", (route) => false);
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

// extension EmailValidator on String? {
//   bool isValidEmail() {
//     return RegExp(r"^[a-zA-Z0-9.]+@iitrpr.ac.in").hasMatch(this!);
//   }
// }





