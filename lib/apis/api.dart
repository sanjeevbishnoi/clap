import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:qvid/helper/my_preference.dart';
import 'package:qvid/model/user.dart';
import 'package:qvid/utils/constaints.dart';

class Apis {
  //user login

  Future<http.Response> userLogin(String mobile) async {
    var url = Uri.parse(Constraints.BASE_URL);

    return await http.post(url, body: {"mobile": "$mobile", "flag": "Login"});
  }

  //otp verification
  Future<http.Response> verifyOtp(String mobile, String otp) async {
    var url = Uri.parse(Constraints.BASE_URL);
    return await http.post(url,
        body: {"mobile": "$mobile", "otp": "$otp", "flag": "VerifyOTP"});
  }

  //pending task

  //resend Otp

  Future<http.Response> resendOtp(String mobile) async {
    var url = Uri.parse(Constraints.BASE_URL);
    return await http
        .post(url, body: {"mobile": "$mobile", "flag": "ResendOtp"});
  }

  //update persional details
  Future<http.Response> updatePersionalDetails(
      String id,
      String name,
      String email,
      String gender,
      String dob,
      String language,
      String skinColor,
      String hairStyle,
      String hairColor,
      String categorylist,
      String country,
      String state,
      String city,
      String weight,
      String height,
      String chestSize,
      String breastSize,
      String waistSize,
      String hipSize,
      String eyeColor,
      String passportStatus,
      String drivingStatus,
      String swimmingStatus,
      String danceStatus,
      String boldContentStatus,
      String printShootStatus,
      String bodyPrintShootStatus,
      String nudePrintShootStatus,
      String bikiniPrintShootStatus,
      String treainedActorStatus,
      String unionCardStatus,
      String experienceStatus,
      String expericenceYear,
      String expericenceArea,
      String disablityStatus,
      String bodyType,
      String maritalStaus,
      //String busyStatus,
      String userType,
      String workshopStatus,
      String instituteName,
      String address,
      String pincode,
      String industry) async {
    var url = Uri.parse(Constraints.BASE_URL);
    print("hellosdsds");
    return await http.post(url, body: {
      "id": "$id",
      "name": "$name",
      "email": "$email",
      "gender": "$gender",
      "dob": "$dob",
      "language": "$language",
      "skin_color": "$skinColor",
      "hair_style": "$hairStyle",
      "hair_color": "$hairColor",
      "category": "$categorylist",
      "country": "$country",
      'state': "$state",
      "city": "$city",
      "Weight": "$weight",
      "height": "$height",
      "chestsize": "$chestSize",
      "waistsize": "$waistSize",
      "hipsize": "$hipSize",
      "eyecolor": "$eyeColor",
      "breastsize": "$breastSize",
      "passport": passportStatus,
      "driving": drivingStatus,
      "swimming": swimmingStatus,
      "dance": danceStatus,
      "bold_content": boldContentStatus,
      "print_shoot": printShootStatus,
      "body_print_shoot": bodyPrintShootStatus,
      "nude_print_shoot": nudePrintShootStatus,
      "bikini_print_shoot": bikiniPrintShootStatus,
      "trained_actor": treainedActorStatus,
      "union_card": unionCardStatus,
      "experience": experienceStatus,
      "experience_year": expericenceYear,
      "experience_area": expericenceArea,
      //"busy": busyStatus,
      "body_type": bodyType,
      "disability": disablityStatus,
      "marital_status": maritalStaus,
      "type": userType,
      "workshop_status": maritalStaus,
      "institute_name": instituteName,
      "address": address,
      "pincode": pincode,
      "film_industry": industry,
      "flag": "UpdateDetail"
    });
  }

//update detail talent and interest

  Future<http.Response> updateTalentDetails(
      String id, String talent, String interest) async {
    var url = Uri.parse(Constraints.BASE_URL);
    return await http.post(url, body: {
      "id": "$id",
      "talent": "$talent",
      "interest": "$interest",
      "flag": "UpdateDetail1"
    });
  }

//update social details
  Future<http.Response> updateSocialDetails(
      String id,
      String youtubeId,
      String instagramId,
      String facebookId,
      String twitterId,
      String telegramId) async {
    var url = Uri.parse(Constraints.BASE_URL);
    return await http.post(url, body: {
      "id": "$id",
      "youtube": "$youtubeId",
      "instagram": "$instagramId",
      "facebook": "$facebookId",
      "twitter": "$twitterId",
      "telegram": "$telegramId",
      "flag": "UpdateSocial"
    });
  }

