class Notifications {
  String? id;
  String? userId;
  String? broadcastUserId;
  String? notificationType;
  String? message;
  String? description;
  String? status;
  String? date;
  String? time;
  String? userProfile;
  String? userName;

  Notifications(
      {this.id,
      this.userId,
      this.broadcastUserId,
      this.notificationType,
      this.message,
      this.description,
      this.status,
      this.date,
      this.time,
      this.userProfile,
      this.userName});

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    broadcastUserId = json['broadcast_user_id'];
    notificationType = json['notification_type'];
    message = json['message'];
    description = json['description'];
    status = json['status'];
    date = json['date'];
    time = json['time'];
    userProfile = json['user_profile'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['broadcast_user_id'] = this.broadcastUserId;
    data['notification_type'] = this.notificationType;
    data['message'] = this.message;
    data['description'] = this.description;
    data['status'] = this.status;
    data['date'] = this.date;
    data['time'] = this.time;
    data['user_profile'] = this.userProfile;
    return data;
  }
}
