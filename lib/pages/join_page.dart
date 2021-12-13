import 'package:arrival/pages/session_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:arrival/states/app_state.dart';

import 'package:arrival/constants.dart';

import 'package:arrival/widgets/essentials.dart';

import 'package:arrival/models/hicards_icons.dart';
import 'package:decorated_icon/decorated_icon.dart';

class JoinPage extends StatefulWidget {
  @override
  _JoinPage createState() => new _JoinPage();
}

class _JoinPage extends State<JoinPage> {

  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController controller = TextEditingController();

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
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                titleSpacing: 15,
                shadowColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                title: Row(
                  children: [
                    Container(
                      height: 45, width: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // color: Colors.black.withOpacity(.3),
                      ),
                      child: Material(
                        type: MaterialType.transparency,
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        child: HiCardsInkWell(
                            borderRadius: BorderRadius.all(Radius.circular(25.0)),
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Center(
                                child: DecoratedIcon(
                                  HiCards.arrow_left_s_line,
                                  color: Theme.of(context).accentColor,
                                  size: 22.0,
                                  shadows: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(.8),
                                        offset: Offset(0.0, 0.0),
                                        blurRadius: 8.0,
                                        spreadRadius: 0
                                    )
                                  ],
                                )
                            )
                        ),
                      ),
                    ),
                    SizedBox(width: 15,),
                    Text('Rejoindre le Salon', style: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.w600),)
                  ],
                ),
              ),
              backgroundColor: Theme.of(context).backgroundColor,
              resizeToAvoidBottomInset: false,
              body: Stack(
                children: [
                  Positioned.fill(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
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
                      )
                  ),
                  Positioned.fill(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(flex: 3,),
                          Padding(
                            padding: const EdgeInsets.only(left: 50, right: 50, bottom: 50),
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: controller,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Theme.of(context).accentColor),
                              decoration: InputDecoration(
                                hintText: "Code du Salon",
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18
                                )
                              ),
                            ),
                          ),
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
                                          onTap: () async {
                                            formKey.currentState?.validate();
                                            await state.joinSession(
                                              context,
                                              controller.text
                                            );
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
                                                    "Rejoindre le Salon",
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
                          Spacer(flex: 2,),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
    );
  }

}