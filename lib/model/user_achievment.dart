class UserAchievment {
  String? id;
  String? userId;
  String? achvName;
  String? movieName;
  String? date;

  UserAchievment(
      {this.id, this.userId, this.achvName, this.movieName, this.date});

  UserAchievment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    achvName = json['achv_name'];
    movieName = json['movie_name'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['achv_name'] = this.achvName;
    data['movie_name'] = this.movieName;
    data['date'] = this.date;
    return data;
  }
}
