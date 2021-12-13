import 'dart:developer';

import 'package:arrival/models/music.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:arrival/states/app_state.dart';

import 'package:arrival/constants.dart';

import 'package:arrival/widgets/essentials.dart';

import 'package:arrival/models/hicards_icons.dart';
import 'package:decorated_icon/decorated_icon.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'dart:async';
import 'dart:io';
import 'dart:convert';

Future<dynamic> getRequest(String url) async {
  final response = await http.get(
    Uri.parse(url),
  );
  // print(response.body);
  final responseJson = await compute(jsonDecode, response.body);

  return responseJson;
}

class SessionPage extends StatefulWidget {
  @override
  _SessionPage createState() => new _SessionPage();
}

class _SessionPage extends State<SessionPage> {

  List<Music> results = [];

  TextEditingController controller = TextEditingController();

  void search(AppState state) async {
    List<Music> _results = [];

    var responseJson = await getRequest('https://api.deezer.com/search?q=${controller.text}');

    print(responseJson.toString());

    responseJson['data'].forEach(
        (responseMusic) {
          _results.add(
            Music(
              sessionCode: state.currentSession!.code ?? "-",
              title: responseMusic['title'],
              artist: responseMusic['artist']['name'],
              duration: responseMusic['duration'],
              id: responseMusic['id'],
              pictureSmall: responseMusic['artist']['picture_small'] ?? '',
              picture: responseMusic['artist']['picture'] ?? '',
            )
          );
        }
    );

    results = _results;
    setState(() {});
  }

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
            child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('musics').where('sessionCode', isEqualTo: state.currentSession!.code).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
                  if (!snap.hasData) return Scaffold(
                    extendBodyBehindAppBar: true,
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      elevation: 0,
                      titleSpacing: 10,
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
                                  onTap: controller.text.isNotEmpty ? () {
                                    controller.clear();
                                    results = [];
                                    setState(() {});
                                  } : (){
                                    Navigator.pop(context);
                                  },
                                  child: Center(
                                      child: DecoratedIcon(
                                        controller.text.isNotEmpty ? HiCards.close_line : HiCards.arrow_left_s_line,
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
                          SizedBox(width: 10,),
                          Expanded(
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.05),
                                  borderRadius: BorderRadius.circular(7)
                              ),
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      textAlign: TextAlign.left,
                                      onChanged: (t) {
                                        if (t.isEmpty) return;
                                        search(state);
                                      },
                                      controller: controller,
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Theme.of(context).accentColor),
                                      decoration: InputDecoration.collapsed(
                                          border: InputBorder.none,
                                          hintText: "Rechercher une musique ...",
                                          hintStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18
                                          )
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 45, width: 30,
                                    child: Center(
                                        child: DecoratedIcon(
                                          HiCards.search_line,
                                          color: Theme.of(context).accentColor.withOpacity(.3),
                                          size: 18.0,
                                          shadows: [
                                            BoxShadow(
                                                color: Colors.black.withOpacity(.8),
                                                offset: Offset(0.0, 0.0),
                                                blurRadius: 8.0,
                                                spreadRadius: 0
                                            )
                                          ],
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                        ],
                      ),
                    ),
                    bottomNavigationBar: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(.3)),
                          minHeight: 1,
                        ),
                        Container(
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7),
                                topRight: Radius.circular(7)
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(.15),
                                  offset: Offset(0.0, 0.0),
                                  blurRadius: 8.0,
                                  spreadRadius: 0
                              )
                            ],
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 55,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        'CODE',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: Theme.of(context).hintColor
                                        )
                                    ),
                                    Text(
                                        state.currentSession!.code.toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).accentColor.withOpacity(.6)
                                        )
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: Container()
                              ),
                              Container(
                                height: 55, width: 55,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  // color: Colors.black.withOpacity(.3),
                                ),
                                child: Material(
                                  type: MaterialType.transparency,
                                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                  child: HiCardsInkWell(
                                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                      onTap: (){
                                      },
                                      child: Center(
                                          child: DecoratedIcon(
                                            HiCards.more_line,
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
                            ],
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Theme.of(context).backgroundColor,
                    resizeToAvoidBottomInset: false,
                    body: Container(
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
                    ),
                  );

                return Scaffold(
                  extendBodyBehindAppBar: true,
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    titleSpacing: 10,
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
                                onTap: controller.text.isNotEmpty ? () {
                                  controller.clear();
                                  results = [];
                                  setState(() {});
                                } : (){
                                  if (state.isAuthor) {
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                          title: const Text('Supprimer la session', style: TextStyle(color: Colors.white)),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: <Widget>[
                                                Text("Tu es le créateur de cette session.", style: TextStyle(color: Colors.white.withOpacity(.7))),
                                                Text('Sûr de vouloir la supprimer ?', style: TextStyle(color: Colors.white.withOpacity(.7))),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Supprimer', style: TextStyle(color: Colors.white),),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                FirebaseFirestore.instance.collection('sessions').doc(state.currentSession!.code).delete();
                                                state.currentSession = null;
                                                state.notifyListeners();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {

                                  }
                                },
                                child: Center(
                                    child: DecoratedIcon(
                                      controller.text.isNotEmpty ? HiCards.close_line : HiCards.arrow_left_s_line,
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
                        SizedBox(width: 10,),
                        Expanded(
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.05),
                                borderRadius: BorderRadius.circular(7)
                            ),
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    textAlign: TextAlign.left,
                                    onChanged: (t) {
                                      if (t.isEmpty) return;
                                      search(state);
                                    },
                                    controller: controller,
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
                                    decoration: InputDecoration.collapsed(
                                        border: InputBorder.none,
                                        hintText: "Rechercher une musique ...",
                                        hintStyle: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white.withOpacity(.7),
                                            fontSize: 18
                                        )
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 45, width: 30,
                                  child: Center(
                                      child: DecoratedIcon(
                                        HiCards.search_line,
                                        color: Colors.white.withOpacity(.7),
                                        size: 18.0,
                                        shadows: [
                                          BoxShadow(
                                              color: Colors.black.withOpacity(.8),
                                              offset: Offset(0.0, 0.0),
                                              blurRadius: 8.0,
                                              spreadRadius: 0
                                          )
                                        ],
                                      )
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                      ],
                    ),
                  ),
                  extendBody: true,
                  bottomNavigationBar: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      state.isAuthor ? Container(
                          padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
                          decoration: BoxDecoration(color:
                          Theme.of(context).backgroundColor,
                          ),
                          child: Text(
                              "Vous êtes l'auteur de cette session, pour supprimer une musique, appuyez longuement dessus.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white.withOpacity(.7))
                          )
                      ) : Container(),
                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(7),
                              topRight: Radius.circular(7)
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.15),
                                offset: Offset(0.0, 0.0),
                                blurRadius: 8.0,
                                spreadRadius: 0
                            )
                          ],
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 55,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      'CODE',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Theme.of(context).hintColor
                                      )
                                  ),
                                  Text(
                                      state.currentSession!.code.toString(),
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).accentColor.withOpacity(.6)
                                      )
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      "${(snap.data?.docs.length ?? 0)} Musiques proposées",
                                      style: TextStyle(color: Colors.white.withOpacity(.3)),
                                    ),
                                  ),
                                )
                            ),
                            Container(
                              height: 55, width: 55,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                // color: Colors.black.withOpacity(.3),
                              ),
                              child: Material(
                                type: MaterialType.transparency,
                                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                child: HiCardsInkWell(
                                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                    onTap: (){
                                    },
                                    child: Center(
                                        child: DecoratedIcon(
                                          HiCards.more_line,
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
                          ],
                        ),
                      ),
                    ],
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
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 55,
                        left: 0, right: 0, bottom: 0,
                        child: controller.text.isEmpty ? ((snap.data?.docs.length ?? 0) == 0 ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 20, top: 15, bottom: 15),
                              child: Text(
                                'Propositions',
                                style: TextStyle(color: Colors.white.withOpacity(.25), fontWeight: FontWeight.w600, fontSize: 36),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20,),
                              child: Text(
                                "Il n'y a pas encore de propositions de musiques, recherche ta musique préférée et like la !",
                                style: TextStyle(color: Colors.white.withOpacity(.45), fontSize: 14),
                              ),
                            )
                          ],
                        ) : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: (snap.data?.docs.length ?? 0) + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) return Padding(
                              padding: EdgeInsets.only(left: 20, top: 15, bottom: 15),
                              child: Text(
                                'Propositions',
                                style: TextStyle(color: Colors.white.withOpacity(.25), fontWeight: FontWeight.w600, fontSize: 36),
                              ),
                            );
                            return MusicTile(
                              Music.fromJSON(snap.data?.docs.elementAt(index-1).data() ?? {}), state, key: Key(snap.data?.docs.elementAt(index-1).id.toString() ?? ""),
                            );
                          },
                        )) : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            return MusicTile(
                              results[index], state, key: Key(results[index].id.toString()),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                );
              }
            ),
          );
        }
    );
  }

}

