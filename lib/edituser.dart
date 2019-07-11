import 'package:flutter/material.dart';
final logoColour = const Color(0xff2F2092);

class Edit extends StatefulWidget {
  @override
 _EditState  createState() =>_EditState();
}

class _EditState extends State<Edit> {

  void _incrementCounter() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       centerTitle: true,
        title: Text("Edit Details"),
        backgroundColor: logoColour,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
            child: Column(
              children: <Widget>[
                Text(
                  "Edit user details",
                  style: TextStyle(
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.w600,
                      fontSize: 25.0,
                      color: Colors.black54,
                      fontFamily: "Gotik"),
                ),
                Padding(padding: EdgeInsets.only(top: 50.0)),
                TextFormField(
                  //initialValue: profilePayload.name,
                  decoration: InputDecoration(
                      labelText: "Name ",
                      hintText: "Name",
                      hintStyle: TextStyle(color: Colors.black54)),
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                TextFormField(
                 // initialValue: profilePayload.username,
                  decoration: InputDecoration(
                      labelText: "Username",
                      hintText: "username",
                      hintStyle: TextStyle(color: Colors.black54)),
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                TextFormField(
                  //initialValue: profilePayload.email,
                  decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.black54)),
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                TextFormField(
                 // initialValue: profilePayload.mobile,
                  decoration: InputDecoration(
                      labelText: "Mobile Number",
                      hintText: "Mobile Number",
                      hintStyle: TextStyle(color: Colors.black54)),
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                TextFormField(
                  //initialValue: profilePayload.gender,
                  decoration: InputDecoration(
                      labelText: "Gender",
                      hintText: "Gender",
                      hintStyle: TextStyle(color: Colors.black54)),
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                TextFormField(
                  //initialValue: profilePayload.dob,
                  decoration: InputDecoration(
                      labelText: "DOB",
                      hintText: "Date of birth",
                      hintStyle: TextStyle(color: Colors.black54)),
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                TextFormField(
                  //initialValue: profilePayload.country,
                  decoration: InputDecoration(
                      labelText: "Country",
                      hintText: "Country",
                      hintStyle: TextStyle(color: Colors.black54)),
                ),
                Padding(padding: EdgeInsets.only(top: 80.0)),
                InkWell(
                  onTap: () {
                    print("Updated");
//                    Navigator.of(context).pushReplacement(PageRouteBuilder(
//                        pageBuilder: (_, __, ___) => payment()));
                  },
                  child: Container(
                    height: 55.0,
                    width: 300.0,
                    decoration: BoxDecoration(
                        color: logoColour,
                        borderRadius: BorderRadius.all(Radius.circular(40.0))),
                    child: Center(
                      child: Text(
                        "Update User",
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
        ),
      ),
    );
  }
}
