class UploadAudio {
  String? id;
  String? userId;
  String? audioName;
  String? date;
  String? userName;
  String? audioCaption;

  UploadAudio(
      {this.id,
      this.userId,
      this.audioName,
      this.date,
      this.userName,
      this.audioCaption});

  UploadAudio.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    audioName = json['audio_name'];
    date = json['date'];
    userName = json['user_name'];
    audioCaption = json['audio_caption'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['audio_name'] = this.audioName;
    data['date'] = this.date;
    data['user_name'] = this.userName;
    return data;
  }
}

