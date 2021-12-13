import 'package:arrival/pages/join_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:arrival/states/app_state.dart';

import 'package:arrival/constants.dart';

import 'package:arrival/widgets/essentials.dart';

import 'package:arrival/models/hicards_icons.dart';

import 'package:arrival/pages/create_page.dart';

import 'package:decorated_icon/decorated_icon.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => new _HomePage();
}

class _HomePage extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
        builder: (context, state, child) {
          return WillPopScope(
            onWillPop: () async {
              if (state.index != 0) {
                state.setPage = 0;
                return false;
              }
              return true;
            },
            child: Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              resizeToAvoidBottomInset: false,
              body: Stack(
                children: [
                  Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        Text('PullUp', style: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.w600, fontSize: 55),),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 50,),
                            Expanded(
                              child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(45),
                                      gradient: LinearGradient(
                                          colors: [
                                            appColors['gradients'][0][1],
                                            appColors['gradients'][0][0],
                                          ],
                                          begin: Alignment.bottomRight,
                                          end: Alignment.topLeft,
                                          stops: [0, 1],
                                          tileMode: TileMode.clamp
                                      )
                                  ),
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: HiCardsInkWell(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => JoinPage()));
                                      },
                                      color: Colors.white.withOpacity(.3),
                                      borderRadius: BorderRadius.circular(45),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 40, right: 40),
                                        child: Center(
                                            child: Text(
                                                "Rejoindre un Salon",
                                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)
                                            )
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                            ),
                            SizedBox(width: 50,),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Container(
                          height: 40,
                          child: Row(
                            children: [
                              Spacer(),
                              Expanded(
                                  flex: 2,
                                  child: Divider(height: 1, thickness: 1, color: Theme.of(context).scaffoldBackgroundColor,)
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text("OU", style: TextStyle(color: Theme.of(context).hintColor, fontSize: 16),),
                              ),
                              Expanded(
                                flex: 2,
                                child: Divider(height: 1, thickness: 1, color: Theme.of(context).scaffoldBackgroundColor,),
                              ),
                              Spacer()
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 50,),
                            Expanded(
                              child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(45),
                                      gradient: LinearGradient(
                                          colors: [
                                            appColors['gradients'][0][1],
                                            appColors['gradients'][0][0],
                                          ],
                                          begin: Alignment.bottomRight,
                                          end: Alignment.topLeft,
                                          stops: [0, 1],
                                          tileMode: TileMode.clamp
                                      )
                                  ),
                                  padding: EdgeInsets.all(1),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(45),
                                        color: Theme.of(context).backgroundColor
                                    ),
                                    child: Material(
                                      type: MaterialType.transparency,
                                      child: HiCardsInkWell(
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePage()));
                                        },
                                        color: appColors['gradients'][0][0].withOpacity(.1),
                                        borderRadius: BorderRadius.circular(45),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 39, right: 39),
                                          child: Center(
                                              child: ShaderMask(
                                                shaderCallback: (bounds) {
                                                  return LinearGradient(
                                                      colors: [
                                                        appColors['gradients'][0][1],
                                                        appColors['gradients'][0][0],
                                                      ],
                                                      begin: Alignment.bottomRight,
                                                      end: Alignment.topLeft,
                                                      stops: [0, 1],
                                                      tileMode: TileMode.clamp
                                                  ).createShader(Offset.zero & bounds.size);
                                                },
                                                child: Text(
                                                  "Créer un Salon",
                                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                                                ),
                                              )
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                            ),
                            SizedBox(width: 50,),
                          ],
                        ),
                        Spacer(),
                        Text('Créé par Léo Féliers', style: TextStyle(color: Theme.of(context).hintColor),),
                        SizedBox(height: 25),
                      ],
                    ),
                  ),
                  Positioned.fill(
                      child: IgnorePointer(
                        ignoring: true,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  appColors['gradients'][0][1].withOpacity(.2),
                                ],
                                begin: Alignment.bottomRight,
                                end: Alignment.topLeft,
                                stops: [0.5, 1],
                                tileMode: TileMode.clamp
                            ),
                          ),
                        ),
                      )
                  )
                ],
              ),
            ),
          );
        }
    );
  }

}