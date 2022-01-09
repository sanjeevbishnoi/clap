class UserPost {
  String? id;
  String? userId;
  String? postName;
  String? postLocation;
  String? postCategory;
  String? postDescription;
  String? postStartDate;
  String? postEndDate;
  String? gender;
  String? mediaRequirement;
  String? age;
  String? nationality;
  String? performingSkills;
  String? language;
  String? experience;
  String? requiresAudition;
  String? weight;
  String? height;
  String? chestSize;
  String? waistSize;
  String? breastSize;
  String? skinColor;
  String? hairType;
  String? hairColor;
  String? eyeColor;
  String? date;
  String? deleteStatus;
  String? status;
  String? categoryName;
  String? userName;
  String? image;
  String? postType;
  String? userEmail;
  String? userMobile;
  bool isWishlistStatus = false;

  UserPost(
      {this.id,
      this.userId,
      this.postName,
      this.postLocation,
      this.postCategory,
      this.postDescription,
      this.postStartDate,
      this.postEndDate,
      this.gender,
      this.mediaRequirement,
      this.age,
      this.nationality,
      this.performingSkills,
      this.language,
      this.experience,
      this.requiresAudition,
      this.weight,
      this.height,
      this.chestSize,
      this.waistSize,
      this.breastSize,
      this.skinColor,
      this.hairType,
      this.hairColor,
      this.eyeColor,
      this.date,
      this.deleteStatus,
      this.status,
      this.categoryName,
      this.userName,
      this.image,
      this.postType,
      required this.isWishlistStatus,
      this.userEmail,
      this.userMobile});

  UserPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    postName = json['post_name'];
    postLocation = json['post_location'];
    postCategory = json['post_category'];
    postDescription = json['post_description'];
    postStartDate = json['post_start_date'];
    postEndDate = json['post_end_date'];
    gender = json['gender'];
    mediaRequirement = json['media_requirement'];
    age = json['age'];
    nationality = json['nationality'];
    performingSkills = json['performing_skills'];
    language = json['language'];
    experience = json['experience'];
    requiresAudition = json['requires_audition'];
    weight = json['weight'];
    height = json['height'];
    chestSize = json['chest_size'];
    waistSize = json['waist_size'];
    breastSize = json['breast_size'];
    skinColor = json['skin_color'];
    hairType = json['hair_type'];
    hairColor = json['hair_color'];
    eyeColor = json['eye_color'];
    date = json['date'];
    deleteStatus = json['delete_status'];
    status = json['status'];
    categoryName = json['category_name'];
    userName = json['user_name'];
    image = json['image'];
    postType = json['post_type'];
    isWishlistStatus = json['wishlist_status'];
    userEmail = json['email'];
    userMobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['post_name'] = this.postName;
    data['post_location'] = this.postLocation;
    data['post_category'] = this.postCategory;
    data['post_description'] = this.postDescription;
    data['post_start_date'] = this.postStartDate;
    data['post_end_date'] = this.postEndDate;
    data['gender'] = this.gender;
    data['media_requirement'] = this.mediaRequirement;
    data['age'] = this.age;
    data['nationality'] = this.nationality;
    data['performing_skills'] = this.performingSkills;
    data['language'] = this.language;
    data['experience'] = this.experience;
    data['requires_audition'] = this.requiresAudition;
    data['weight'] = this.weight;
    data['height'] = this.height;
    data['chest_size'] = this.chestSize;
    data['waist_size'] = this.waistSize;
    data['breast_size'] = this.breastSize;
    data['skin_color'] = this.skinColor;
    data['hair_type'] = this.hairType;
    data['hair_color'] = this.hairColor;
    data['eye_color'] = this.eyeColor;
    data['date'] = this.date;
    data['delete_status'] = this.deleteStatus;
    data['status'] = this.status;
    data['category_name'] = this.categoryName;
    data['user_name'] = this.userName;
    data['image'] = this.image;
    return data;
  }
}
