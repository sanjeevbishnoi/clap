class UserVideo {
  late final String id;
  late final String userId;
  late final String audioId;
  late final String title;
  late final String videoName;
  late final String status;
  late final String deleteStatus;
  late final String date;

  late final String time;
  late final String description;
  late final String coverImage;
  String? likes;
  late final String comment;
  late final String share;
  bool? likeStatus;
  String? reelsView;

  UserVideo(
      {required this.id,
      required this.userId,
      required this.audioId,
      required this.title,
      required this.videoName,
      required this.status,
      required this.deleteStatus,
      required this.date,
      required this.time,
      required this.description,
      required this.coverImage,
      required this.likes,
      required this.comment,
      required this.share,
      required this.likeStatus,
      required this.reelsView});

  UserVideo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    audioId = json['audio_id'];
    title = json['title'];
    videoName = json['video_name'];
    status = json['status'];
    deleteStatus = json['delete_status'];
    date = json['date'];
    time = json['time'];
    description = json['description'];
    coverImage = json['cover_image'];
    likes = json['likes'];
    comment = json['comment'];
    share = json['share'];
    likeStatus = json['like_status'];
    reelsView = json['reels_view'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['user_id'] = userId;
    _data['audio_id'] = audioId;
    _data['title'] = title;
    _data['video_name'] = videoName;
    _data['status'] = status;
    _data['delete_status'] = deleteStatus;
    _data['date'] = date;
    _data['time'] = time;
    _data['description'] = description;
    _data['cover_image'] = coverImage;
    _data['likes'] = likes;
    _data['comment'] = comment;
    _data['share'] = share;
    _data['like_status'] = likeStatus;
    return _data;
  }
}
