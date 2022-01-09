
class UploadesPhoto {
  String? id;
  String? userId;
  String? imageName;
  String? date;

  UploadesPhoto({this.id, this.userId, this.imageName, this.date});

  UploadesPhoto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    imageName = json['image_name'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['image_name'] = this.imageName;
    data['date'] = this.date;
    return data;
  }
}