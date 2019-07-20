import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as JSON;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:sweet_alert_dialogs/sweet_alert_dialogs.dart';
import 'dart:io';

String otpUrl;
String otpAndUrl;

// import 'package:location/location.dart';
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
final FocusNode employeeFocusNode = FocusNode();
TextEditingController employeeController = new TextEditingController();
TextEditingController dobController = new TextEditingController();
final FocusNode dobFocusNode = FocusNode();
TextEditingController otpController = new TextEditingController();
final FocusNode otpFocusNode = FocusNode();
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
String registerUrl;
var merchantID;
bool termsAccepted = false;
Color _txtColour;
String _value = "";
var _selected;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

class _RegisterState extends State<Register> {
  void _getMerchantToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      merchantID = prefs.getString('merchId');
    });
  }

  var f = new DateFormat('yyy-MM-dd');
  Future _selectDate() async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1901),
      lastDate: new DateTime(2060),
      initialDatePickerMode: DatePickerMode.year,
      // builder: (BuildContext context, Widget child){
      //   return Theme(
      //     data: ,
      //   );
      // }
    );
    if (picked != null)
      setState(() {
        _value = picked.toString();
        DateTime rawDate = DateTime.parse(_value);
        var formattedDate = f.format(rawDate).toString();
        dobController.text = formattedDate;
      });
    // if(picked != null) setState(() => );

    print(_value);
  }

  _showCountryPicker() {
    CountryPicker(
      dense: false,
      showFlag: true, //displays flag, true by default
      showDialingCode: false, //displays dialing code, false by default
      showName: true, //displays country name, true by default
      onChanged: (Country country) {
        setState(() {
          _selected = country;
        });
      },
      selectedCountry: _selected,
    );
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

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  var _currentSelectedValue;
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
                  cursorColor: logoColour,
                  controller: nameController,
                  focusNode: nameFocusNode,
                  validator: (String payload) {
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
                  cursorColor: logoColour,
                  validator: (String payload) {
                    if (payload.isEmpty) {
                      return "Please fill this field";
                    }
                  },
                  decoration: InputDecoration(
                      labelText: "Display name",
                      hintText: "displayname",
                      hintStyle: TextStyle(color: Colors.black54)),
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                TextFormField(
                  controller: emailController,
                  cursorColor: logoColour,
                  focusNode: emailFocusNode,
                  validator: (String email) {
                    if (email.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(email)) {
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
                  controller: mobileController,
                  focusNode: mobileFocusNode,
                  keyboardType: TextInputType.phone,
                  validator: (String payload) {
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
                FormField<String>(
                  builder: (FormFieldState<String> state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        //labelStyle: textStyle,
                        labelText: "Sex",
                        hintText: "Sex",
                        hintStyle: TextStyle(color: Colors.black54),
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 16.0),
                        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                      ),
                      //isEmpty:
                      //  _currentSelectedValue == profilePayload.gender,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _currentSelectedValue,
                          isDense: true,
                          onChanged: (String newValue) {
                            print("I am the new value $newValue");
                            setState(() {
                              _currentSelectedValue = newValue;
                              _currentSelectedValue = newValue;
                              print("Current value $_currentSelectedValue");
                              state.didChange(newValue);
                            });
                          },
                          items:
                              ["Male", "Female", "Other"].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
                // Padding(padding: EdgeInsets.only(top: 20.0)),
                // InkWell(
                //   onTap: _showCountryPicker,
                //   child: IgnorePointer(
                //     child: TextFormField(
                //       initialValue:_selected,
                //       // controller: dobController,
                //       decoration: InputDecoration(
                //           labelText: "Country",
                //           hintText: "Country",
                //           hintStyle: TextStyle(color: Colors.black54)),
                //     ),
                //   ),
                // ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                InkWell(
                  onTap: _selectDate,
                  child: IgnorePointer(
                    child: TextFormField(
                      // initialValue: profilePayload.dob,
                      controller: dobController,
                      decoration: InputDecoration(
                          labelText: "Date of birth",
                          hintText: "Date of birth",
                          hintStyle: TextStyle(color: Colors.black54)),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                TextFormField(
                  //initialValue: profilePayload.email,
                  controller: passwordController,
                  cursorColor: logoColour,
                  obscureText: true,
                  focusNode: passwordFocusNode,
                  validator: (String payload) {
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
                  obscureText: true,
                  controller: employeeController,
                  focusNode: employeeFocusNode,
                  keyboardType: TextInputType.text,
                  validator: (String payload) {
                    if (payload.isEmpty) {
                      return "Please fill this field";
                    }
                  },

                  //initialValue: profilePayload.country,
                  decoration: InputDecoration(
                      labelText: "Pin",
                      hintText: "Pin",
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
                          } else {
                            _txtColour = Colors.red;
                          }
                          print(termsAccepted);
                        });
                      },
                    ),
                    Text("I accept the ", style: TextStyle(color: _txtColour)),
                    InkWell(
                      child: Text(
                        "terms and conditions",
                        style: TextStyle(
                            color: _txtColour,
                            decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 80.0)),
                InkWell(
                  onTap: () async {
                    // showModalBottomSheet(
                    //       context: context,
                    //       builder: (BuildContext context){
                    //         return Container(
                    //           height: 300.0,
                    //           //color: Colors.transparent,
                    //           decoration: BoxDecoration(
                    //             color: Colors.black,
                    //             borderRadius: BorderRadius.only(
                    //               topLeft: Radius.circular(30.0),
                    //               topRight: Radius.circular(30.0),
                    //             )
                    //           ),
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(32.0),
                    //             child: Text("Enter The Otp sent to your phone"),

                    //           ),
                    //         );
                    //       }

                    //     );
                    if (!_registerFormKey.currentState.validate() ||
                        !termsAccepted) {
                      setState(() {
                        _txtColour = Colors.red;
                      });
                      return;
                    }
                    if (isInDebugMode) {
                      registerUrl =
                          "http://vader.patronpass.io/api/auth/signup/customer";
                    } else {
                      registerUrl =
                          "http://skywalker.patronpass.io/api/auth/signup/customer";
                    }
                    //  var location = new Location();
                    //     LocationData userLocation;
                    //     bool gpsActive = await location.serviceEnabled();

                    //     if (!gpsActive) {
                    //       showInSnackBar("Please turn on gps to continue");
                    //       return;
                    //     }
                    //     userLocation = await location.getLocation();
                    //     var userLatitude = userLocation.latitude;
                    //     var userLongitude = userLocation.longitude;
                    //     String country;
                    //     print(
                    //         "I am at Longitude $userLongitude and Latitude $userLatitude");
                    //     print("GPS Active::" + gpsActive.toString());
                    //     await http
                    //         .get(
                    //             "https://maps.googleapis.com/maps/api/geocode/json?latlng=$userLatitude,$userLongitude&sensor=false&key=AIzaSyBK1aWuQ778-mjaAWIdHe3HpxNGbaTa0Ho")
                    //         .then((http.Response response) {
                    //       final responseData = JSON.jsonDecode(response.body);
                    //       //print("XXXXXX ${responseData.toString()}");

                    //       print(
                    //           "CCCVVVD ${responseData['results'].toString()}");
                    //       for (var i in responseData['results'][0]
                    //           ['address_components']) {
                    //         if (i['types'][0] == "country") {
                    //           country = i['long_name'];
                    //           print(" The country is>>>> ${i['long_name']}");
                    //         }
                    //       }
                    //     });

                    _registerFormKey.currentState.save();
                    final String currentTimeZone =
                        await FlutterNativeTimezone.getLocalTimezone();
                    final Map<String, dynamic> registerFormData = {
                      "email": emailController.text,
                      "password": passwordController.text,
                      "mobileNumber": mobileController.text,
                      "country": "Kenya",
                      "name": nameController.text,
                      "username": usernameController.text,
                      "registeredByMerchantId": int.parse(merchantID),
                      "employeePin": employeeController.text,
                      "gender": _currentSelectedValue,
                      "dateOfBirth": _value,
                      "timezone": currentTimeZone,
                    };
                    print("CREEEEDE ${registerFormData.toString()}");
                    _onLoading();
                    await http
                        .post(registerUrl,
                            headers: {"Content-Type": "application/json"},
                            body: JSON.jsonEncode(registerFormData))
                        .then((http.Response response) {
                      final Map<String, dynamic> loginResponseData =
                          JSON.jsonDecode(response.body);
                      print("XXXX ${loginResponseData.toString()}");
                      print(" XOXO $merchantID");
                      final int signUpResponseCode = response.statusCode;
                      print(signUpResponseCode);
                      if (signUpResponseCode == 201) {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                        passwordController.clear();
                        emailController.clear();
                        nameController.clear();
                        usernameController.clear();
                        employeeController.clear();
                        //countryController.clear();
                        dobController.clear();
                        mobileController.clear();
                        termsAccepted = false;
                        //showInSnackBar("Registration Successful");
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: 300,
                                //color: Colors.transparent,
                                decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(30.0))),
                                child: Padding(
                                    padding: const EdgeInsets.all(32.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                            "Enter The Otp sent to your phone"),
                                        TextFormField(
                                          //initialValue: profilePayload.email,
                                          controller: otpController,
                                          cursorColor: logoColour,
                                          obscureText: true,
                                          focusNode: otpFocusNode,
                                          validator: (String payload) {
                                            if (payload.isEmpty) {
                                              return "Please fill this field";
                                            }
                                          },
                                          decoration: InputDecoration(
                                              labelText: "Enter OTP",
                                              hintText: "i.e 1234",
                                              hintStyle: TextStyle(
                                                  color: Colors.black54)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 10.0, bottom: 10.0),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            if (isInDebugMode) {
                                              otpUrl =
                                                  "http://vader.patronpass.io/api/auth/signup/validateOtp?otp=";
                                            } else {
                                              otpUrl =
                                                  "http://skywalker.patronpass.io/api/auth/signup/validateOtp?otp=";
                                            }
                                            // _key.currentState.save();
                                            print("button pressed " +
                                                otpController.text);
                                            otpAndUrl =
                                                otpUrl + otpController.text;
                                            print(otpAndUrl);
                                            //getAccessToken("AccessToken");
                                            // print("SAAVED" + savedAccessToken.toString());

                                            await http
                                                .post(otpAndUrl, headers: {
                                              HttpHeaders.authorizationHeader:
                                                  "Bearer ${loginResponseData['accessToken']}"
                                            }).then((http.Response response) {
                                              _onLoading();
                                              final Map<String, dynamic>
                                                  OtpResponseData =
                                                  JSON.jsonDecode(
                                                      response.body);
                                              final String OtpMessage =
                                                  OtpResponseData['message'];
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop('dialog');
                                              if (OtpMessage ==
                                                  'OTP is not valid please Request For a new One') {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return RichAlertDialog(
                                                      alertTitle: richTitle(
                                                          "Please Request For Another OTP"),
                                                      alertSubtitle:
                                                          richSubtitle(
                                                              OtpResponseData[
                                                                  'message']),
                                                      alertType:
                                                          RichAlertType.ERROR,
                                                      actions: <Widget>[
                                                        FlatButton(
                                                          child: Text("Okay"),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else {
                                                //setEnabled(true);
                                                //setAccessToken(this.accessToken);
                                                // Navigator.of(context, rootNavigator: true).pop('dialog');
                                                //  Navigator.pushReplacement(
                                                //             context,
                                                //             new MaterialPageRoute(
                                                //                 builder: (context) =>
                                                //                     new LandingPage()));
                                              }
                                              print(OtpResponseData);
                                            });
                                          },
                                          child: Container(
                                            height: 55.0,
                                            width: 300.0,
                                            decoration: BoxDecoration(
                                                color: logoColour,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(40.0))),
                                            child: Center(
                                              child: Text(
                                                "Verify OTP",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16.5,
                                                    letterSpacing: 1.0),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                              );
                            });
                      } else {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                        showInSnackBar(
                            "An Error Occured. ${loginResponseData['message']}");
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
                SizedBox(
                  height: 20.0,
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
