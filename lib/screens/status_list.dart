import 'package:churchapp/models/bookedModel.dart';
import 'package:flutter/material.dart';

class StatusList extends StatefulWidget {
  final List<Booked> booked;

  const StatusList({Key key, this.booked}) : super(key: key);
  @override
  _StatusListState createState() => _StatusListState();
}

class _StatusListState extends State<StatusList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: showMyUI(),

    );
  }
  Widget showMyUI() {
    return new ListView.builder(
      itemCount: widget.booked.length,
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
                          'Selected Service : ${widget.booked[index].serviceType} Service'),
                      // new Padding(
                      //     padding: new EdgeInsets.symmetric(vertical: 3.0)),
                      // new Text('ID : ${booked[index].reservationId}'),
                      new Padding(
                          padding: new EdgeInsets.symmetric(vertical: 3.0)),
                      new Text(
                          'No of Seats Reserved : ${widget.booked[index].seatNo}'),
                      new Padding(
                          padding: new EdgeInsets.symmetric(vertical: 3.0)),
                      new Text(
                          'Remaining seats : ${widget.booked[index].availableSeats}'),
//                    new Padding(
//                        padding: new EdgeInsets.symmetric(vertical: 3.0)),
//                    new Text('Starts : ${booked[index].startHour}'),
//                    new Padding(
//                        padding: new EdgeInsets.symmetric(vertical: 3.0)),
//                    new Text('Ends : ${booked[index].endHour}'),
                      new Padding(
                          padding: new EdgeInsets.symmetric(vertical: 3.0)),
                      new Text('Date Reserved : ${widget.booked[index].createdAt}'),
                      new Padding(
                          padding: new EdgeInsets.symmetric(vertical: 9.0)),
                      new Text('status : '),
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