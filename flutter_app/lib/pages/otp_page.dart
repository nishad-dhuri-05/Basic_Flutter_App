import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:test/config.dart';
import 'package:test/models/login_request.dart';
import 'package:test/models/otp_request_model.dart';
import 'package:test/pages/login_page.dart';
import 'package:test/pages/register_page.dart';
import 'package:test/services/api_service.dart';


class OTPPage extends StatefulWidget {
  const OTPPage({super.key});

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  bool isAPIcallProcess=false;//used for overshowing loader and all
  //when we are on login page
  bool hidePassword=true;
  GlobalKey<FormState> globalFormKey=GlobalKey<FormState>();
  String? email;//? means the value can be null
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("#283B71"),
        body: ProgressHUD(
          key: UniqueKey(), inAsyncCall: isAPIcallProcess,
          opacity: 0.3, child: Form(
            key: globalFormKey,
            child: _loginUI(context),
          ),),
      ),
      );
  }
  Widget _loginUI(BuildContext context){
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
          child: Text("Verify Email",style: TextStyle(
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
       prefixIcon: const Icon(Icons.email),
       borderFocusColor: Colors.white,
       prefixIconColor: Colors.white,
       borderColor: Colors.white,
       textColor: Colors.white,
       hintColor: Colors.white.withOpacity(0.7),
       borderRadius: 10,
       showPrefixIcon: true,
       ),
       
       const SizedBox(
        height: 20,
       ),
       Center(
         child: FormHelper.submitButton("Send OTP",
         (){
          if(validateAndSave()){
            setState(() {
              isAPIcallProcess=true;
            });

            OTPRequestModel model=OTPRequestModel(
              email:email!
            );
            print("\n\n\nAbout to call otp\n\n\n");
            APIService.otp(model).then((response){

              setState(() {
              isAPIcallProcess=false;//after successful login,we remove the loader
            });
              
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(data:email??"",),
                    ),
                    (route) => false,
                    );
              // if(response.userExists==true){
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => LoginPage(data:email??"",),
              //       )
              //       );
              // }
              // else{
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => RegisterPage(data:email??"",),
                //     )
                //     );
              // }
              // if(response){
              //   Navigator.pushNamedAndRemoveUntil(context,"/login", (route) => false); //remove all previous routes
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => LoginPage(data:email??"",),
              //       )
              //       );
              // }
              // else{
              //   FormHelper.showSimpleAlertDialog(
              //     context, 
              //     Config.appName, 
              //     "User does not exist", 
              //     "OK", 
              //     (){
              //       Navigator.pop(context);
              //     },
              //     );
              // }
            });
          }
         },
         btnColor:HexColor("#283B71"),
         borderColor: Colors.white,
         txtColor: Colors.white,
         borderRadius: 10,
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

extension EmailValidator on String? {
  bool isValidEmail() {
    return RegExp(r"^[a-zA-Z0-9.]+@iitrpr.ac.in").hasMatch(this!);
  }
}

extension ContactValidator on String? {
  bool isValidNumber() {
    return RegExp(r"^[0-9]{10}").hasMatch(this!);
  }
}