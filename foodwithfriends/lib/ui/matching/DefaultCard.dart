import 'package:flutter/material.dart';

class DefaultCard extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    return new Card(
        child: SizedBox.expand(
          child: new Material(
            borderRadius: new BorderRadius.circular(12.0),
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: MediaQuery.of(context).size.height * 0.25
              ),
              child: Text(
                "Im Moment haben wir leider niemanden Neuen für dich.\n"
                    "Füge weitere Eigenschaften zu dir hinzu oder passe deine Sucheinstellungen im Profil an.",
                style: TextStyle(
                  fontSize: 15,
                  height: 2,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ),
        ),
    );
  }

}