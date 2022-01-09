class ChatMessage {
  String? id;
  String? senderId;
  String? receiverId;
  String? message;
  String? date;
  String? time;
  String? status;

  ChatMessage(
      {this.id,
      this.senderId,
      this.receiverId, 
      this.message,
      this.date,
      this.time,
      this.status});

  ChatMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    message = json['message'];
    date = json['date'];
    time = json['time'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    data['message'] = this.message;
    data['date'] = this.date;
    data['time'] = this.time;
    data['status'] = this.status;
    return data;
  }
}
