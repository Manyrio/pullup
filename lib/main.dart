import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';

import 'pages/home_page.dart';

import 'constants.dart';

import 'states/app_state.dart';

import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp,DeviceOrientation.portraitDown])
      .then((_) {
    runApp(
      MyApp(),
    );
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),
      ],
      child: MaterialApp(
        theme: ThemeData(
            fontFamily: 'ProximaNova',
            primarySwatch: Colors.grey,
            primaryColor: HexColor("F050AE"),
            brightness: Brightness.light,
            scaffoldBackgroundColor: HexColor('282828'),
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
            shadowColor: Colors.black.withOpacity(.8),
            appBarTheme: AppBarTheme(
                color: HexColor('f2f3f8'),
                iconTheme: IconThemeData(
                    color: HexColor('787079')
                ),
                actionsIconTheme: IconThemeData(
                    color: Colors.black
                ),
                textTheme: TextTheme(
                  headline1: TextStyle(color: HexColor('787079')),
                )
            ),
            hintColor: HexColor('5a5a5a'),
            cardColor: HexColor('#efecef'),
            unselectedWidgetColor: HexColor('433c43'),
            backgroundColor: HexColor("121212"),
            accentColor: Colors.white,
            inputDecorationTheme: InputDecorationTheme(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: HexColor('282828'), width: 1.0),
              ),
            ),
            accentIconTheme: IconThemeData(color: Colors.white),
            indicatorColor: HexColor('675f67'),
            dividerColor: HexColor('dfd9e0'),
            iconTheme: IconThemeData(color: Colors.black87)
        ),
        debugShowCheckedModeBanner: false,
        title: 'HiCards',
        color: Colors.white,
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(),
        },
      )
    );
  }
}