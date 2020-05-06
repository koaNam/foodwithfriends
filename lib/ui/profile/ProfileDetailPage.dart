import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProfileDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Card(
                margin: EdgeInsets.only(left: 10, right: 10, top: 15),
                child: Padding(
                  padding: EdgeInsets.only(left: 15, top: 15, bottom: 15),
                  child: Text(
                      "Max Mustername",
                      style: TextStyle(
                        fontSize: 18
                      ),
                  ),
                )
            ),
            Card(
                margin: EdgeInsets.only(left: 10, right: 10, top: 15),
                child: Padding(
                  padding: EdgeInsets.only(left: 15, top: 15, bottom: 15),
                  child: Text(
                    "09.12.1998",
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),
                )
            ),
            Card(
              margin: EdgeInsets.only(left: 10, right: 10, top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 15, top: 15),
                    child: Text(
                      "Altersgruppe:",
                      style: TextStyle(
                        fontSize: 18
                      ),
                    ),
                  ),
                  RangeSlider(
                    values: RangeValues(0, 25),
                    onChanged: (v) => print(v),
                    min: 0,
                    max: 25,
                  )
                ],
              )
            ),
            Card(
                margin: EdgeInsets.only(left: 10, right: 10, top: 15),
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Küche vorhanden:",
                        style: TextStyle(
                            fontSize: 18
                        ),
                      ),
                      Switch(
                        value: false,
                      )
                    ],
                  ),
                )
            ),
            Card(
                margin: EdgeInsets.only(left: 10, right: 10, top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 15, top: 15),
                      child: Text(
                        "Deine Kochkünste:",
                        style: TextStyle(
                            fontSize: 18
                        ),
                      ),
                    ),
                    Center(
                      child: RatingBar(
                        initialRating: 3,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 25,
                            right: MediaQuery.of(context).size.width / 25,
                            bottom: 15
                        ),
                        itemBuilder: (context, _) =>
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                    )
                  ],
                )
            ),
            Card(
                margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 15, top: 15),
                      child: Text(
                        "Abweichung:",
                        style: TextStyle(
                            fontSize: 18
                        ),
                      ),
                    ),
                    RangeSlider(
                      values: RangeValues(0, 5),
                      onChanged: (v) => print(v),
                      min: 0,
                      max: 5,
                    )
                  ],
                )
            ),
            Card(
                margin: EdgeInsets.only(left: 10, right: 10, top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 15, top: 15),
                      child: Text(
                        "Anzahl der Teilnehmer:",
                        style: TextStyle(
                            fontSize: 18
                        ),
                      ),
                    ),
                    Slider.adaptive(
                      value: 0,
                      onChanged: (v) => print(v),
                      min: 0,
                      max: 10,
                    ),
                  ],
                )
            ),
          ],
        )
      )
    );
  }
}
