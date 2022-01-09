class UserResume {
  String? id;
  String? userId;
  String? fileName;
  String? date;

  UserResume({this.id, this.userId, this.fileName, this.date});

  UserResume.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    fileName = json['filename'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['filename'] = this.fileName;
    data['date'] = this.date;
    return data;
  }
}
