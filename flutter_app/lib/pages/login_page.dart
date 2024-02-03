import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:test/config.dart';
import 'package:test/models/login_request.dart';
import 'package:test/pages/home_page.dart';
import 'package:test/pages/otp_page.dart';
import 'package:test/pages/register_page.dart';
import 'package:test/services/api_service.dart';

class LoginPage extends StatefulWidget {
  final String data;
  LoginPage({super.key,required this.data});
  //const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isAPIcallProcess=false;//used for overshowing loader and all
  //when we are on login page
  bool hidePassword=true;
  double endTime=DateTime.now().millisecondsSinceEpoch+30000;
  GlobalKey<FormState> globalFormKey=GlobalKey<FormState>();
  String? email;
  String? otp;//? means the value can be null
  bool canTap=false;
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
          child: Text("Login",style: TextStyle(
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
       prefixIcon: const Icon(Icons.person),
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
          "otp",
          "OTP (6 digit number)", 
          (onValidateVal){
            if(onValidateVal.isEmpty){
              return "OTP can't be empty";
            }
            return null;
         }, 
         (onSavedVal){
            otp=onSavedVal;
         },
         prefixIcon: const Icon(Icons.person),
         borderFocusColor: Colors.white,
         prefixIconColor: Colors.white,
         borderColor: Colors.white,
         textColor: Colors.white,
         hintColor: Colors.white.withOpacity(0.7),
         borderRadius: 10,
         showPrefixIcon: true,
         isNumeric: true,
         maxLength: 6
         ),
       ),
       Padding(
         padding: const EdgeInsets.only(right: 25,top: 10),
         child: Align(
          alignment: Alignment.bottomRight,
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Request Another OTP?',
                  style: const TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer:TapGestureRecognizer()..onTap=(){
                    print("\nAnother OTP has been requested!!\n");
                    if(DateTime.now().millisecondsSinceEpoch>endTime){
                    Navigator.pushNamed(context,"/otp");
                    }
                    else{
                      num seconds=(endTime-DateTime.now().millisecondsSinceEpoch)/1000;
                      //int s=seconds as int;
                      FormHelper.showSimpleAlertDialog(
                        context, 
                        Config.appName, 
                        "Please wait for $seconds seconds before requesting another OTP", 
                        "OK", 
                        (){
                          Navigator.pop(context);
                        },
                        );
                      //Navigator.pop(context,);
                    }
                  },
                )
              ]
            )
            ),
         ),
       ),
       const SizedBox(
        height: 20,
       ),
       Center(
         child: FormHelper.submitButton("Login",
         (){
          if(validateAndSave()){
            setState(() {
              isAPIcallProcess=true;
            });

            LoginRequestModel model=LoginRequestModel(
              email:email!,
              otp: otp!,
            );
            print("\n\n\nAbout to call login\n\n\n");
            APIService.login(model).then((response){

              setState(() {
              isAPIcallProcess=false;//after successful login,we remove the loader
            });
            print("The value of response is $response");
              if(response==1){
              Navigator.pushNamedAndRemoveUntil(context,"/home", (route) => false); //remove all previous routes
              // APIService.getUserProfile().then((user){
              //   Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => HomePage(email:user.email,name:user.name,address:user.address,contact:user.contact),
              //       ),
              //     (route) => false
              //       );
              
              // });
              }
              else if(response==0){
                FormHelper.showSimpleAlertDialog(
                  context, 
                  Config.appName, 
                  "Invalid email/password", 
                  "OK", 
                  (){
                    Navigator.pop(context);
                  },
                  );
              }
              else{
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => RegisterPage(data:email??"",),
                //     )
                //     );
                FormHelper.showSimpleAlertDialog(
                  context, 
                  Config.appName, 
                  "User does not exist. Please register first", 
                  "OK", 
                  (){
                    Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterPage(data:email??"",),
                    ),
                  (route) => false
                    );
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
      //  SizedBox(
      //   height: 20,
      //  ),
      //  Center(
      //    child: Text("OR",
      //    style:TextStyle(
      //     fontWeight: FontWeight.bold,
      //     fontSize: 18,
      //     color: Colors.white,
      //    ) ,),
      //  ),
      //  SizedBox(
      //   height: 20,
      //  ),
      //  Padding(
      //    padding: const EdgeInsets.only(right: 25,top: 10),
      //    child: Align(
      //     alignment: Alignment.center,
      //     child: RichText(
      //       text: TextSpan(
      //         style: const TextStyle(
      //           color: Colors.grey,
      //           fontSize: 14,
      //         ),
      //         children: <TextSpan>[
      //           TextSpan(
      //             text: "Don't have an account? "
      //           ),
      //           TextSpan(
      //             text: 'Sign up',
      //             style: const TextStyle(
      //               color: Colors.white,
      //               decoration: TextDecoration.underline,
      //             ),
      //             recognizer:TapGestureRecognizer()..onTap=(){
      //               print("Going to SignUp page!!");
      //               Navigator.pushNamed(context,"/register");
      //             },
      //           )
      //         ]
      //       )
      //       ),
      //    ),
      //  ),
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

  void onEnd(){
    setState(() {
      canTap=true;
    });
  }
}

// extension EmailValidator on String? {
//   bool isValidEmail() {
//     return RegExp(r"^[a-zA-Z0-9.]+@iitrpr.ac.in").hasMatch(this!);
//   }
// }