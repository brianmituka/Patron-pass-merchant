import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as JSON;
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:sweet_alert_dialogs/sweet_alert_dialogs.dart';

final String rewardsUrl = "http://api.patronpass.io/api/reward/purchaseReward";
final String detailsUrl = 'http://api.patronpass.io/api/users/details/';
final logoColour = const Color(0xff2F2092);
final GlobalKey<FormState> _addpointsFormKey = GlobalKey<FormState>();
final FocusNode pinFocusNode = FocusNode();
TextEditingController pinController = new TextEditingController();
final FocusNode amountFocusNode = FocusNode();
TextEditingController amountController = new TextEditingController();
final FocusNode couponFocusNode = FocusNode();
TextEditingController couponController = new TextEditingController();
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
final FocusNode referenceFocusNode = FocusNode();
TextEditingController refController = new TextEditingController();
var accesstoken;
var name = "";
var totalSpent = "";
var points = "";
var referrals = "";
var joined = "";
var updated = "";
var checkins;
var redemptions;

bool reedeem = true;
var _txtCustomHead = TextStyle(
  color: Colors.black54,
  fontSize: 17.0,
  fontWeight: FontWeight.w600,
  fontFamily: "Gotik",
);

/// Custom Text Detail
var _txtCustomSub = TextStyle(
  color: Colors.black38,
  fontSize: 13.5,
  fontWeight: FontWeight.w500,
  fontFamily: "Gotik",
);

class Redeem extends StatefulWidget {
  Reedemer reedemer;
  Redeem([this.reedemer]);

  @override
  _RedeemState createState() => _RedeemState(reedemer);
}

class _RedeemState extends State<Redeem> {
  Reedemer reedemer;

  _RedeemState([this.reedemer]);
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

  Future getUserDetails() async {
    final f = new DateFormat('dd-MM-yyy');

    await _getMerchantToken();
    final String userUrl = detailsUrl + reedemer.userId.toString();
    await http
        .get(userUrl, headers: {"Authorization": "Bearer $accesstoken"}).then(
            (http.Response response) {
      _onLoading();
      var data = JSON.jsonDecode(response.body);
      print(data.toString());
      print(response.statusCode);
      if (response.statusCode == 200) {
        setState(() {
          name = data['userSummary']['name'];
          points = (data['membership']['points']).toString();
          totalSpent = data['totalAmountSpent'].toString();
          referrals = data['totalReferrals'].toString();
          redemptions = data['totalRedemptions'].toString();
          checkins = data['totalCheckIns'].toString();
          joined = f.format(DateTime.parse(data['membership']['createdAt']));
          updated = "false";
        });

        Navigator.of(context, rootNavigator: true).pop('dialog');
      } else {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        showInSnackBar(data['message']);
      }
    });
  }

