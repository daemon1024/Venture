import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:venture/place_page.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;

void main() => runApp(
      MyApp(),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vacation App',
      theme: ThemeData(
        accentColor: Colors.black12,
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    this.getData1();
    this.getData2();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  var converted1;
  Future<List> getData1() async {
    var response = await http.get("http://34.69.125.21:8081/lakshadweep");
    var data = json.decode(response.body);

    setState(() {
      converted1 = data;
    });

    return ["Success"];
  }

  var converted2;
  Future<List> getData2() async {
    var response = await http.get("http://34.69.125.21:8081/langkawi");
    var data = json.decode(response.body);

    setState(() {
      converted2 = data;
    });

    return ["Success"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Padding(
        padding: MediaQuery.of(context).padding,
        child: Container(
          padding: EdgeInsets.only(left: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          'Your next trip',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: mainTitleSize,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                      ),
                      Center(
                        child: Column(
                          children: <Widget>[
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: converted1 == null || converted2 == null
                                  ? Container()
                                  : Row(
                                      children: <Widget>[
                                        PlaceCard(
                                          name: 'Ocean',
                                          img: 'assets/images/ocean_1.jpg',
                                          country: converted1[0]["country"],
                                          title: converted1[0]["place"],
                                          facts: converted1,
                                        ),
                                        PlaceCard(
                                          name: 'Rain',
                                          img: 'assets/images/rain_1.jpg',
                                          country: converted2[0]["country"],
                                          title: converted2[0]["place"],
                                          facts: converted2,
                                        ),
                                        PlaceCard(
                                          name: 'Sunset',
                                          img: 'assets/images/sunset_1.jpg',
                                          country: converted1[0]["country"],
                                          title: converted1[0]["place"],
                                          facts: converted1,
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlaceCard extends StatefulWidget {
  final String name, img, country, title;
  final facts;

  PlaceCard({
    this.title,
    this.name,
    this.img,
    this.country,
    this.facts,
  });

  @override
  _PlaceCardState createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayRoute(
              sound: this.widget.name.toLowerCase(),
              facts: this.widget.facts,
            ),
          ),
        );
      },
      child: Container(
        height: 350.0,
        width: 300.0,
        padding: EdgeInsets.fromLTRB(15, 15, 15, 35),
        margin: EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(image: AssetImage(widget.img), fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.title,
                    style:
                        TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    widget.country,
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
