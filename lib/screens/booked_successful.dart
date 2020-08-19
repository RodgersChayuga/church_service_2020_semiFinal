import 'package:churchapp/screens/route_controller.dart';
import 'package:churchapp/models/Response.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'booking_screen.dart';
import 'navigation_bar.dart';
import 'welcome_screen.dart';

class BookedSuccess extends StatefulWidget {
  @override
  _BookedSuccessState createState() => _BookedSuccessState();
}

class _BookedSuccessState extends State<BookedSuccess> {
  final Color primaryColor = Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);

  final Color logoGreen = Color(0xff25bcbb);
  logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.commit();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RouteController()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Image.asset(
              'assets/images/dcu-logo.png',
              fit: BoxFit.contain,
              height: 100,
            ),
            Center(
              child: Text("Deliverance Church Utawala\nThe Church of Choice",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 18)),
            ),
            SizedBox(
              height: 20,
            ),
            Card(
              elevation: 5,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("RESERVATION SUCCESSFUL!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                            fontSize: 18)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '''Thank you for choosing :\n\nDELIVERANCE CHURCH UTAWALA\n\nKindly keep time.''',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                          color: Colors.black87, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    elevation: 5,
                    height: 40,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BookASeat()),
                      );
                    },
                    color: logoGreen,
                    child: Text(
                      'Add Seats',
                      style: GoogleFonts.openSans(
                          color: Colors.white, fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  MaterialButton(
                    elevation: 5,
                    height: 40,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyNavBar()),
                      );
                    },
                    color: logoGreen,
                    child: Text(
                      'Home',
                      style: GoogleFonts.openSans(
                          color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