  void checkUpdate() {
    Timer.periodic(new Duration(seconds: 5), (timer) {
      getUserDetails();
      print(timer);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    //_getMerchantToken();
    getUserDetails();
    //checkUpdate();
    super.initState();
  }

  Future _getMerchantToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      accesstoken = prefs.getString('merchantAccessToken');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: reedemer.campaignId != null
              ? Text("Redeem Campaign")
              : Text("Add points"),
          backgroundColor: logoColour,
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, left: 15.0),
                  child: Text("Customer Details", style: _txtCustomHead),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4.5,
                            spreadRadius: 1.0,
                          )
                        ]),
                    child: Column(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, left: 20.0, right: 60.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("$name",
                                    style: _txtCustomHead.copyWith(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600)),
                                Image.asset(
                                  "assets/img/pp.png",
                                  height: 30.0,
                                )
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, bottom: 5.0, left: 20.0, right: 60.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Member Since",
                                    style: _txtCustomSub,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text("$joined"),
                                  ),
                                ],
                              ),
                              Column(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Total  Spent",
                                    style: _txtCustomSub,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text("$totalSpent"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 15.0,
                            bottom: 30.0,
                            left: 20.0,
                            right: 30.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Number of referral",
                                    style: _txtCustomSub,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text("$referrals"),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Total Points",
                                    style: _txtCustomSub,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text("$points"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 1000.0,
                          color: logoColour.withOpacity(0.1),
                          child: Center(
                              // child: InkWell(
                              //   child: Text("Edit Details", style: _txtCustomHead.copyWith(
                              //     fontSize: 15.0, color: Colors.blueGrey
                              //   ),),
                              // ),
                              ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 30.0, left: 15.0, bottom: 10.0),
                          child: reedemer.campaignId != null
                              ? Text(
                                  "Redeem campaign",
                                  style:
                                      _txtCustomHead.copyWith(fontSize: 16.0),
                                )
                              : Text(
                                  "Add points",
                                  style:
                                      _txtCustomHead.copyWith(fontSize: 16.0),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 15.0, right: 15.0, bottom: 10.0),
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: Form(
                                key: _addpointsFormKey,
                                child: reedemer.campaignId != null
                                    ? Column(
                                        children: <Widget>[
                                          TextFormField(
                                            //initialValue: profilePayload.name,
                                            controller: refController,

                                            focusNode: referenceFocusNode,
                                            decoration: InputDecoration(
                                                labelText: "Reference Number",
                                                hintText: "Reference Number",
                                                hintStyle: TextStyle(
                                                    color: Colors.black54)),
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(top: 20.0)),
                                          TextFormField(
                                            // initialValue: reedemer.couponCode,
                                            decoration: InputDecoration(
                                                labelText:
                                                    "Coupon/Referral code",
                                                hintText:
                                                    "Coupon/Referral code",
                                                hintStyle: TextStyle(
                                                    color: Colors.black54)),
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(top: 20.0)),
                                          TextFormField(
                                            //initialValue: profilePayload.email,
                                            controller: pinController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                labelText: "Employee Pin",
                                                hintText: "Employee Pin",
                                                hintStyle: TextStyle(
                                                    color: Colors.black54)),
                                          ),
                                          buttonBlackBottom(
                                              reedemer, getUserDetails)
                                        ],
                                      )
                                    : Column(
                                        children: <Widget>[
                                          TextFormField(
                                            //initialValue: profilePayload.name,
                                            controller: amountController,
                                            focusNode: amountFocusNode,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                labelText: "Amount Spent",
                                                hintText: "Amount Spent",
                                                hintStyle: TextStyle(
                                                    color: Colors.black54)),
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(top: 20.0)),
                                          TextFormField(
                                            //initialValue: profilePayload.name,
                                            controller: refController,
                                            focusNode: referenceFocusNode,
                                            decoration: InputDecoration(
                                                labelText: "Reference Number",
                                                hintText: "Reference Number",
                                                hintStyle: TextStyle(
                                                    color: Colors.black54)),
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(top: 20.0)),
                                          TextFormField(
                                            initialValue: reedemer.couponCode,
                                            controller: couponController,
                                            focusNode: couponFocusNode,
                                            decoration: InputDecoration(
                                                labelText:
                                                    "Coupon/Referral code",
                                                hintText:
                                                    "Coupon/Referral code",
                                                hintStyle: TextStyle(
                                                    color: Colors.black54)),
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(top: 20.0)),
                                          TextFormField(
                                            //initialValue: profilePayload.email,
                                            controller: pinController,
                                            focusNode: pinFocusNode,
                                            decoration: InputDecoration(
                                                labelText: "Employee Pin",
                                                hintText: "Employee Pin",
                                                hintStyle: TextStyle(
                                                    color: Colors.black54)),
                                          ),
                                          buttonBlackBottom(
                                              reedemer, getUserDetails)
                                        ],
                                      ),
                              )),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

void showInSnackBar(String value) {
  _scaffoldKey.currentState
      .showSnackBar(new SnackBar(content: new Text(value)));
}