class MusicTile extends StatefulWidget {
  Music music;
  AppState state;
  MusicTile(this.music, this.state, {Key? key}) : super(key: key);
  @override
  _MusicTile createState() => new _MusicTile();
}

class _MusicTile extends State<MusicTile> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Material(
        type: MaterialType.transparency,
        child: HiCardsInkWell(
          onTap: (){},
          onLongPress: (){
            if (widget.state.isAuthor) {
              FirebaseFirestore.instance.collection("musics").doc((widget.state.currentSession!.code ?? '') + '-' + (widget.music.id.toString())).delete();

              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    elevation: 3,
                    action: SnackBarAction(label: "Annuler", onPressed: () {
                      widget.state.likeMusic(widget.music);
                    }),
                    content: Text("Musique supprimée.", style: TextStyle(color: Theme.of(context).backgroundColor),),
                    backgroundColor: Theme.of(context).indicatorColor,
                  )
              );
            }
          },
          color: Colors.white.withOpacity(.1),
          child: Row(
            children: [
              SizedBox(width: 15,),
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(7)
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Image.network(
                      widget.music.pictureSmall
                  ),
                ),
              ),
              SizedBox(width: 15,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.music.title,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).accentColor
                      ),
                      maxLines: 1, overflow: TextOverflow.clip,
                      softWrap: false,
                    ),
                    Text(
                      widget.music.artist,
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).hintColor
                      ),
                      maxLines: 1, overflow: TextOverflow.clip,
                      softWrap: false,
                    )
                  ],
                ),
              ),
              Container(
                height: 55, width: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // color: Colors.black.withOpacity(.3),
                ),
                child: Material(
                  type: MaterialType.transparency,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  child: HiCardsInkWell(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      onTap: (){
                        if (widget.state.likedMusicIds.contains(widget.music.id.toString())) {
                          widget.state.unLikeMusic(widget.music);
                        } else {
                          widget.state.likeMusic(widget.music);
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DecoratedIcon(
                            widget.state.likedMusicIds.contains(widget.music.id.toString()) ? HiCards.heart_fill : HiCards.heart_line,
                            color: widget.state.likedMusicIds.contains(widget.music.id.toString()) ? Colors.white.withOpacity(.7) : Theme.of(context).hintColor,
                            size: 22.0,
                            shadows: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(.8),
                                  offset: Offset(0.0, 0.0),
                                  blurRadius: 8.0,
                                  spreadRadius: 0
                              )
                            ],
                          ),
                          (widget.music.likeCount > 0) ? Padding(
                            padding: const EdgeInsets.only(top:2),
                            child: Text(
                              widget.music.likeCount.toString(),
                              style: TextStyle(color: Colors.white.withOpacity(.4), fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                          ) : Container()
                        ],
                      )
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