  //get Categories

  Future<http.Response> getUserCategories() async {
    var url = Uri.parse(Constraints.DATA_URL);
    return await http.post(url, body: {"flag": "Categories"});
  }

  //get cateogryu
  Future<http.Response> getCategories(String cat) async {
    var url = Uri.parse(Constraints.DATA_URL);
    return await http.post(url, body: {"cat": cat, "flag": "Category_Cat"});
  }

  //update basic profile details

  Future<http.Response> updateBasicProfileDetails(
      String id, String image, String bio) async {
    var url = Uri.parse(Constraints.BASE_URL);
    return await http.post(url, body: {
      "id": "$id",
      "image": "$image",
      "bio": "$bio",
      "flag": "UpdateProfile"
    });
  }

//get User

  Future<http.Response> getUser(String id) async {
    var result = await MyPrefManager.prefInstance().getData("user");
    User user = User.fromMap(jsonDecode(result) as Map<String, dynamic>);
    print(user.id);
    var url = Uri.parse(Constraints.BASE_URL);
    return await http
        .post(url, body: {"user_id": user.id, "id": "$id", "flag": "GetUser"});
  }

  //get Slider

  Future<http.Response> getSlider() async {
    var url = Uri.parse(Constraints.DATA_URL);
    return await http.post(url, body: {"flag": "Slider"});
  }

  //upload video

  Future<http.Response> uploadPost(String userId, File file, String title,
      String description, File coverImage, String option) async {
    var url = Uri.parse(Constraints.BASE_URL);
    var request = http.MultipartRequest('POST', url)
      ..fields['user_id'] = userId
      ..fields['flag'] = 'upload_video'
      ..fields['title'] = title
      ..fields['reels_view_option'] = option
      ..fields['description'] = description
      ..files.add(http.MultipartFile.fromBytes(
          'cover_image', coverImage.readAsBytesSync(),
          contentType: MediaType('application', 'image/*'),
          filename: coverImage.path.split("/").last))
      ..files.add(http.MultipartFile.fromBytes(
          'video_name', file.readAsBytesSync(),
          contentType: MediaType('application', 'video/mp4'),
          filename: file.path.split("/").last));
    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  //get Video

  //get Matching Post
  Future<http.Response> getMatchingPost(String id) async {
    var url = Uri.parse(Constraints.DATA_URL);
    return await http.post(url, body: {"user_id": "$id", "flag": "Post"});
  }
  //get All Post

  Future<http.Response> getAllPost(String id) async {
    var url = Uri.parse(Constraints.DATA_URL);
    return await http.post(url, body: {"user_id": "$id", "flag": "AllPost"});
  }

  //add post

  Future<http.Response> addPost(
      String id,
      String categoryId,
      String title,
      String location,
      String startDate,
      String description,
      String gender,
      //String mediaRequirement,
      String age,
      String nationality,
      String performingSkills,
      String lanuage,
      String experience,
      String requiresAudition,
      String weight,
      String height,
      String chestSize,
      String breastSize,
      String waistSize,
      String skinColor,
      String hairType,
      String hairColor,
      String eyeColor,
      String postType) async {
    var url = Uri.parse(Constraints.DATA_URL);

    return await http.post(url, body: {
      "user_id": "$id",

      "category_id": "$categoryId",
      "title": "$title",
      "location": "$location",
      "post_start_date": "$startDate",
      "description": "$description",
      "post_end_date": "$startDate",
      "gender": gender,
      //"media_requirement": mediaRequirement,
      "age": age,
      "nationality": nationality,
      "performing_skills": performingSkills,
      "language": lanuage,
      "experience": experience,
      "requires_audition": requiresAudition,
      "weight": weight,
      "height": height,
      'chest_size': chestSize,
      'waist_size': waistSize,
      'breast_size': breastSize,
      'skin_color': skinColor,
      'hair_type': hairType,
      'hair_color': hairColor,
      'eye_color': eyeColor,
      'post_type': postType,

      "flag": "AddPost"
    });
  }

  //apply job

  Future<http.Response> applyPost(
      String userId, String postId, String type, File? uploadFile) async {
    var url = Uri.parse(Constraints.DATA_URL);
    var request;
    if (uploadFile != null) {
      request = http.MultipartRequest('POST', url)
        ..fields['user_id'] = userId
        ..fields['flag'] = 'ApplyJob'
        ..fields['post_id'] = postId
        ..fields['type'] = type
        ..files.add(http.MultipartFile.fromBytes(
            'file', uploadFile.readAsBytesSync(),
            contentType: MediaType('application', '/*'),
            filename: uploadFile.path.split("/").last));
    } else {
      request = http.MultipartRequest('POST', url)
        ..fields['user_id'] = userId
        ..fields['flag'] = 'ApplyJob'
        ..fields['post_id'] = postId;
    }

    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  //get Applied Post list
  Future<http.Response> getAppliedPostList(String userId) async {
    var url = Uri.parse(Constraints.DATA_URL);
    return await http
        .post(url, body: {'user_id': '$userId', 'flag': 'AppliedJob'});
  }

  //search post

  Future<http.Response> searchPost(String value) async {
    var url = Uri.parse(Constraints.DATA_URL);
    return await http
        .post(url, body: {'value': '$value', 'flag': 'SearchPost'});
  }

  //search api

  Future<http.Response> searchAll(
      String value, String searchKey, String userId) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url, body: {
      "user_id": userId,
      'search_key': '$searchKey',
      'search': '$value',
      'flag': 'search_data'
    });
  }

