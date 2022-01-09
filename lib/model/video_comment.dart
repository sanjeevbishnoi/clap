class VideoComment {
  String? id;
  String? userId;
  String? videoId;
  String? comment;
  String? date;
  String? time;
  String? name;
  String? image;

  VideoComment(
      {this.id,
      this.userId,
      this.videoId,
      this.comment,
      this.date,
      this.time,
      this.name,
      this.image});

  VideoComment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    videoId = json['video_id'];
    comment = json['comment'];
    date = json['date'];
    time = json['time'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['video_id'] = this.videoId;
    data['comment'] = this.comment;
    data['date'] = this.date;
    data['time'] = this.time;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}
