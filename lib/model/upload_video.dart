class UploadVideo {
  String? id;
  String? userId;
  String? videoName;
  String? date;
  String? img;
  String? userName;
  String? videoCaption;
  String? viewOption;

  UploadVideo(
      {this.id,
      this.userId,
      this.videoName,
      this.date,
      this.img,
      this.userName,
      this.videoCaption,
      this.viewOption});

  UploadVideo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    videoName = json['video_name'];
    date = json['date'];
    img = json['img'];
    userName = json['user_name'];
    videoCaption = json['video_caption'];
    viewOption = json['view_option'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['video_name'] = this.videoName;
    data['date'] = this.date;
    data['img'] = this.img;
    data['user_name'] = this.userName;
    return data;
  }
}
