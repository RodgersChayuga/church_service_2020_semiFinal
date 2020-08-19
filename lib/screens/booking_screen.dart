import 'dart:convert';
import 'dart:developer';
import 'package:churchapp/http/contant/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:churchapp/http/http_response/http_response.dart';
import 'package:churchapp/models/Response.dart';
import 'package:churchapp/screens/route_controller.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'seats/seats_number.dart';
import 'package:http/http.dart' as http;

enum Service { FIRST, SECOND, THIRD, FOURTH }

extension ServiceExtension on Service {
  String get _service {
    switch (this) {
      case Service.FIRST:
        return "1";
      case Service.SECOND:
        return "2";
      case Service.THIRD:
        return "3";
      case Service.FOURTH:
        return "4";
      default:
        return null;
    }
  }
}

class BookASeat extends StatefulWidget {
  BookASeat() : super();

  final String title = "BookASeat";

  @override
  BookASeatState createState() => BookASeatState();
}

class Company {
  int id;
  String name;

  Company(this.id, this.name);

  static List<Company> getCompanies() {
    return <Company>[
      Company(1, '1st Service'),
      Company(2, 'Sunday school'),
      Company(3, '2nd service'),
      Company(4, 'Teen\'s Service'),
      Company(5, '3rd Service'),
    ];
  }
}

class BookASeatState extends State<BookASeat> implements HttpCallBack {
  //Primary Color
  final Color primaryColor = Color(0xff18203d);
  final Color logoGreen = Color(0xff25bcbb);
  final Color secondaryColor = Color(0xff232c51);


  List<dynamic> selectedValues = [];
  var concatenate = StringBuffer();


  //Service method
  Service _serviceValue;

  //declare variables ........................
  String username;
  int seat;
  String service;
  int church = 1;

  //declare progress dialog
  ProgressDialog pr;

  //validate fields
  bool _validate = false;

  // declare Controllers....................
  TextEditingController _username = TextEditingController();
  TextEditingController _seat = TextEditingController();

  //declare global keys ........................
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //Declare response
  HttpResponse _response;
  bool isButtonEnabled=true;

  //initialize response
  BookASeatState() {
    _response = new HttpResponse(this);
  }

  //on book button clicked calls this
  void _submit() {
    var seats = int.parse(_seat.text);
    final form = _formKey.currentState;
    if (_validate == false) {
      setState(() {
        form.save();
        String json=jsonEncode(selectedValues);
      _response.doBook(service, seats, church,json);

      });
    }
  }

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

  //
  List<Company> _companies = Company.getCompanies();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  Company _selectedCompany;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<Company>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<Company>> items = List();
    for (Company company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Company selectedCompany) {
    setState(() {
      _selectedCompany = selectedCompany;
    });
  }

//declaring time and date pickers
  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();

  //Date setup
  // Future<Null> _selectDate(BuildContext context) async {
  //   final DateTime picked = await showDatePicker(
  //       context: context,
  //       initialDate: _date,
  //       firstDate: new DateTime(2019),
  //       lastDate: new DateTime(2030));

  //   if (picked != null && picked != _date) {
  //     print('Date selected: ${_date.toString()}');
  //     setState(() {
  //       _date = picked;
  //     });
  //   }
  // }

  // //Time setup
  // Future<Null> _selectTime(BuildContext context) async {
  //   final TimeOfDay picked =
  //       await showTimePicker(context: context, initialTime: _time);

  //   if (picked != null && picked != _time) {
  //     print('Time selected: ${_time.toString()}');
  //     setState(() {
  //       _time = picked;
  //     });
  //   }
  // }

