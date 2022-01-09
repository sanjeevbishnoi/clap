class Booking {
  String? id;
  String? userId;
  String? bookedBy;
  String? bookingStatus;
  String? acceptedDate;
  String? deleteStatus;
  String? date;
  String? userName;
  String? userMobile;
  String? userEmail;
  String? userProfile;

  Booking(
      {this.id,
      this.userId,
      this.bookedBy,
      this.bookingStatus,
      this.acceptedDate,
      this.deleteStatus,
      this.date,
      this.userName,
      this.userMobile,
      this.userEmail,
      this.userProfile});

  Booking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    bookedBy = json['booked_by'];
    bookingStatus = json['booking_status'];
    acceptedDate = json['accepted_date'];
    deleteStatus = json['delete_status'];
    date = json['date'];
    userName = json['user_name'];
    userMobile = json['user_mobile'];
    userEmail = json['user_email'];
    userProfile = json['user_profile'];
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
    data['user_name'] = this.userName;
    data['user_mobile'] = this.userMobile;
    data['user_email'] = this.userEmail;
    data['user_profile'] = this.userProfile;
    return data;
  }
}
