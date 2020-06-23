
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:foodwithfriends/AppTheme.dart';
import 'package:foodwithfriends/bloc/ChatBloc.dart';
import 'package:foodwithfriends/service/graphql/graphql_constants.dart';

import 'Home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    precacheImage(AssetImage('assets/start_screen.png'), context);
    precacheImage(AssetImage('assets/herbs.png'), context);
    return MultiProvider(
      providers: [
        Provider<ChatBloc>(
          create: (_) => ChatBloc(),
          dispose: (_, ChatBloc bloc) => bloc.dispose(),
        )
      ],
      child: new MaterialApp
        (
        title: 'FoodWithFriends',
        home: new Home(),
        color: Colors.white,
        supportedLocales: [
          const Locale('de', "DE"),
        ],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
        ],
        theme: ThemeData(
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: AppTheme.MAIN_COLOR
          ),
        ),
      )
    );
  }
}
