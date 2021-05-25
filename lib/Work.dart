import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:cowin_web_alert/const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class Working extends StatefulWidget {
  final distId,age,dose;
  Working(this.distId,this.age,this.dose);
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
    Timer.periodic(Duration(seconds: 4), (timer) {
      setState(() {
        _future = getSlots(widget.distId);
      });
    });
  }
  getSlots(var distID) async {
    String date = DateFormat('dd-MM-yyyy').format(DateTime.now());
    var url = Uri.parse(baseUrl+"v2/appointment/sessions/public/calendarByDistrict?district_id=$distID&date=$date");
    var response = await http.get(url);
    return jsonDecode(response.body);
  }
  playLocal() async {
    AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
    int result = await audioPlayer.play("sounds/siren.mp3", isLocal: true);
  }



  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: FutureBuilder(
        future: _future,
          builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.connectionState==ConnectionState.none){
              return Center(child: CircularProgressIndicator());
            }
            else if(snapshot.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }
            else if(widget.dose==1&&widget.age==18)  {
              for(int i=0;i<snapshot.data['centers'].length;i++){
                for(int j=0;j<snapshot.data['centers'][i]['sessions'].length;j++){
                  if(snapshot.data['centers'][i]['sessions'][j]['min_age_limit']==18&&
                      snapshot.data['centers'][i]['sessions'][j]['available_capacity_dose1']!=0){
                    playLocal();

                    return Container(
                     child: ListView(
                       children: [
                         Container(
                           child: Center(
                             child: Column(
                               children: [
                                 Text("Centre Name : "+snapshot.data['centers'][i]['name']),
                                 SizedBox(height:height*.02,),
                                 Text("Pin Code : "+snapshot.data['centers'][i]['pincode'].toString()),
                                 SizedBox(height:height*.02,),
                                 Text("Available Doses : "+
                                     snapshot.data['centers'][i]['sessions'][j]['available_capacity_dose1'].toString()),
                               ],
                             ),
                           ),
                         )
                       ],
                     ),
                    );
                  }
                }
              }
            }
            else if(widget.dose==1&&widget.age==45) {
              for(int i=0;i<snapshot.data['centers'].length;i++){
                for(int j=0;j<snapshot.data['centers'][i]['sessions'].length;j++){
                  if(snapshot.data['centers'][i]['sessions'][j]['min_age_limit']==45&&
                      snapshot.data['centers'][i]['sessions'][j]['available_capacity_dose1']!=0){
                    playLocal();
                    return Container(
                      child: ListView(
                        children: [
                          Container(
                            child: Center(
                              child: Column(
                                children: [
                                  Text("Centre Name : "+snapshot.data['centers'][i]['name']),
                                  SizedBox(height:height*.02,),
                                  Text("Pin Code : "+snapshot.data['centers'][i]['pincode'].toString()),
                                  SizedBox(height:height*.02,),
                                  Text("Available Doses : "+
                                      snapshot.data['centers'][i]['sessions'][j]['available_capacity_dose1'].toString()),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                }
              }
            }
            else if(widget.dose==2&&widget.age==18) {
              for(int i=0;i<snapshot.data['centers'].length;i++){
                for(int j=0;j<snapshot.data['centers'][i]['sessions'].length;j++){
                  if(snapshot.data['centers'][i]['sessions'][j]['min_age_limit']==18&&
                      snapshot.data['centers'][i]['sessions'][j]['available_capacity_dose2']!=0){
                    playLocal();

                    return Container(
                      child: ListView(
                        children: [
                          Container(
                            child: Center(
                              child: Column(

                                children: [
                                  Text("Centre Name : "+snapshot.data['centers'][i]['name']),
                                  SizedBox(height:height*.02,),
                                  Text("Pin Code : "+snapshot.data['centers'][i]['pincode'].toString()),
                                  SizedBox(height:height*.02,),
                                  Text("Available Doses : "+
                                      snapshot.data['centers'][i]['sessions'][j]['available_capacity_dose2'].toString()),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                }
              }
            }
            else if(widget.dose==2&&widget.age==45) {
              for(int i=0;i<snapshot.data['centers'].length;i++){
                for(int j=0;j<snapshot.data['centers'][i]['sessions'].length;j++){
                  if(snapshot.data['centers'][i]['sessions'][j]['min_age_limit']==45&&
                      snapshot.data['centers'][i]['sessions'][j]['available_capacity_dose2']!=0){
                    playLocal();

                    return Container(
                      child: Center(
                        child: ListView(
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Text("Centre Name : "+snapshot.data['centers'][i]['name']),
                                  SizedBox(height:height*.02,),
                                  Text("Pin Code : "+snapshot.data['centers'][i]['pincode'].toString()),
                                  SizedBox(height:height*.02,),
                                  Text("Available Doses : "+
                                      snapshot.data['centers'][i]['sessions'][j]['available_capacity_dose2'].toString()),
                                  SizedBox(height:height*.08,),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                }
              }
            }
            return Center(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height:height*.02,),
                    Text("Please Wait Searching"),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}
