class CelebrityUser {
  String? name;
  String? mobile;
  String? image;
  String? id;

  CelebrityUser({this.name, this.mobile, this.image, this.id});

  CelebrityUser.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobile = json['mobile'];
    image = json['image'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['image'] = this.image;
    data['id'] = this.id;
    return data;
  }
}
