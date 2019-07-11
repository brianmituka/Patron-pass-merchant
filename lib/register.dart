import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as JSON;
final logoColour = const Color(0xff2F2092);
final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
final FocusNode passwordFocusNode = FocusNode();
TextEditingController passwordController = new TextEditingController();
final FocusNode emailFocusNode = FocusNode();
TextEditingController emailController = new TextEditingController();
final FocusNode nameFocusNode = FocusNode();
TextEditingController nameController = new TextEditingController();
final FocusNode usernameFocusNode = FocusNode();
TextEditingController usernameController = new TextEditingController();
final FocusNode mobileFocusNode = FocusNode();
TextEditingController mobileController = new TextEditingController();
final FocusNode countryFocusNode = FocusNode();
TextEditingController countryController = new TextEditingController();
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
final String registerUrl = 'http://api.patronpass.io/api/auth/signup/customer';
var merchantID;
bool termsAccepted = false;
Color _txtColour;

class Register extends StatefulWidget {
  @override
 _RegisterState  createState() =>_RegisterState();
}

class _RegisterState extends State<Register> {

  void _getMerchantToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      merchantID = prefs.getString('merchId');
    });
  }
  @override
  void initState() {
    _getMerchantToken();
    // TODO: implement initState
    super.initState();
  }
  void _onLoading() {
  showDialog(
    context: context,
    barrierDismissible: false,
    child: new Dialog(
      child: new Container(
        height: 60,
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Padding(padding: EdgeInsets.only(left: 20.0),),
          new CircularProgressIndicator(),
          Padding(padding: EdgeInsets.only(left: 20.0),),
          new Text("Loading..."),
        ]

        ),
        //mainAxisSize: MainAxisSize.min,
      ),
    ),
  );
  
}
 void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(value)));
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
       centerTitle: true,
        title: Text("Customer Registration"),
        backgroundColor: logoColour,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _registerFormKey,
          child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
            child: Column(
              children: <Widget>[
                Text(
                  "Register new User",
                  style: TextStyle(
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.w600,
                      fontSize: 25.0,
                      color: Colors.black54,
                      fontFamily: "Gotik"),
                ),
                Padding(padding: EdgeInsets.only(top: 50.0)),
                TextFormField(
                  controller: nameController,
                  focusNode: nameFocusNode,
                  validator: (String payload){
                                if (payload.isEmpty) {
                                  return "Please fill this field";
                                }
                              },
                  decoration: InputDecoration(
                      labelText: "Name ",
                      hintText: "Name",
                      hintStyle: TextStyle(color: Colors.black54)),
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                TextFormField(
                 // initialValue: profilePayload.username,
                 controller: usernameController,
                 focusNode: usernameFocusNode,
                 validator: (String payload){
                                if (payload.isEmpty) {
                                  return "Please fill this field";
                                }
                              },
                  decoration: InputDecoration(
                      labelText: "Username",
                      hintText: "username",
                      hintStyle: TextStyle(color: Colors.black54)),
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                TextFormField(
                  controller: emailController,
                  focusNode: emailFocusNode,
                  validator: (String email){
                             if (email.isEmpty) {
                               return 'Please enter an email';
                             }
                             if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
                               return "Please give a valid email";
                             }

                           },
                  decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.black54)),
                ),
                 Padding(padding: EdgeInsets.only(top: 20.0)),
                TextFormField(
                  //initialValue: profilePayload.email,
                  controller: passwordController,
                  focusNode: passwordFocusNode,
                  validator: (String payload){
                                if (payload.isEmpty || payload.length < 6) {
                                  return "Please fill this field";
                                }
                              },
                  decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.black54)),
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                TextFormField(
                  controller: mobileController,
                  focusNode: mobileFocusNode,
                  validator: (String payload){
                                if (payload.isEmpty) {
                                  return "Please fill this field";
                                }
                              },
                 // initialValue: profilePayload.mobile,
                  decoration: InputDecoration(
                      labelText: "Mobile Number",
                      hintText: "Mobile Number",
                      hintStyle: TextStyle(color: Colors.black54)),
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                TextFormField(
                  controller: countryController,
                  focusNode: countryFocusNode,
                  validator: (String payload){
                                if (payload.isEmpty) {
                                  return "Please fill this field";
                                }
                              },
                  
                  //initialValue: profilePayload.country,
                  decoration: InputDecoration(
                      labelText: "Country",
                      hintText: "Country",
                      hintStyle: TextStyle(color: Colors.black54)),
                ),
                 Padding(padding: EdgeInsets.only(top: 20.0)),
                Row(
                          children: <Widget>[
                           Checkbox(
                             value: termsAccepted,
                             onChanged: (value) {
                               setState(() {
                                 termsAccepted = value;
                                 if (value) {
                                   _txtColour = Colors.black;
                                 } else{
                                   _txtColour = Colors.red;
                                 }
                                 print(termsAccepted);
                               });
                             },
                           ),
                           Text("I accept the ", style: TextStyle(
                             color: _txtColour
                           )
                           ),
                           InkWell(
                             child: Text("terms and conditions", style: TextStyle(
                             color: _txtColour,
                             decoration: TextDecoration.underline
                           ), ) ,
                           )
                            
                          ],
                        ),
                Padding(padding: EdgeInsets.only(top: 80.0)),

                InkWell(
         onTap: () {
           if (!_registerFormKey.currentState.validate() || !termsAccepted) {
                setState(() {
                 _txtColour = Colors.red;
                  });
                   return;
              }
        _registerFormKey.currentState.save();
        final Map<String, dynamic> registerFormData = {
          "email": emailController.text,
          "password": passwordController.text,
          "mobileNumber": mobileController.text,
          "country": countryController.text,
          "name": nameController.text,
          "username": usernameController.text,
          "registeredByMerchantId": int.parse(merchantID)
        };
        print("CREEEEDE ${registerFormData.toString()}");
        _onLoading();
        http.post(
          registerUrl, 
          headers: {"Content-Type": "application/json"},
          body: JSON.jsonEncode(registerFormData)
           ).then((http.Response response) {
             final Map<String, dynamic> loginResponseData = JSON.jsonDecode(response.body);
             print("XXXX ${loginResponseData.toString()}");
             print(" XOXO $merchantID");
              final int signUpResponseCode = response.statusCode;
              print(signUpResponseCode);
              if (signUpResponseCode == 201) {
                 Navigator.of(context, rootNavigator: true).pop('dialog');
                 passwordController.clear();
                 emailController.clear();
                 nameController.clear();
                 usernameController.clear();
                 countryController.clear();
                 countryController.clear();
                 mobileController.clear();
                 showInSnackBar("Registration Successful");

              } else {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                 showInSnackBar("An Error Occured. Try again");

              }
            
           });
                  },
                  child: Container(
                    height: 55.0,
                    width: 300.0,
                    decoration: BoxDecoration(
                        color: logoColour,
                        borderRadius: BorderRadius.all(Radius.circular(40.0))),
                    child: Center(
                      child: Text(
                        "Register",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.5,
                            letterSpacing: 1.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0,)
              ],
            ),

          ),
        ) ,
        )
      ),
    );
  }
}
