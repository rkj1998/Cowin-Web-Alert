import 'dart:convert';
import 'package:cowin_web_alert/Work.dart';
import 'package:cowin_web_alert/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String dropdown = "Select State";
  String dropdown2 = "Select District";
  String dropdown3 = "Select Age Category";
  String dropdown4 = "Select Dose";
  var ageCat = ["Select Age Category","18+","45+"];
  var dose = ["Select Dose","1st","2nd"];
  Map distMap = Map();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width  = MediaQuery.of(context).size.width;

    getStates() async {
      var url = Uri.parse(baseUrl+"v2/admin/location/states");
      var response = await http.get(url);
      return jsonDecode(response.body);
    }
    getDistricts(int stateID) async {
      var url = Uri.parse(baseUrl+"v2/admin/location/districts/"+stateID.toString());
      var response = await http.get(url);
      return jsonDecode(response.body);
    }

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
            'Enter Details'
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20,right: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment:MainAxisAlignment.start,
            children: [
              Image.asset("images/CoWin.png"),
              FutureBuilder(
                future: getStates(),
                builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return CircularProgressIndicator();
                  }
                  var list=[];
                  list.add("Select State");
                  Map map = Map();
                  for(int i=0;i<snapshot.data["states"].length;i++){
                    list.add(snapshot.data["states"][i]["state_name"]);
                    map[snapshot.data["states"][i]["state_name"]] = snapshot.data["states"][i]["state_id"];
                  }

                  return Container(

                      child: Column(
                        children: [
                          Container(
                            height: height*.07,
                            decoration: new BoxDecoration(
                              color:  Colors.white,
                              borderRadius: new BorderRadius.circular(40.0),
                              border:Border.all(width: .2,color: Colors.grey.withOpacity(.6)),
                              boxShadow: <BoxShadow>[
                                new BoxShadow(
                                  color: Colors.grey.withOpacity(1),
                                  blurRadius: 15.0,
                                  spreadRadius: -5.5,
                                ),
                              ],
                            ),
                            margin: EdgeInsets.only(top: 8),
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            alignment: Alignment.center,
                            child: DropdownButton(
                                underline: SizedBox(),
                                isExpanded: true,
                                value: dropdown,
                                items: List.generate(list.length, (j) {
                                  return DropdownMenuItem(
                                      value: list[j],
                                      child: Text(
                                        list[j],
                                        style: TextStyle(fontSize: 13),
                                      ));
                                }),
                                onChanged: (c)  {
                                  setState(() {
                                    dropdown=c.toString();
                                    dropdown2="Select District";
                                  });
                                }),
                          ),
                          SizedBox(height:height*.02,),
                          dropdown!="Select State"?
                          FutureBuilder(
                            future: getDistricts(map[dropdown]),
                            builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){
                              if(snapshot.connectionState==ConnectionState.waiting){
                                return CircularProgressIndicator();
                              }
                              var distList = [];
                              distList.add("Select District");
                              for(int i=0;i<snapshot.data["districts"].length;i++){
                                distList.add(snapshot.data["districts"][i]["district_name"]);
                                distMap[snapshot.data["districts"][i]["district_name"]] = snapshot.data["districts"][i]["district_id"];
                              }
                              return Container(
                                child:Container(
                                  height: height*.07,
                                  decoration: new BoxDecoration(
                                    color:  Colors.white,
                                    borderRadius: new BorderRadius.circular(40.0),
                                    border:Border.all(width: .2,color: Colors.grey.withOpacity(.6)),
                                    boxShadow: <BoxShadow>[
                                      new BoxShadow(
                                        color: Colors.grey.withOpacity(1),
                                        blurRadius: 15.0,
                                        spreadRadius: -5.5,
                                      ),
                                    ],
                                  ),
                                  margin: EdgeInsets.only(top: 8),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 5),
                                  alignment: Alignment.center,
                                  child: DropdownButton(
                                      underline: SizedBox(),
                                      isExpanded: true,
                                      value: dropdown2,
                                      items: List.generate(distList.length, (j) {
                                        return DropdownMenuItem(
                                            value: distList[j],
                                            child: Text(
                                              distList[j],
                                              style: TextStyle(fontSize: 13),
                                            ));
                                      }),
                                      onChanged: (c)  {
                                        setState(() {
                                          dropdown2=c.toString();
                                        });
                                      }),
                                ),

                              );

                            },
                          ):Container()
                        ],
                      )

                  );
                },
              ),
              SizedBox(height: height*.02,),
              dropdown2!="Select District"?
              Container(
                height: height*.07,
                decoration: new BoxDecoration(
                  color:  Colors.white,
                  borderRadius: new BorderRadius.circular(40.0),
                  border:Border.all(width: .2,color: Colors.grey.withOpacity(.6)),
                  boxShadow: <BoxShadow>[
                    new BoxShadow(
                      color: Colors.grey.withOpacity(1),
                      blurRadius: 15.0,
                      spreadRadius: -5.5,
                    ),
                  ],
                ),
                margin: EdgeInsets.only(top: 8),
                padding: EdgeInsets.symmetric(
                    horizontal: 25, vertical: 5),
                alignment: Alignment.center,
                child: DropdownButton(
                    underline: SizedBox(),
                    isExpanded: true,
                    value: dropdown3,
                    items: List.generate(ageCat.length, (j) {
                      return DropdownMenuItem(
                          value: ageCat[j],
                          child: Text(
                            ageCat[j],
                            style: TextStyle(fontSize: 13),
                          ));
                    }),
                    onChanged: (c)  {
                      setState(() {
                        dropdown3=c.toString();
                      });
                    }),
              ):Container(),
              dropdown3!="Select Age Category"?
              Container(

              ):Container(),

              dropdown!="Select State"&&dropdown2!="Select District"?
              Container(
                width: width * 0.9,
                height: height*.07,
                margin: EdgeInsets.only(top: 8),
                decoration: new BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: new BorderRadius.circular(40.0),
                  border:Border.all(width: .2,color: Colors.grey.withOpacity(.6)),
                  boxShadow: <BoxShadow>[
                    new BoxShadow(
                      color: Colors.grey.withOpacity(1),
                      blurRadius: 15.0,
                      spreadRadius: -5.5,
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Working(
                          distMap[dropdown2])));
                  },
                  child: Text(
                    "Start",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ):Container()

            ],
          ),
        ),
      ),
    );
  }
}








