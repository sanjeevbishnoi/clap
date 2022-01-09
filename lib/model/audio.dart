class Audio {
  String? id;
  String? songName;
  String? album;
  String? artist;
  String? songUrl;
  String? thumbnail;
  String? image;
  String? date;
  String? time;
  
  String? delStatus;

  Audio(
      {this.id,
      this.songName,
      this.album,
      this.artist,
      this.songUrl,
      this.thumbnail,
      this.image,
      this.date,
      this.time,
      this.delStatus});

  Audio.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    songName = json['song_name'];
    album = json['album'];
    artist = json['artist'];
    songUrl = json['song_url'];
    thumbnail = json['thumbnail'];
    image = json['image'];
    date = json['date'];
    time = json['time'];
    delStatus = json['del_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['song_name'] = this.songName;
    data['album'] = this.album;
    data['artist'] = this.artist;
    data['song_url'] = this.songUrl;
    data['thumbnail'] = this.thumbnail;
    data['image'] = this.image;
    data['date'] = this.date;
    data['time'] = this.time;
    data['del_status'] = this.delStatus;
    return data;
  }
}