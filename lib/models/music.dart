class Music {

  late String title;
  late int duration;
  late int id;
  late String artist;
  late String pictureSmall;
  late String picture;
  late String sessionCode;
  late int likeCount;

  Map<String, dynamic> toJSON() {
    return {
      'title': title,
      'duration': duration,
      'id': id,
      'artist': artist,
      'pictureSmall': pictureSmall,
      'picture': picture,
      'sessionCode': sessionCode,
      'likeCount': likeCount
    };
  }

  Music.fromJSON(Map<String, dynamic> map) {
    title = map['title'];
    duration = map['duration'];
    id = map['id'];
    artist = map['artist'];
    picture = map['picture'];
    pictureSmall = map['pictureSmall'];
    sessionCode = map['sessionCode'];
    likeCount = map['likeCount'];
  }

  Music({required this.title, required this.id, required this.duration, required this.artist, required this.picture, required this.pictureSmall, required this.sessionCode, this.likeCount: 0});

}