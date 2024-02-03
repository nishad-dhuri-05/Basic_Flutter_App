import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:test/config.dart';
import 'package:test/models/profile_response_model.dart';
import 'package:test/models/update_request_model.dart';
import 'package:test/pages/otp_page.dart';
import 'package:test/pages/profile_update_page.dart';
import 'package:test/services/api_service.dart';
import 'package:test/services/shared_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<FormState> globalFormKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      //backgroundColor: Colors.grey[200],
      backgroundColor: HexColor("#283B71"),
      body: userProfile(),
    );
  }

  Widget userProfile(){
    String email;
    String name;
    String address;
    String contact;
    bool isAPIcallProcess=false;
    return FutureBuilder(
      future: APIService.getUserProfile(), 
      builder: (BuildContext context,AsyncSnapshot<ProfileResponseModel>model){
        if(model.hasData){
          email=model.data!.email!;
          name=model.data!.name!;
          address=model.data!.address!;
          contact=model.data!.contact!;
          return Center(
            child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          const Padding(padding:EdgeInsets.only(
            left: 20,
            bottom: 30,
            top: 50,
          ),
          child: Center(
            child: Text("User Profile",style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.white,
            ) ,
            ),
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
       initialValue: model.data!.email??"Error",
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
         initialValue: model.data!.name??"Error",
         isReadonly: true,
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
            return null;
         }, 
         (onSavedVal){
            contact=onSavedVal;
         },
         initialValue: model.data!.contact??"Error",
        isReadonly: true,
         prefixIcon: const Icon(Icons.phone_android_outlined),
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
         initialValue: model.data!.address??"Error",
         isReadonly: true,
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
       SizedBox(
         height: 20,
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
                  text: "Make changes?"
                ),
                TextSpan(
                  text: 'Edit',
                  style: const TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer:TapGestureRecognizer()..onTap=(){
                    print("Going to Update page!!");
                    Navigator.pushAndRemoveUntil(context, 
                    MaterialPageRoute(builder: (context)=>ProfileUpdate(email: email, name: name, contact: contact, address: address!)), 
                    (route) => false);
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
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
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




// import 'package:flutter/material.dart';
// import 'package:test/models/profile_response_model.dart';
// import 'package:test/pages/otp_page.dart';
// import 'package:test/services/api_service.dart';
// import 'package:test/services/shared_service.dart';

// class HomePage extends StatefulWidget {
//   // String email;
//   // String name;
//   // String address;
//   // String contact;
//   //HomePage({super.key,required this.email,required this.name,required this.address,required this.contact});
//   const HomePage({super.key});
//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   //Widget build(BuildContext context) {
//     // return Scaffold(
//     //   appBar: AppBar(
//     //     title: Text("DEPLAB1"),
//     //     elevation: 0,
//     //     actions: [
//     //       IconButton(
//     //         onPressed: (){
//     //           SharedService.logout(context);
//     //         }, 
//     //         icon: const Icon(
//     //           Icons.logout,
//     //           color: Colors.black,
//     //         ))
//     //     ],
//     //   ),
//     //   backgroundColor: Colors.grey[200],
//     //   body: userProfile(),
//     // );
//     Widget build(BuildContext context) {
//     String? email;
//     String? name;
//     String? address;
//     String? contact;
//     return Scaffold(
//       backgroundColor: Colors.teal[50],
//       appBar: AppBar(
//         title: Text('Dep Lab1'),
//         backgroundColor: Colors.teal[400],
//         elevation: 0.0,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.exit_to_app),
//             onPressed: () {
//               SharedService.logout(context);
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => OTPPage(),
//                 ),
//                 (route) => false,
//               );
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             ElevatedButton(onPressed: (){
//               APIService.getUserProfile().then((response){
//                 email=response.email;
//                 name=response.name;
//                 address=response.address;
//                 contact=response.contact;
//                 print('\n\n\n\n');
//                 print(email);
//                 print('\n\n\n\n');
//                 setState(() {
//                   email=response.email;
//                   name=response.name;
//                   address=response.address;
//                   contact=response.contact;
//                 });
//               });
//             }, child: Text("Get user info")),
//             UserInfoCard('Email', email, Icons.email),
//             UserInfoCard('Name', name, Icons.person),
//             UserInfoCard('Address', address, Icons.location_on),
//             UserInfoCard('Phone Number', contact, Icons.phone),
//           ],
//         ),
//      ),
//  );
//  }
//   }

//   // ProfileResponseModel user=
  
//     // return FutureBuilder(
//     //   future: APIService.getUserProfile(), 
//     //   builder: (BuildContext context,AsyncSnapshot<String>model){
//     //     if(model.hasData){
//     //       return Center(
//     //         child: Text(model.data!),
//     //       );
//     //     }
//     //     return const Center(
//     //       child: CircularProgressIndicator(),
//     //     );
//     //   }
//     //   );

// class UserInfoCard extends StatelessWidget {
//   final String label;
//   final String? value;
//   final IconData icon;

//   UserInfoCard(this.label, this.value, this.icon);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4.0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       margin: EdgeInsets.only(bottom: 16.0),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(
//                   icon,
//                   color: Colors.teal[400],
//                   size: 24.0,
//                 ),
//                 SizedBox(width: 8.0),
//                 Text(
//                   label,
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18.0,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8.0),
//             Text(
//               value ?? 'N/A',
//               style: TextStyle(fontSize: 16.0),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
