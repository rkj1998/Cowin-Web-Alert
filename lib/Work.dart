import 'dart:async';
import 'dart:convert';

import 'package:cowin_web_alert/const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class Working extends StatefulWidget {
  final distId;
  Working(this.distId);
  @override
  _WorkingState createState() => _WorkingState();
}

class _WorkingState extends State<Working> {
  var _future;
  @override
  void initState() {
    super.initState();
    setUpTimedFetch();
  }
  setUpTimedFetch() {
    Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _future = getSlots(widget.distId);
      });
    });
  }
  getSlots(var distID) async {
    String date = DateFormat('dd-MM-yyyy').format(DateTime.now());
    var url = Uri.parse(baseUrl+"v2/appointment/sessions/public/calendarByDistrict?district_id=$distID&date=$date");
    var response = await http.get(url);
    print(response.body);
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _future,
          builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return CircularProgressIndicator();
            }
            else return Container();
          }
      ),
    );
  }
}
