class ChatUser {
  String? id;
  String? name;
  String? image;
  String? message;
  String? chatDate;
  String? chatTime;
  String? bio;

  ChatUser(
      {this.id,
      this.name,
      this.image,
      this.message,
      this.chatDate,
      this.chatTime,
      this.bio});

  ChatUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    message = json['msg'];
    chatDate = json['chat_date'];
    chatTime = json['chat_time'];
    bio = json['bio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}
