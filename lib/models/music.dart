class Music {
  String? name;
  String? sure;
  String? imgSrc;
  String? soundSrc;

  Music();

  Music.fromJson(dynamic json) {
    name = json['name'];
    sure = json['sure'];
    soundSrc = json['soundSrc'];
    imgSrc = json['imgSrc'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['name'] = name;
    map['sure'] = sure;
    map['soundSrc'] = soundSrc;
    map['imgSrc'] = imgSrc;
    return map;
  }
}