  //get video
  Future<http.Response> getVideo(String userId) async {
    var url = Uri.parse(Constraints.BASE_URL);
    return await http.post(url, body: {"user_id": userId, "flag": "get_video"});
  }

  Future<http.Response> getLikedVideo(String userId) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http
        .post(url, body: {"user_id": userId, "flag": "get_like_video"});
  }

  //get Followers video list
  Future<http.Response> getFollowersVideo(String userId) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url, body: {
      "user_id": userId,
      "start": "0",
      "end": "10",
      "flag": "video_user_list"
    });
  }

  Future<http.Response> getNewAudio() async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http
        .post(url, body: {"start": "0", "end": "10", "flag": "songs_list"});
  }

  //get Releated video

  Future<http.Response> getRelatedVideo(String userId, String gender) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url, body: {
      "user_id": userId,
      "start": "0",
      "end": "10",
      "gender": gender,
      "flag": "video_list_by_gender"
    });
  }

  //manage apis

  //like

  Future<http.Response> likeVideo(String userId, String videoId) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url,
        body: {"user_id": userId, "video_id": videoId, "flag": "like"});
  }

  //comment video

  Future<http.Response> commentVideo(
      String userId, String videoId, String comment) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url, body: {
      "user_id": userId,
      "video_id": videoId,
      "comment": comment,
      "flag": "comment"
    });
  }

  //share video
  Future<http.Response> shareVideo(String userId, String videoId) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url,
        body: {"user_id": userId, "video_id": videoId, "flag": "share"});
  }

  //get Video Comment

  Future<http.Response> getVideoComment(String videoId) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http
        .post(url, body: {"video_id": videoId, "flag": "view_comment"});
  }

  //get chat user list
  Future<http.Response> getChatUserList(String userId) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http
        .post(url, body: {"user_id": userId, "flag": "chat_user_list"});
  }

  Future<http.Response> getSuggestedUserList(String userId) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url, body: {
      "user_id": userId,
      "start": "0",
      "end": "10",
      "flag": "user_list"
    });
  }

  //search chat users

  Future<http.Response> searchChatUserList(String value, String userId) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url, body: {
      "value": value,
      "start": "0",
      "end": "10",
      "user_id": userId,
      "flag": "search"
    });
  }

