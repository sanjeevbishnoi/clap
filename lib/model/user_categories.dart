class UserCategories {
  UserCategories({
    required this.id,
    required this.name,
    required this.image,
    required this.date,
    required this.time,
    required this.deleteStatus,
  });
  late final String id;
  late final String name;
  late final String image;
  late final String date;
  late final String time;
  late final String deleteStatus;

  UserCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    date = json['date'];
    time = json['time'];
    deleteStatus = json['delete_status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['image'] = image;
    _data['date'] = date;
    _data['time'] = time;
    _data['delete_status'] = deleteStatus;
    return _data;
  }
}
