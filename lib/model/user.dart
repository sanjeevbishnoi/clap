class User {
  final String id;
  final String fbId;
  final String name;
  final String email;
  final String mobile;
  final String otp;
  final String otpStatus;
  final String status;
  final String delStatus;
  final String loginType;
  final String date;
  final String time;
  final String gender;
  final String hairStyle;
  final String hairColor;
  final String skinColor;
  final String langauge;
  final String talent;
  final String interest;
  final String youtubeLink;
  final String facebookLink;
  final String instagramLink;
  final String twitterLink;
  final String bio;
  final String image;
  final String dob;
  final String telegramLink;
  final String userCategory;
  final String country;
  final String state;
  final String city;
  final String weight;
  final String height;
  final String chestSize;
  final String breastSize;
  final String waistSize;
  final String hipSize;
  final String eyecolor;
  final String celebrity;
  final String isDirectory;
  final String postCount;
  final String bookingCount;
  final String passportNo;
  final String passIssueDate;
  final String passExpiryDate;
  final String dlNo;
  final String dlIssueDate;
  final String dlExpiryDate;
  final String passport;
  final String driving;
  final String swimming;
  final String dance;
  final String boldContent;
  final String printShoot;
  final String bodyPrintShoot;
  final String nudePrintShoot;
  final String bikiniPrintShoot;
  final String trainedActor;
  final String unionCard;
  final String experince;
  final String experienceYear;
  final String experienceArea;
  final String bodyType;
  final String disability;
  final String maritialStatus;
  final String type;
  final String price;
  String? wishlistStatus;
  final String workshopStatus;
  final String instituteName;
  final String address;
  final String pincode;
  String? followStatus;
  int? followingTotal;
  int? followersTotal;
  final String priceFor30sec;
  final String priceFor60sec;
  final String userCategoryName;
  String? mobileStatus;
  String? appliedJobCount;
  String? filmIndustry;
  int? reelsCount;

  User(
      {required this.id,
      required this.fbId,
      required this.name,
      required this.email,
      required this.mobile,
      required this.otp,
      required this.otpStatus,
      required this.status,
      required this.delStatus,
      required this.loginType,
      required this.date,
      required this.time,
      required this.gender,
      required this.hairColor,
      required this.hairStyle,
      required this.skinColor,
      required this.langauge,
      required this.talent,
      required this.interest,
      required this.youtubeLink,
      required this.facebookLink,
      required this.instagramLink,
      required this.twitterLink,
      required this.bio,
      required this.image,
      required this.dob,
      required this.telegramLink,
      required this.userCategory,
      required this.country,
      required this.state,
      required this.city,
      required this.height,
      required this.weight,
      required this.chestSize,
      required this.waistSize,
      required this.hipSize,
      required this.eyecolor,
      required this.celebrity,
      required this.isDirectory,
      required this.postCount,
      required this.bookingCount,
      required this.breastSize,
      required this.passportNo,
      required this.passIssueDate,
      required this.passExpiryDate,
      required this.dlNo,
      required this.dlIssueDate,
      required this.dlExpiryDate,
      required this.passport,
      required this.driving,
      required this.swimming,
      required this.dance,
      required this.boldContent,
      required this.printShoot,
      required this.bodyPrintShoot,
      required this.nudePrintShoot,
      required this.bikiniPrintShoot,
      required this.trainedActor,
      required this.unionCard,
      required this.experince,
      required this.experienceYear,
      required this.experienceArea,
      required this.bodyType,
      required this.disability,
      required this.maritialStatus,
      required this.type,
      required this.price,
      this.wishlistStatus,
      required this.workshopStatus,
      required this.instituteName,
      required this.address,
      required this.pincode,
      this.followStatus,
      this.followersTotal,
      this.followingTotal,
      required this.priceFor30sec,
      required this.priceFor60sec,
      required this.userCategoryName,
      this.mobileStatus,
      required this.appliedJobCount,
      required this.filmIndustry,
      this.reelsCount});

  factory User.fromMap(Map<dynamic, dynamic> json) {
    return User(
        id: json['id'],
        fbId: json['fb_id'],
        name: json['name'],
        email: json['email'],
        mobile: json['mobile'],
        gender: json['gender'],
        hairStyle: json['hair_style'],
        hairColor: json['hair_color'],
        skinColor: json['skin_color'],
        langauge: json['language'],
        talent: json['talent'],
        interest: json['interest'],
        youtubeLink: json['youtube_link'],
        facebookLink: json['facebook_link'],
        instagramLink: json['instagram_link'],
        twitterLink: json['twitter_link'],
        telegramLink: json['telegram_link'],
        bio: json['bio'],
        image: json['image'],
        dob: json['dob'],
        otp: json['otp'],
        otpStatus: json['otp_status'],
        status: json['status'],
        delStatus: json['del_status'],
        loginType: json['login_type'],
        date: json['date'],
        time: json['time'],
        userCategory: json['user_category'],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        height: json["height"],
        waistSize: json["waistsize"],
        chestSize: json["chestsize"],
        weight: json["Weight"],
        eyecolor: json["eyecolor"],
        hipSize: json['hipsize'],
        celebrity: json['celebrity'],
        isDirectory: json['isDirectory'],
        postCount: json['post_count'],
        bookingCount: json['booking_count'],
        breastSize: json['breastsize'],
        passportNo: json["passportno"],
        passIssueDate: json["issue_date"],
        passExpiryDate: json["passport_expirydate"],
        dlNo: json["dl_no"],
        dlIssueDate: json["dl_issue_date"],
        dlExpiryDate: json["dl_expiry_date"],
        passport: json['passport'],
        driving: json['driving'],
        swimming: json['swimming'],
        dance: json['dance'],
        boldContent: json['bold_content'],
        printShoot: json['print_shoot'],
        bodyPrintShoot: json['body_print_shoot'],
        nudePrintShoot: json['nude_print_shoot'],
        bikiniPrintShoot: json['bikini_print_shoot'],
        trainedActor: json['trained_actor'],
        unionCard: json['union_card'],
        experince: json['experience'],
        experienceYear: json['experience_year'],
        experienceArea: json['experience_area'],
        bodyType: json['body_type'],
        disability: json['disability'],
        maritialStatus: json['marital_status'],
        type: json['type'],
        price: json['price'],
        wishlistStatus: json['wishlist_status'],
        workshopStatus: json['workshop_status'],
        instituteName: json['institute_name'],
        address: json['address'],
        pincode: json['pincode'],
        followStatus: json['follow_status'],
        followingTotal: json['following_total'],
        followersTotal: json['followers_total'],
        priceFor30sec: json['priceFor30sec'],
        priceFor60sec: json['priceFor60sec'],
        userCategoryName: json['user_cat'],
        mobileStatus: json['mobile_show'],
        appliedJobCount: json['jon_count'],
        filmIndustry: json['film_industry'],
        reelsCount: json['reels_count']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fb_id'] = this.fbId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['gender'] = this.gender;
    data['hair_style'] = this.hairStyle;
    data['hair_color'] = this.hairColor;
    data['skin_color'] = this.skinColor;
    data['language'] = this.langauge;
    data['talent'] = this.talent;
    data['interest'] = this.interest;
    data['youtube_link'] = this.youtubeLink;
    data['facebook_link'] = this.facebookLink;
    data['instagram_link'] = this.instagramLink;
    data['twitter_link'] = this.twitterLink;
    data['telegram_link'] = this.telegramLink;
    data['bio'] = this.bio;
    data['image'] = this.image;
    data['dob'] = this.dob;
    data['otp'] = this.otp;
    data['otp_status'] = this.otpStatus;
    data['status'] = this.status;
    data['del_status'] = this.delStatus;
    data['login_type'] = this.loginType;
    data['date'] = this.date;
    data['time'] = this.time;
    data['user_category'] = this.userCategory;
    data['directory'] = this.isDirectory;
    data['celebrity'] = this.celebrity;
    data['breastsize'] = this.breastSize;
    return data;
  }
}