//chat with user
  Future<http.Response> sendMessages(
      String senderId, String receiverId, String message) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url, body: {
      "sender_id": senderId,
      "receiver_id": receiverId,
      "message": message,
      "flag": "chat"
    });
  }

  //get chat list

  Future<http.Response> getChatList(String senderId, String receiverId) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url, body: {
      "sender_id": senderId,
      "receiver_id": receiverId,
      "flag": "chat_list"
    });
  }

  //get Directory
  Future<http.Response> getDirectory(String userId) async {
    var url = Uri.parse(Constraints.DATA_URL);
    return await http
        .post(url, body: {"user_id": userId, "flag": "GetDirectory"});
  }

  //get getCelebrity

  Future<http.Response> getCelebrity(String userId) async {
    var url = Uri.parse(Constraints.DATA_URL);
    return await http
        .post(url, body: {"user_id": userId, "flag": "GetCelebrity"});
  }

  //become celebrity

  Future<http.Response> becomeCelebrity(String userId, String status,
      String priceFor30sec, String priceFor60sec) async {
    var url = Uri.parse(Constraints.BASE_URL);
    return await http.post(url, body: {
      "priceFor30sec": priceFor30sec,
      "priceFor60sec": priceFor60sec,
      "status": status,
      "user_id": userId,
      "flag": "BecomeCelebrity"
    });
  }

  //enable directory

  Future<http.Response> enableDirectory(String userId, String status) async {
    var url = Uri.parse(Constraints.BASE_URL);
    return await http.post(url,
        body: {"status": status, "user_id": userId, "flag": "EnableDirectory"});
  }

  //enable show your mobile no
  Future<http.Response> enableShowMobileNo(String userId, String status) async {
    var url = Uri.parse(Constraints.BASE_URL);
    return await http.post(url,
        body: {"status": status, "user_id": userId, "flag": "ShowMobile"});
  }

  //book celebrity wishesh

  Future<http.Response> bookCelebrity(String userId, String cellId,
      String language, String duration, String amount) async {
    var url = Uri.parse(Constraints.DATA_URL);
    return await http.post(url, body: {
      "user_id": userId,
      "cel_id": cellId,
      "langauge": language,
      "duration": duration,
      "amount": amount,
      "flag": "BookCelebrity"
    });
  }

  // get List of mybooking

  Future<http.Response> getCelebrityBookingList(String userId) async {
    var url = Uri.parse(Constraints.DATA_URL);
    return await http
        .post(url, body: {"user_id": userId, "flag": "MyCelBookings"});
  }

//get mybooking

  Future<http.Response> getMyBookingList(String userId) async {
    var url = Uri.parse(Constraints.DATA_URL);
    return await http
        .post(url, body: {"user_id": userId, "flag": "MyBookings"});
  }

  //get Categorywise Directory
  Future<http.Response> getDirectoryByCategory(
      String catId, String userId) async {
    var url = Uri.parse(Constraints.DATA_URL);
    return await http.post(url, body: {
      "user_id": userId,
      "cat_id": catId,
      "flag": "GetDirectoryByCat"
    });
  }

  //get My Post
  Future<http.Response> getMyPost(String userId) async {
    var url = Uri.parse(Constraints.DATA_URL);
    return await http.post(url, body: {"user_id": userId, "flag": "MyPost"});
  }

  //delete account

  Future<http.Response> deleteAccount(String userId) async {
    var url = Uri.parse(Constraints.BASE_URL);
    return await http.post(url, body: {"id": userId, "flag": "DeleteProfile"});
  }

  //update document

  Future<http.Response> updateDocument(
      String userId,
      String passportIssueDate,
      String dlIssueDate,
      String passportNo,
      String dlNumber,
      String dlEpiryDate,
      String passportExpiryDate) async {
    var url = Uri.parse(Constraints.BASE_URL);
    return await http.post(url, body: {
      "user_id": userId,
      "passportno": passportNo,
      "issue_date": passportIssueDate,
      "dl_no": dlNumber,
      "dl_issue_date": dlIssueDate,
      "dl_expiry_date": dlEpiryDate,
      "passport_expirydate": passportExpiryDate,
      "flag": "UpdateDocuments"
    });
  }

  //add testimonial

  Future<http.Response> addTestimonial(
      String userId, String message, String image) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url, body: {
      "user_id": userId,
      "message": message,
      "image": image,
      "flag": "testimonial"
    });
  }

  //get Testimonial
  Future<http.Response> getTestimonial() async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url, body: {"flag": "get_testimonial"});
  }

  //add Wishlist to user

  Future<http.Response> addWishList(String userId, String fUserId) async {
    var url = Uri.parse(Constraints.BASE_URL);
    return await http.post(url,
        body: {"user_id": userId, "f_user_id": fUserId, "flag": "wishlist"});
  }

  Future<http.Response> sendBroadcast(
      String userId,
      String mainCategory,
      String gender,
      String category,
      String age,
      String country,
      String state,
      String city,
      String typeOfBroadcast,
      String description,
      File? uploadFile) async {
    var url = Uri.parse(Constraints.MANAGE_URL);

    var request = http.MultipartRequest('POST', url)
      ..fields['user_id'] = userId
      ..fields['flag'] = 'broadcast'
      ..fields['mainCateory'] = mainCategory
      ..fields['gender'] = gender
      ..fields['category'] = category
      ..fields['age'] = age
      ..fields['country'] = country
      ..fields['state'] = state
      ..fields['city'] = city
      ..fields['type_broadcast'] = typeOfBroadcast
      ..fields['description'] = description;

    // ..files.add(http.MultipartFile.fromBytes(
    //contentType: MediaType('application', '/*'),
    //filename: uploadFile.path.split("/").last)

    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  //get wishlist
  Future<http.Response> getWishList(String userId) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http
        .post(url, body: {"user_id": userId, "flag": "wishlist_list"});
  }

  //get Followers list
  Future<http.Response> getFollowersList(String userId) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url, body: {
      "start": "0",
      "end": "10",
      "user_id": userId,
      "flag": "followers_list_"
    });
  }

  //get Following list
  Future<http.Response> getFollowingList(String userId) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url, body: {
      "start": "0",
      "end": "10",
      "user_id": userId,
      "flag": "follow_list_"
    });
  }

  //report on profile
  Future<http.Response> reportOnProfile(
      String userId, String rpo_id, String report) async {
    print(userId + "dsd" + rpo_id);
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url, body: {
      "user_id": userId,
      "report_id": rpo_id,
      "report": report,
      "flag": "report_profile"
    });
  }