  //show toast message
  void showToast(String message) {
    Fluttertoast.showToast(
        msg: '$message',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[800],
        textColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
//      customBody: LinearProgressIndicator(
//        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
//        backgroundColor: Colors.white,
//      ),
    );

    pr.style(
      message: 'Loading',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );
    return Scaffold(
      key: _scaffoldKey,
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
        title: Center(
          child: Text('Book Your Seat'),
        ),
        backgroundColor: primaryColor,
      ),
      body: Container(
        decoration: new BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: Color(0xffeeeeee),
              blurRadius: 1.0,
              offset: new Offset(1.0, 1.0),
            ),
          ],
          borderRadius: new BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Container(
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                            "Deliverance Church Utawala\nSeating Structure", textAlign: TextAlign.center,
                                          style: GoogleFonts.openSans(
                                              color: Colors.black87, fontSize: 21, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Image.asset("assets/images/seats-structure.png")
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 5),
                                child: Text(
                                  "Select Service",
                                  style: TextStyle(
                                      color: Color(0xff616161), fontSize: 16.0),
                                ),
                              ),
                              RadioListTile(
                                title: const Text('1st Service'),
                                value: Service.FIRST,
                                groupValue: _serviceValue,
                                onChanged: (Service value) {
                                  setState(() {
                                    _serviceValue = value;
                                    Service data = value;
                                    service = data._service;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text('Sunday school'),
                                value: Service.SECOND,
                                groupValue: _serviceValue,
                                onChanged: (Service value) {
                                  setState(() {
                                    _serviceValue = value;
                                    Service data = value;
                                    service = data._service;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text('2nd Service'),
                                value: Service.THIRD,
                                groupValue: _serviceValue,
                                onChanged: (Service value) {
                                  setState(() {
                                    _serviceValue = value;
                                    Service data = value;
                                    service = data._service;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text('Teen\'s service',
                                ),
                                value: Service.FOURTH,
                                groupValue: _serviceValue,
                                onChanged: (Service value) {
                                  setState(() {
                                    _serviceValue = value;
                                    Service data = value;
                                    service = data._service;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Card(

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 5),
                                child: Text(
                                  "Select Seat Number(s)",
                                  style: TextStyle(
                                      color: Color(0xff616161), fontSize: 16.0),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new MultiSelect(
                                  autovalidate: true,
                                  initialValue: [' ', ' '],
                                  titleText: '',
                                  maxLength: 5, // optional
                                  validator: (dynamic value) {
                                    if (value == null) {
                                      return 'Please select one or more seat(s)';
                                    }
                                    return null;
                                  },
                                  errorText: 'Please select one or more seat(s)',
                                  dataSource: seatDropDown,
                                  textField: 'seat_number',
                                  valueField: 'ID',
                                  filterable: true,
                                  required: true,
                                  onSaved: (value) {
                                    print('The value is $value');

                                  },

                                  change: (value) async {

                                    selectedValues = value;
//                                    selectedValues.forEach((item){
//                                      concatenate.write(item);
//                                    });



                                    if(service==null){
                                      showToast("Select service");
                                      setState(() {
                                        isButtonEnabled=true;
                                      });
                                    }else{
                                      var len=selectedValues.length;
                                      _seat.text=len.toString();


                                      for (var i = 0; i < len; i++) {
                                        String json=jsonEncode(selectedValues[i]);
                                        var data = {

                                          "service_name":"$service",
                                          "seats": "$json",
                                        };
                                          showToast("Selecting..");
                                        // Starting Web API Call.
                                        var response = await http.post(Constant.checkSeat, body: data);
                                        // Getting Server response into variable.
                                        final rData = jsonDecode(response.body);
                                        Response r=  Response.fromResponse(rData);
                                        if(r.error==true){
                                           setState(() {
                                             isButtonEnabled=true;
                                             showToast(r.message);
                                           });
                                        }else{
                                          setState(() {
                                            isButtonEnabled=false;
                                          });
                                        }
                                      }
                                    }
                                  },

                                  selectIcon: Icons.arrow_drop_down_circle,
                                  saveButtonColor: Theme.of(context).primaryColor,
                                  checkBoxColor: Theme.of(context).primaryColorDark,
                                  cancelButtonColor: Theme.of(context).primaryColorLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: 0.5,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 60,top: 0, right: 60, bottom: 0),
                        child: RaisedButton(
                          elevation: 1,
                          onPressed: isButtonEnabled ? null: () {
                            setState(() {
                              if (_seat.text.isEmpty) {
                                _validate = true;
                                showToast("Select number of seats");
                              } else if (_seat.text.isNotEmpty) {
                                pr.show();
                                _validate = false;
                                _submit();
                              }
                            });
                          },
                          color: logoGreen,
                          child: Text(
                            'Book now',
                            style: GoogleFonts.openSans(
                                color: Color(0xff18203d), fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onError(String error) {
    // TODO: implement onError

    pr.hide();
    log('Booking error: $error');
  }

  @override
  void onSuccess(Response response) {
    // TODO: implement onSuccess
    if (response != null) {
      if (response.error == false) {
        pr.hide();
        String message = response.message;
        showToast("$message");
         Navigator.pushNamed(context, 'BookedSuccess');
      } else if (response.error == true) {
        pr.hide();
        String message = response.message;
        showToast("$message");
      }
    } else {
      pr.hide();
      showToast("failed");
    }
  }


}
