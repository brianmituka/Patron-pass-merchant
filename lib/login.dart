import 'package:flutter/material.dart';
import 'package:patron_merchant/landingpage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as JSON;

final logoColour = const Color(0xff2F2092);
final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
final FocusNode passwordFocusNode = FocusNode();
TextEditingController passwordController = new TextEditingController();
final FocusNode emailFocusNode = FocusNode();
TextEditingController emailController = new TextEditingController();
String loginUrl;
String userUrl;
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  void _incrementCounter() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    mediaQueryData.devicePixelRatio;
    mediaQueryData.size.width;
    mediaQueryData.size.height;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Container(
          color: logoColour,
          child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0.0),
                    Color.fromRGBO(0, 0, 0, 0.3)
                  ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                ),
              ),
              child: Form(
                key: _loginFormKey,
                child: ListView(
                  children: <Widget>[
                    Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top: mediaQueryData.padding.top + 40.0),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image(
                                  image: AssetImage("assets/img/newlogo.png"),
                                  height: 70.0,
                                ),
                                //    Padding(
                                //             padding:
                                //                 EdgeInsets.symmetric(horizontal: 10.0)),
                                //                 Hero(
                                //                   tag: "Patron Pass",
                                //                   child: Text("Patron Pass",
                                //                   style: TextStyle(
                                //                     fontWeight: FontWeight.w900,
                                //                 letterSpacing: 0.6,
                                //                 color: Colors.white,
                                //                 fontFamily: "Sans",
                                //                 fontSize: 20.0
                                //                   ),
                                //                ),
                                //                 )
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0)),
                            Text(
                              "Log in with Merchant ID and Branch pin ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 0.2,
                                  fontFamily: 'Sans',
                                  fontSize: 17.0),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0)),
                            TextFromField(
                              email: "Merchant Id",
                              icon: Icons.email,
                              inputType: TextInputType.text,
                              password: false,
                              controller: emailController,
                              focusNode: emailFocusNode,
                              validator: (String email) {
                                if (email.isEmpty) {
                                  return 'Please enter a merchant ID';
                                }
                                //
                              },
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0)),
                            TextFromField(
                              email: "Password",
                              icon: Icons.vpn_key,
                              password: true,
                              inputType: TextInputType.text,
                              controller: passwordController,
                              focusNode: passwordFocusNode,
                              validator: (String password) {
                                if (password.isEmpty) {
                                  return "Please enter your password";
                                }
                              },
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0)),
                            buttonBlackBottom()
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )),
        ));
  }
}

class TextFromField extends StatelessWidget {
  final bool password;
  final String email;
  final IconData icon;
  final TextInputType inputType;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FormFieldValidator<String> validator;
  TextFromField(
      {this.email,
      this.icon,
      this.inputType,
      this.password,
      this.controller,
      this.focusNode,
      this.validator});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        height: 60.0,
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 10.0, color: Colors.black12)]),
        padding:
            EdgeInsets.only(left: 20.0, right: 30.0, top: 0.0, bottom: 0.0),
        child: Theme(
          data: ThemeData(hintColor: Colors.transparent),
          child: TextFormField(
            obscureText: password,
            validator: validator,
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
                border: InputBorder.none,
                labelText: email,
                icon: Icon(
                  icon,
                  color: Colors.black38,
                ),
                labelStyle: TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Sans',
                    letterSpacing: 0.3,
                    color: Colors.black38,
                    fontWeight: FontWeight.w600)),
            keyboardType: inputType,
          ),
        ),
      ),
    );
  }
}

class buttonBlackBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void showInSnackBar(String value) {
      _scaffoldKey.currentState
          .showSnackBar(new SnackBar(content: new Text(value)));
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
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                  ),
                  new CircularProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                  ),
                  new Text("Loading..."),
                ]),
            //mainAxisSize: MainAxisSize.min,
          ),
        ),
      );
    }

    //return Scaffold(
    //key: _scaffoldKey,
    //body:
    return InkWell(
        onTap: () {
          if (!_loginFormKey.currentState.validate()) {
            return;
          }
          _loginFormKey.currentState.save();
          if (isInDebugMode) {
            loginUrl = "https://vader.patronpass.io/api/auth/login/branch";
            userUrl = "https://vader.patronpass.io/api/users/current";
          } else {
            loginUrl = "http://skywalker.patronpass.io/api/auth/login/branch";
            userUrl = "http://skywalker.patronpass.io/api/users/current";
          }
          print(loginUrl);
          print(userUrl);
          final Map<String, dynamic> loginFormData = {
            "merchantDisplayedId": emailController.text,
            "branchPin": passwordController.text
          };

          print("CREEEEDE ${loginFormData.toString()}");
          _onLoading();
          try {
            http
                .post(loginUrl,
                    headers: {"Content-Type": "application/json"},
                    body: JSON.jsonEncode(loginFormData))
                .then((http.Response response) {
              print("Hit");
              final Map<String, dynamic> loginResponseData =
                  JSON.jsonDecode(response.body);
              print("XXXX ${loginResponseData.toString()}");
              final String accessToken = loginResponseData['accessToken'];
              print(accessToken);
              final int responseCode = response.statusCode;
              print(responseCode);
              if (responseCode == 200) {
                http.get(userUrl, headers: {
                  "Authorization": "Bearer $accessToken"
                }).then((http.Response response) {
                  var data = JSON.jsonDecode(response.body);
                  print(data.toString());
                  print(response.statusCode);
                  if (response.statusCode == 200 &&
                      data['userType'] == 'Merchant') {
                    var currentResponse = JSON.jsonDecode(response.body);
                    var merchantID = currentResponse['id'].toString();
                    saveToLocal("merchantAccessToken", accessToken);
                    saveToLocal("merchId", merchantID);
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                    print("Changing route");
                    emailController.clear();
                    passwordController.clear();
                    Navigator.of(context).pushReplacement(PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            new LandingPage(myAccesstoken: accessToken),
                        transitionDuration: Duration(milliseconds: 900),

                        /// Set animation Opacity in route to detailProduk layout
                        transitionsBuilder:
                            (_, Animation<double> animation, __, Widget child) {
                          return Opacity(
                            opacity: animation.value,
                            child: child,
                          );
                        }));
                    print("Changing route");
                  } else {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                    passwordController.clear();
                    emailController.clear();
                    showInSnackBar(loginResponseData['message']);
                  }
                });
              } else {
                Navigator.of(context, rootNavigator: true).pop('dialog');
                passwordController.clear();
                emailController.clear();
                showInSnackBar(
                    "An Error Occured. Check your details or talk to admin");
              }
            });
          } catch (e) {
            Navigator.of(context, rootNavigator: true).pop('dialog');
            print(e);
          }

          //here
        },
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Container(
            height: 55.0,
            width: 600.0,
            child: Text(
              "Login",
              style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 0.2,
                  fontFamily: "Sans",
                  fontSize: 18.0,
                  fontWeight: FontWeight.w800),
            ),
            alignment: FractionalOffset.center,
            decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 15.0)],
                borderRadius: BorderRadius.circular(30.0),
                gradient: LinearGradient(
                    colors: <Color>[Color(0xFF121940), Color(0xFF6E48AA)])),
          ),
        ));
    //);
  }
}

Future<bool> saveToLocal(String name, String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  return prefs.setString(name, value);
}
