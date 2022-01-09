class Testimonial {
  String? id;
  String? userId;
  String? img;
  String? message;
  String?createDate;

  Testimonial({this.id, this.userId, this.img, this.message, this.createDate});

  Testimonial.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    img = json['img'];
    message = json['message'];
    createDate = json['create_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['img'] = this.img;
    data['message'] = this.message;
    data['create_date'] = this.createDate;
    return data;
  }
}
