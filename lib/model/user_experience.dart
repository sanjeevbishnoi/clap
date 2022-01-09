class UserExperience {
  String? id;
  String? userId;
  String? projectName;
  String? role;
  String? dirCoName;
  String? location;
  String? date;

  UserExperience(
      {this.id,
      this.userId,
      this.projectName,
      this.role,
      this.dirCoName,
      this.location,
      this.date});

  UserExperience.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    projectName = json['project_name'];
    role = json['role'];
    dirCoName = json['dir_co_name'];
    location = json['location'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['project_name'] = this.projectName;
    data['role'] = this.role;
    data['dir_co_name'] = this.dirCoName;
    data['location'] = this.location;
    data['date'] = this.date;
    return data;
  }
  
}