class buttonBlackBottom extends StatelessWidget {
  Reedemer reedemer;
  Function getUserDetails;
  GestureTapCallback _callback;
  buttonBlackBottom(this.reedemer, this._callback);
  @override
  Widget build(BuildContext context) {
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

    return InkWell(
        onTap: () {
          // if (!_addpointsFormKey.currentState.validate()) {
          //   return;
          //  }

          if (reedemer.type == "points") {
            _addpointsFormKey.currentState.save();
            final Map<String, dynamic> addpointsFormData = {
              "employeePin": pinController.text,
              "amountSpent": amountController.text,
              "couponCode": couponController.text,
              "customerId": reedemer.userId,
              "referenceNumber": refController.text
            };
            print("CREEEEDE ${addpointsFormData.toString()}");
            print(">>>$accesstoken");
            _onLoading();
            http
                .post(rewardsUrl,
                    headers: {
                      "Authorization": "Bearer $accesstoken",
                      "Content-Type": "application/json"
                    },
                    body: JSON.jsonEncode(addpointsFormData))
                .then((http.Response response) {
              final Map<String, dynamic> addpointsResponseData =
                  JSON.jsonDecode(response.body);
              print("XXXX ${addpointsResponseData.toString()}");
              //  print(" XOXO $merchantID");
              final int addpointsResponseCode = response.statusCode;
              print(addpointsResponseCode);
              if (addpointsResponseCode == 200) {
                Navigator.of(context, rootNavigator: true).pop('dialog');
                pinController.clear();
                couponController.clear();
                amountController.clear();
                refController.clear();
                _callback();
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return RichAlertDialog(
                        alertTitle: richTitle("Points added"),
                        alertSubtitle: richSubtitle("Current points: $points"),
                        alertType: RichAlertType.SUCCESS,
                        actions: <Widget>[
                          FlatButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              } else {
                Navigator.of(context, rootNavigator: true).pop('dialog');
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return RichAlertDialog(
                        alertTitle: richTitle("Oops! an error occured"),
                        alertSubtitle:
                            richSubtitle("${addpointsResponseData['message']}"),
                        alertType: RichAlertType.ERROR,
                        actions: <Widget>[
                          FlatButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
                //showInSnackBar(addpointsResponseData['message']);
              }
            });
          } else if (reedemer.type == "campaign") {
            print("It is a campaign");
            Map campaignRedeemMap = {
              "customerId": reedemer.userId,
              "employeePin": pinController.text,
              "amountSpent": amountController.text,
              //"couponCode": reedemer.couponCode,
              "campaignId": reedemer.campaignId,
              "isCashTransaction": true,
              "timezone": "Africa/Nairobi",
              "referenceNumber": refController.text
            };
            print(campaignRedeemMap.toString());
            _onLoading();
            http
                .post('http://api.patronpass.io/api/reward/campaignRedemption',
                    headers: {
                      "Authorization": "Bearer $accesstoken",
                      "Content-Type": "application/json"
                    },
                    body: JSON.jsonEncode(campaignRedeemMap))
                .then((http.Response response) {
              final Map<String, dynamic> redeemResponseData =
                  JSON.jsonDecode(response.body);
              print("XXXX ${redeemResponseData.toString()}");
              //  print(" XOXO $merchantID");
              print("XXXXVVX" + response.body);
              final int redeemResponseCode = response.statusCode;
              print(redeemResponseCode);
              if (redeemResponseCode == 200) {
                Navigator.of(context, rootNavigator: true).pop('dialog');
                pinController.clear();
                couponController.clear();
                amountController.clear();
                refController.clear();
                //showInSnackBar("Campaign redeemed");
                _callback();
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return RichAlertDialog(
                        alertTitle: richTitle("Campaign redeemed"),
                        alertSubtitle: richSubtitle("Success"),
                        alertType: RichAlertType.SUCCESS,
                        actions: <Widget>[
                          FlatButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              } else {
                Navigator.of(context, rootNavigator: true).pop('dialog');
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return RichAlertDialog(
                        alertTitle: richTitle("Oops! an error occured"),
                        alertSubtitle:
                            richSubtitle("${redeemResponseData['message']}"),
                        alertType: RichAlertType.ERROR,
                        actions: <Widget>[
                          FlatButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
                //showInSnackBar(redeemResponseData['message']);
              }
              //print("Clicked");
            });
          }
        },
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Container(
            height: 55.0,
            width: 600.0,
            child: reedemer.campaignId != null
                ? Text(
                    "Redeem",
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 0.2,
                        fontFamily: "Sans",
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800),
                  )
                : Text(
                    "Add points",
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
  }
}

class Reedemer {
  final int userId;
  final String userName;
  final String points;
  final String type;
  final int campaignId;
  final String couponCode;

  const Reedemer(
      {this.points,
      this.userId,
      this.userName,
      this.type,
      this.campaignId,
      this.couponCode});
}
