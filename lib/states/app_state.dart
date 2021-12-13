import 'package:arrival/models/music.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:arrival/pages/session_page.dart';

import 'dart:io';
import 'dart:math';

import 'package:arrival/models/session.dart';

class AppState extends ChangeNotifier{
 
  bool isBusy = false;
  bool isAuthor = false;
  int index = 0;

  List<String> likedMusicIds = [];

  late Session? currentSession;

  set setPage(int i){
    index = i;
    notifyListeners();
  }

  Future<void> createSession({String? name, File? image}) async {

    likedMusicIds = [];

    isAuthor = true;

    String id = "";

    while (id == "") {
      String _id = generateId();
      if (!(await FirebaseFirestore.instance.collection("sessions").doc(_id).get()).exists) {
        id = _id;
      }
    }

    currentSession = Session(
        name: name,
        code: id,
        admin: "",
        photoUrl: ''
    );

    notifyListeners();

    FirebaseFirestore.instance.collection("sessions").doc(id).set(currentSession!.toJSON());

  }


  Future<void> joinSession(BuildContext context, String code) async {

    likedMusicIds = [];

    isAuthor = false;

    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection("sessions").doc(code).get();

    if (snapshot.exists) {
      currentSession = Session(
          name: snapshot.data()?['name'],
          code: code,
          admin: snapshot.data()?['admin'],
          photoUrl: snapshot.data()?['photoUrl']
      );

      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return SessionPage();
          }
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 3,
            content: Text("Cette session n'existe pas.", style: TextStyle(color: Theme.of(context).backgroundColor),),
            backgroundColor: Theme.of(context).indicatorColor,
          )
      );
    }

    notifyListeners();

  }

  Future<void> likeMusic(Music music) async {
    if (currentSession == null) return;
    if (likedMusicIds.contains(music.id.toString())) return;
    likedMusicIds.add(music.id.toString());
    music.likeCount += 1;
    notifyListeners();
    FirebaseFirestore.instance.collection("musics").doc(
        (currentSession!.code ?? '') + '-' + (music.id.toString())
    ).set(music.toJSON(), SetOptions(merge : true));
  }

  Future<void> unLikeMusic(Music music) async {
    if (currentSession == null) return;
    if (!likedMusicIds.contains(music.id.toString())) return;
    likedMusicIds.remove(music.id.toString());
    music.likeCount -= 1;
    notifyListeners();
    if (music.likeCount == 0) {
      FirebaseFirestore.instance.collection("musics").doc(
          (currentSession!.code ?? '') + '-' + (music.id.toString())
      ).delete();
    } else {
      FirebaseFirestore.instance.collection("musics").doc(
          (currentSession!.code ?? '') + '-' + (music.id.toString())
      ).set(music.toJSON(), SetOptions(merge : true));
    }
  }

}

String generateId() {
  String id = '';
  String lib = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  for (int i = 0; i < 4; i++) {
    id += lib[Random().nextInt(lib.length)];
  }
  return id;
}