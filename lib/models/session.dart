import 'music.dart';

class Session {

  String? name;
  String? photoUrl;

  List<Music>? musics;

  String? admin;

  String? code;

  Map<String, dynamic> toJSON() {
    return {
      'name': name,
      'photoUrl': photoUrl,
      'code': code,
      'admin': admin
    };
  }

  Session({this.name, this.photoUrl, this.code, this.musics, this.admin});

}