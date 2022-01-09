class DirectoryUser {
  String? id;
  String? name;
  String? mobile;
  String? image;
  String? userCateory;
  String? mobileStatus;

  DirectoryUser(
      {this.id,
      this.name,
      this.mobile,
      this.image,
      this.userCateory,
      this.mobileStatus});

  DirectoryUser.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobile = json['mobile'];
    image = json['image'];
    id = json['id'];
    userCateory = json['user_category'];
    mobileStatus = json['mobile_show'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['image'] = this.image;
    return data;
  }
}
