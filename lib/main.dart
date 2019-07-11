import 'package:flutter/material.dart';
import 'package:patron_merchant/login.dart';
import 'package:patron_merchant/redeem.dart';
import 'package:patron_merchant/register.dart';
import 'package:patron_merchant/landingpage.dart';
import 'package:splashscreen/splashscreen.dart';
final logoColour = const Color(0xff2F2092);

void main() => runApp( MaterialApp(
  home: MyHomePage(),
)
  );


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
bool _isAuthenticated = false;
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 5,
        navigateAfterSeconds: new AfterSplash(),
        image: new Image.asset('assets/img/pp.png'),
        backgroundColor: logoColour,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        //onClick: ()=>print("Flutter Egypt"),
        loaderColor: Colors.white
    );
  }
}

class AfterSplash extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

   return  MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': ( context) => //OTPPage(),
              !_isAuthenticated ? LoginPage() : LandingPage(),
          '/auth': (context) => LoginPage(),
          '/register' : (context) => Register(),
          '/login': (context) => LoginPage()
        }
        );

  }
}