//get new user
  Future<http.Response> getNewUser(String userId) async {
    var url = Uri.parse(Constraints.BASE_URL);
    return await http.post(url, body: {
      "start": "0",
      "end": "5",
      "flag": "new_user_list",
      "user_id": userId
    });
  }

  //follow api
  Future<http.Response> followUser(String userId, String fId) async {
    var url = Uri.parse(Constraints.BASE_URL);
    return await http.post(url,
        body: {"user_id": userId, "follow_user_id": fId, "flag": "following"});
  }

  //for upload images
  Future<http.Response> uploadPhoto(String userId, String image) async {
    var url = Uri.parse(Constraints.BASE_URL);
    return await http.post(url,
        body: {"id": userId, "image": image, "flag": "UpdatePhotos"});
  }

//get Photos
  Future<http.Response> getPhotos(String userId) async {
    var url = Uri.parse(Constraints.DATA_URL);
    return await http
        .post(url, body: {"user_id": userId, "flag": "GetUserPhoto"});
  }

//filter user
  Future<http.Response> filterUser(
      String userTye,
      String gender,
      String userCategory,
      String hairType,
      String skinColor,
      String bodyType,
      String age,
      String passport,
      String driving,
      String swimming,
      String dance,
      String boldContent,
      String printShoot,
      String bodyPrintShoot,
      String nudePrintShoot,
      String bikniPrintShoot,
      String trainedArtist,
      String unionCard,
      String userExperience,
      String userDisablity,
      String workshop,
      String city) async {
    var url = Uri.parse(Constraints.BASE_URL);
    return await http.post(url, body: {
      //"user_id": userId,
      "start": "0",
      "end": "10",
      "userType": userTye,
      "userGender": gender,
      "userCategory": userCategory,
      "age": age,

      "hairType": hairType,
      "skinColor": skinColor,
      "bodyType": bodyType,
      "passport": passport,
      "knowDriving": driving,
      "knowSwimming": swimming,
      "dance": dance,
      "boldContent": boldContent,
      "printShoot": printShoot,
      "bodyPrintShoot": bodyPrintShoot,
      "nudePrintShoot": nudePrintShoot,
      "bikiniPrintShoot": bikniPrintShoot,
      "trainedArtis": trainedArtist,
      "unionCard": unionCard,
      "userExperience": userExperience,
      "userDisablity": userDisablity,
      "workshop": workshop,
      "city": city,
      "flag": "filter_user"
    });
  }

  //update token
  Future<http.Response> updateToken(String userId, String token) async {
    var url = Uri.parse(Constraints.BASE_URL);
    return await http.post(url,
        body: {"user_id": userId, "token": token, "flag": "update_token"});
  }

  //post wishlist

  Future<http.Response> addFavouriteJob(String userId, String postId) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url,
        body: {"user_id": userId, "post_id": postId, "flag": "job_wishlist"});
  }

  Future<http.Response> getFavouriteJob(String userId) async {
    var url = Uri.parse(Constraints.DATA_URL);
    return await http
        .post(url, body: {"user_id": userId, "flag": "GetFavoriteJob"});
  }

  Future<http.Response> getNotification(String userId) async {
    var url = Uri.parse(Constraints.DATA_URL);
    return await http
        .post(url, body: {"user_id": userId, "flag": "MyNotifications"});
  }

  //upload video
  Future<http.Response> uploadVideo(String userId, String option,
      File uploadFile, File coverImage, String caption) async {
    var url = Uri.parse(Constraints.MANAGE_URL);

    var request = http.MultipartRequest('POST', url)
      ..fields['user_id'] = userId
      ..fields['flag'] = 'upload_video'
      ..fields['view_option'] = option
      ..fields['video_caption'] = caption
      ..files.add(http.MultipartFile.fromBytes(
          'cover_image', coverImage.readAsBytesSync(),
          contentType: MediaType('application', 'image/*'),
          filename: coverImage.path.split("/").last))
      ..files.add(http.MultipartFile.fromBytes(
          'video_name', uploadFile.readAsBytesSync(),
          contentType: MediaType('application', 'video/mp4'),
          filename: uploadFile.path.split("/").last));

    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  //upload audio

  Future<http.Response> uploadAudio(
      String userId, File uploadFile, String caption) async {
    var url = Uri.parse(Constraints.MANAGE_URL);

    var request = http.MultipartRequest('POST', url)
      ..fields['user_id'] = userId
      ..fields['flag'] = 'upload_music'
      ..fields['audio_caption'] = caption
      ..files.add(http.MultipartFile.fromBytes(
          'music_name', uploadFile.readAsBytesSync(),
          contentType: MediaType('application', 'audio/mp3'),
          filename: uploadFile.path.split("/").last));
    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  //get videos
  Future<http.Response> getVideos(String userId, String viewerId) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url,
        body: {"user_id": userId, "viewer_id": viewerId, "flag": "get_video"});
  }

  //get Audios
  Future<http.Response> getAudios(String userId) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url, body: {"user_id": userId, "flag": "get_music"});
  }

  //add exeperice

  Future<http.Response> addExperices(
      String userId,
      String expericeId,
      String projectName,
      String role,
      String directorCompanyName,
      String location,
      String date) async {
    var url = Uri.parse(Constraints.BASE_URL);
    return await http.post(url, body: {
      "user_id": userId,
      "exp_id": expericeId,
      "project_name": projectName,
      "role": role,
      "dir_co_name": directorCompanyName,
      "location": location,
      "dates": date,
      "flag": "user_experience"
    });
  }

