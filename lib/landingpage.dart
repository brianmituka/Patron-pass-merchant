import 'package:flutter/material.dart';
import 'package:patron_merchant/redeem.dart';
import 'package:patron_merchant/register.dart';
import 'package:patron_merchant/edituser.dart';
import 'package:barcode_scan/barcode_scan.dart';
import "dart:convert" as JSON;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:patron_merchant/login.dart';
import 'package:http/http.dart' as http;

String userUrl;

final logoColour = const Color(0xff2F2092);

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

class LandingPage extends StatefulWidget {
  final String myAccesstoken;
  LandingPage({this.myAccesstoken});
  @override
  _LandingState createState() => _LandingState(myAccesstoken: myAccesstoken);
}

class _LandingState extends State<LandingPage> with TickerProviderStateMixin {
  final String myAccesstoken;
  _LandingState({this.myAccesstoken});
  @override
  void initState() {
    // TODO: implement initState
    getUserDetails();
    super.initState();
    print("IANNN $myAccesstoken");
  }

  String merchantName = "";
  String accessToken;

  void _incrementCounter() {
    setState(() {});
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

  Future<void> getUserDetails() async {
    if (isInDebugMode) {
      userUrl = "http://vader.patronpass.io/api/users/current";
    } else {
      userUrl = "http://skywalker.patronpass.io/api/users/current";
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _onLoading();
    accessToken = prefs.getString('merchantAccessToken');
    await http
        .get(userUrl, headers: {"Authorization": "Bearer $myAccesstoken"}).then(
            (http.Response response) {
      setState(() {
        var data = JSON.jsonDecode(response.body);
        var responseCode = response.statusCode;
        print(" RESPONSECODE >> $responseCode");
        if (data != null) {
          merchantName = data['name'];
          Navigator.of(context, rootNavigator: true).pop('dialog');
        }
        print(data.toString());
        print(response.statusCode);
      });
    });
  }
 Future removeToken () async {
   final SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    Future scan() async {
      try {
        final scanner = await BarcodeScanner.scan();
        print(">>>> ${scanner.toString()}");
        Map<String, dynamic> payload = JSON.jsonDecode(scanner.toString());
        //print(payload);
        if (payload['campaignId'] != null) {
          Reedemer _reedemer = new Reedemer(
              type: "campaign",
              campaignId: payload['campaignId'],
              userId: payload['customerId'],
              couponCode: payload['couponCode']);
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (_, __, ___) => new Redeem(_reedemer),
              transitionDuration: Duration(milliseconds: 900),

              /// Set animation Opacity in route to detailProduk layout
              transitionsBuilder:
                  (_, Animation<double> animation, __, Widget child) {
                return Opacity(
                  opacity: animation.value,
                  child: child,
                );
              }));
        } else {
          Reedemer _reedemer =
              new Reedemer(type: "points", userId: payload['id']);
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (_, __, ___) => new Redeem(_reedemer),
              transitionDuration: Duration(milliseconds: 900),

              /// Set animation Opacity in route to detailProduk layout
              transitionsBuilder:
                  (_, Animation<double> animation, __, Widget child) {
                return Opacity(
                  opacity: animation.value,
                  child: child,
                );
              }));
        }
      } catch (e) {
        print(e.toString());
      }
    }

    var _userInfoWidget = Container(
      child: Row(
        children: <Widget>[
          Expanded(
              child: Card(
                  child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 25,
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: new Text(
                  'Hello, $merchantName',
                  style: TextStyle(
                      fontFamily: 'WorkSansSemiBold', color: logoColour),
                ),
              ),
            ],
          )))
        ],
      ),
    );
    var _registrationSection = Container(
      height: 80,
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
              child: GestureDetector(
            child: Card(
                child: InkWell(
              onTap: () {
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (_, __, ___) => new Register(),
                    transitionDuration: Duration(milliseconds: 900),

                    /// Set animation Opacity in route to detailProduk layout
                    transitionsBuilder:
                        (_, Animation<double> animation, __, Widget child) {
                      return Opacity(
                        opacity: animation.value,
                        child: child,
                      );
                    }));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    IconButton(
                        onPressed: null,
                        icon: Icon(Icons.blur_on, color: logoColour)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Register",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: logoColour),
                      ),
                    )
                  ],
                ),
              ),
            )),
          )),
          Expanded(
              child: Card(
                  child: InkWell(
            onTap: scan,

            //     (){
            //      Navigator.of(context).push(PageRouteBuilder(
            // pageBuilder: (_, __, ___) => new Redeem(_reedemer),
            // transitionDuration: Duration(milliseconds: 900),

            // /// Set animation Opacity in route to detailProduk layout
            // transitionsBuilder:
            //     (_, Animation<double> animation, __, Widget child) {
            //   return Opacity(
            //     opacity: animation.value,
            //     child: child,
            //   );
            // }));
            //     },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  IconButton(
                      onPressed: null,
                      icon: Icon(Icons.blur_on, color: logoColour)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Reward",
                      style: TextStyle(
                          fontWeight: FontWeight.w700, color: logoColour),
                    ),
                  )
                ],
              ),
            ),
          ))

              //   Card(
              //     child: InkWell(
              //       onTap: () {
              //          Navigator.of(context).push(PageRouteBuilder(
              // pageBuilder: (_, __, ___) => new Edit(),
              // transitionDuration: Duration(milliseconds: 900),

              // /// Set animation Opacity in route to detailProduk layout
              // transitionsBuilder:
              //     (_, Animation<double> animation, __, Widget child) {
              //   return Opacity(
              //     opacity: animation.value,
              //     child: child,
              //   );
              // }));
              //       },
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Row(
              //         children: <Widget>[
              //           IconButton( onPressed: null,
              //               icon: Icon(Icons.camera, color: logoColour)),
              //           Padding(
              //             padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //             child: Text(
              //               "Edit Details",
              //               style: TextStyle(
              //                   fontWeight: FontWeight.w700,
              //                   color: logoColour
              //               ),
              //             ),
              //           )
              //         ],
              //       ),
              //     ),
              //     )

              //   )
              )
        ],
      ),
    );
    var _validationsection = Container(
      height: 80,
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
      child: Row(
        children: <Widget>[
          Container(),
          Container(),
          GestureDetector(
            child: Card(
                child: InkWell(
              onTap: scan,

              //     (){
              //      Navigator.of(context).push(PageRouteBuilder(
              // pageBuilder: (_, __, ___) => new Redeem(_reedemer),
              // transitionDuration: Duration(milliseconds: 900),

              // /// Set animation Opacity in route to detailProduk layout
              // transitionsBuilder:
              //     (_, Animation<double> animation, __, Widget child) {
              //   return Opacity(
              //     opacity: animation.value,
              //     child: child,
              //   );
              // }));
              //     },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    IconButton(
                        onPressed: null,
                        icon: Icon(Icons.blur_on, color: logoColour)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Redeem",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: logoColour),
                      ),
                    )
                  ],
                ),
              ),
            )),
          )

          // Expanded(
          //     child: Card(
          //       child: InkWell(
          //         onTap: null,
          //       child: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Row(
          //           children: <Widget>[
          //             IconButton( onPressed: null,
          //                 icon: Icon(Icons.camera, color: logoColour)),
          //             Padding(
          //               padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //               child: Text(
          //                 "Validate",
          //                 style: TextStyle(
          //                     fontWeight: FontWeight.w700,
          //                     color: logoColour
          //                 ),
          //               ),
          //             )
          //           ],
          //         ),
          //       ),
          //       )

          //     ))
        ],
      ),
    );
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Patron Pass"),
          backgroundColor: logoColour,
          actions: <Widget>[
            InkWell(
              // Replace with a Row for horizontal icon + text
              onTap: () {
                print("Log Out....");
                removeToken();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => LoginPage()));
              },
              child: Icon(Icons.power_settings_new),
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _userInfoWidget,
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  _registrationSection,
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  // Container(
                  //   child: _validationsection,
                  // )
                ],
              ),
            )
          ],
        ));
  }
}
