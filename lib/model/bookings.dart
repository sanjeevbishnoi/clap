class Bookings {
  String? id;
  String? userId;
  String? bookedBy;
  String? bookingStatus;
  String? acceptedDate;
  String? deleteStatus;
  String? date;
  String? amount;
  String? duration;
  String? langauge;
  String? name;
  String? image;
  String? category;
  String? mobile;

  Bookings(
      {this.id,
      this.userId,
      this.bookedBy,
      this.bookingStatus,
      this.acceptedDate,
      this.deleteStatus,
      this.date,
      this.amount,
      this.duration,
      this.langauge,
      this.name,
      this.image,
      this.category,
      this.mobile});

  Bookings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    bookedBy = json['booked_by'];
    bookingStatus = json['booking_status'];
    acceptedDate = json['accepted_date'];
    deleteStatus = json['delete_status'];
    date = json['date'];
    amount = json['amount'];
    duration = json['duration'];
    langauge = json['langauge'];
    name = json['name'];
    image = json['image'];
    category = json['category'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['booked_by'] = this.bookedBy;
    data['booking_status'] = this.bookingStatus;
    data['accepted_date'] = this.acceptedDate;
    data['delete_status'] = this.deleteStatus;
    data['date'] = this.date;
    data['amount'] = this.amount;
    data['duration'] = this.duration;
    data['langauge'] = this.langauge;
    data['name'] = this.name;
    data['image'] = this.image;
    data['category'] = this.category;
    return data;
  }
}
