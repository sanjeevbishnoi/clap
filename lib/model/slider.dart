class MySlider {
  final String id;
  final String image;
  final String date;

  MySlider({required this.id, required this.image, required this.date});

  factory MySlider.fromJson(Map<String, dynamic> json) {
    return MySlider(id: json['id'], image: json['image'], date: json['date']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['date'] = this.date;
    return data;
  }
}
