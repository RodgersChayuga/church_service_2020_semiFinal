import 'package:churchapp/http/contant/constant.dart';
import 'package:churchapp/screens/route_controller.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

import 'package:churchapp/models/bookedModel.dart';
import 'package:flutter/material.dart';

class BookingStatus extends StatefulWidget {

  @override
  _BookingStatusState createState() => _BookingStatusState();
}

class _BookingStatusState extends State<BookingStatus> {
  final Color primaryColor = Color(0xff18203d);

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



  Future<BookModel> booked;

  Future<BookModel> getBooked() async {
    //get user id  from pref
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String _userId = preferences.getString("userId");
    // TODO: implement getCategories
    // Store all data with Param Name.
    var data = {"user_id": "$_userId"};
    // Starting Web API Call.
    var response = await http.post(Constant.fetchBookUrl, body: data);
    final jsonResponse = jsonDecode(response.body);
    return BookModel.fromJson(jsonResponse);
  }



  @override
  void initState() {
    super.initState();
    booked=getBooked();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(8, 1, 1, 1),
          child: Image.asset(
            'assets/images/dcu-logo.png',
            fit: BoxFit.contain,
            height: 25,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () => logOut(),
          ),
        ],
        title: Center(child: Text('My Booking Status')),
        backgroundColor: primaryColor,
      ),
      body: showBooked(),
    );
  }

  Widget showBooked() {
    return FutureBuilder<BookModel>(
      future: booked,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return showMyUI(snapshot.data.booked);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
// By default, show a loading spinner.
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }

  Widget showMyUI(List<Booked> booked) {
    return new ListView.builder(
      itemCount: booked.length,
      itemBuilder: (_, index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: new Container(
            margin: new EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
            child: new Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: InkWell(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Padding(
                          padding: new EdgeInsets.symmetric(vertical: 3.0)),
                      new Text(
                          'Selected Service : ${booked[index].serviceType} Service'),
                      // new Padding(
                      //     padding: new EdgeInsets.symmetric(vertical: 3.0)),
                      // new Text('ID : ${booked[index].reservationId}'),
                      new Padding(
                          padding: new EdgeInsets.symmetric(vertical: 3.0)),
                      new Text(
                          'No of Seats Reserved : ${booked[index].seatNo}'),
                      new Padding(
                          padding: new EdgeInsets.symmetric(vertical: 3.0)),
                      new Text(
                          'Remaining seats : ${booked[index].availableSeats}'),

                      new Padding(
                          padding: new EdgeInsets.symmetric(vertical: 3.0)),
                      new Text(
                          'Seats Booked :  ${  jsonDecode(booked[index].seats)  }'),

//                    new Padding(
//                        padding: new EdgeInsets.symmetric(vertical: 3.0)),
//                    new Text('Starts : ${booked[index].startHour}'),
//                    new Padding(
//                        padding: new EdgeInsets.symmetric(vertical: 3.0)),
//                    new Text('Ends : ${booked[index].endHour}'),

                      new Padding(
                          padding: new EdgeInsets.symmetric(vertical: 3.0)),
                      new Text('Start : ${booked[index].startHour}'),

                      new Padding(
                          padding: new EdgeInsets.symmetric(vertical: 3.0)),
                      new Text('End: ${booked[index].endHour}'),


                      new Padding(
                          padding: new EdgeInsets.symmetric(vertical: 3.0)),
                      new Text('Date Reserved : ${booked[index].createdAt}'),
                      new Padding(
                          padding: new EdgeInsets.symmetric(vertical: 9.0)),
                      new Text('status : ${booked[index].reservationStatus}'),
                      new Padding(
                          padding: new EdgeInsets.symmetric(vertical: 3.0)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