//get experience list

  Future<http.Response> getExperience(
    String userId,
  ) async {
    var url = Uri.parse(Constraints.BASE_URL);
    return await http
        .post(url, body: {"user_id": userId, "flag": "Get_User_Experience"});
  }

  Future<http.Response> addAchievement(String userId, String achievmentId,
      String acheivementName, String movieName, String date) async {
    var url = Uri.parse(Constraints.BASE_URL);
    return await http.post(url, body: {
      "user_id": userId,
      "aid": achievmentId,
      "achv_name": acheivementName,
      "movie_name": movieName,
      "dates": date,
      "flag": "Achievements"
    });
  }

  Future<http.Response> getAchievments(
    String userId,
  ) async {
    var url = Uri.parse(Constraints.BASE_URL);
    return await http
        .post(url, body: {"user_id": userId, "flag": "Get_Achievements"});
  }

  Future<http.Response> uploadResume(String userId, File uploadFile) async {
    var url = Uri.parse(Constraints.BASE_URL);
    var request = http.MultipartRequest('POST', url)
      ..fields['user_id'] = userId
      ..fields['flag'] = 'resume'
      ..files.add(http.MultipartFile.fromBytes(
          'pdf', uploadFile.readAsBytesSync(),
          contentType: MediaType('application', 'application/pdf'),
          filename: uploadFile.path.split("/").last));
    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  Future<http.Response> getResume(
    String userId,
  ) async {
    var url = Uri.parse(Constraints.BASE_URL);
    return await http
        .post(url, body: {"user_id": userId, "flag": "Get_Resume"});
  }

  Future<http.Response> deleteVideo(String userId, String videoId) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url,
        body: {"user_id": userId, "video_id": videoId, "flag": "delete_video"});
  }

  Future<http.Response> deletePhotos(String userId, String photoId) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url,
        body: {"user_id": userId, "photo_id": photoId, "flag": "delete_photo"});
  }

  Future<http.Response> deleteAudio(String userId, String audioId) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url,
        body: {"user_id": userId, "audio_id": audioId, "flag": "delete_audio"});
  }

  Future<http.Response> deleteExperienceId(
      String userId, String experienceId) async {
    var url = Uri.parse(Constraints.BASE_URL);
    return await http.post(url, body: {
      "user_id": userId,
      "exp_id": experienceId,
      "flag": "Delete_Experience"
    });
  }

  Future<http.Response> deleteAchievment(
      String userId, String achievmentId) async {
    var url = Uri.parse(Constraints.BASE_URL);
    return await http.post(url, body: {
      "user_id": userId,
      "aid": achievmentId,
      "flag": "Delete_Achievement"
    });
  }

  Future<http.Response> updateVideo(String userId, String videoId,
      String viewOption, String videoCaption) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url, body: {
      "user_id": userId,
      "video_id": videoId,
      "view_option": viewOption,
      "video_caption": videoCaption,
      "flag": "update_video"
    });
  }

  Future<http.Response> updateAudio(
      String userId, String audioId, String videoCaption) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url, body: {
      "user_id": userId,
      "audio_id": audioId,
      "audio_caption": videoCaption,
      "flag": "update_audio"
    });
  }

  Future<http.Response> getApplicants(String postId) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http
        .post(url, body: {"post_id": postId, "flag": "applyJobList"});
  }

  Future<http.Response> deleteData(String dataId, String tableName) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url,
        body: {"delete_id": dataId, "table": tableName, "flag": "delete_data"});
  }

  Future<http.Response> updateReelView(String reelview, String videoId) async {
    var url = Uri.parse(Constraints.BASE_URL);
    return await http.post(url, body: {
      "reels_view": reelview,
      "video_id": videoId,
      "flag": "update_reels_view"
    });
  }

  Future<http.Response> deleteJob(String postId) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url, body: {"job_id": postId, "flag": "delete_job"});
  }

  Future<http.Response> reportReel(
      String userid, String reelsId, String reportText) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url, body: {
      "user_id": userid,
      "reels_id": reelsId,
      "report_id": reportText,
      "flag": "report_reels"
    });
  }

  Future<http.Response> report(
      String userid, String id, String reportText, String type) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url, body: {
      "user_id": userid,
      "id": id,
      "report_text": reportText,
      "type": type,
      "flag": "reports"
    });
  }

  Future<http.Response> getBookingList(String userid, String type) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url,
        body: {"user_id": userid, "type": type, "flag": 'booking_list'});
  }

  Future<http.Response> updateMobileNo(String userid, String mobile) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url, body: {
      "user_id": userid,
      "mobile_number": mobile,
      "flag": 'update_mobile'
    });
  }

  Future<http.Response> verifyOtpForUpdateNo(
      String userid, String mobile, String otp) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url, body: {
      "user_id": userid,
      "mobile_number": mobile,
      "otp": otp,
      "flag": 'update_mobile_otp'
    });
  }

  Future<http.Response> resendOTPForUpdateNo(
      String userid, String mobile) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url, body: {
      "user_id": userid,
      "mobile_number": mobile,
      "flag": 'update_mobile_resend_otp'
    });
  }

  Future<http.Response> sendInterest(String userid, String interest) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url,
        body: {"user_id": userid, "intrest": interest, "flag": 'intrest'});
  }

  Future<http.Response> updateBooking(String bookingId, String status) async {
    var url = Uri.parse(Constraints.MANAGE_URL);
    return await http.post(url, body: {
      "booking_id": bookingId,
      "status": status,
      "flag": 'update_booking_data'
    });
  }
}
