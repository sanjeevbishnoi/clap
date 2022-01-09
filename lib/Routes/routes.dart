import 'package:flutter/material.dart';
import 'package:qvid/BottomNavigation/AddVideo/choose_music.dart';
import 'package:qvid/BottomNavigation/Explore/explore_page.dart';
import 'package:qvid/BottomNavigation/Explore/search_page.dart';
import 'package:qvid/BottomNavigation/Home/report_reel.dart';
import 'package:qvid/BottomNavigation/MyProfile/my_profile_page.dart';
import 'package:qvid/BottomNavigation/MyProfile/video_option.dart';
import 'package:qvid/BottomNavigation/Notifications/notification_messages.dart';
import 'package:qvid/BottomNavigation/bottom_navigation.dart';
import 'package:qvid/BottomNavigation/AddVideo/add_video.dart';
import 'package:qvid/BottomNavigation/MyProfile/followers.dart';
import 'package:qvid/BottomNavigation/AddVideo/post_info.dart';

import 'package:qvid/Screens/applied_details.dart';
import 'package:qvid/Screens/auth/basic_profile_details.dart';
import 'package:qvid/Screens/auth/choice_talent_interst.dart';
import 'package:qvid/Screens/auth/login.dart';
import 'package:qvid/Screens/auth/otp_screen.dart';
import 'package:qvid/Screens/auth/detail.dart';
import 'package:qvid/Screens/auth/persional_details.dart';
import 'package:qvid/Screens/auth/report_profile.dart';
import 'package:qvid/Screens/auth/setting_page.dart';
import 'package:qvid/Screens/auth/show_periosnal_info.dart';
import 'package:qvid/Screens/auth/social_media_detail.dart';
import 'package:qvid/Screens/auth/user_category_list.dart';
import 'package:qvid/Screens/auth/wishlist_users.dart';
import 'package:qvid/Screens/booking/all_celebrity_list.dart';
import 'package:qvid/Screens/booking/booking.dart';
import 'package:qvid/Screens/booking/wishesh_booking_list.dart';
import 'package:qvid/Screens/broadcast/broadcast_page.dart';
import 'package:qvid/Screens/chat/chat_details.dart';
import 'package:qvid/Screens/chat/conversation_screen.dart';
import 'package:qvid/Screens/chat/search_chat_user.dart';
import 'package:qvid/Screens/directory/directory_list.dart';
import 'package:qvid/Screens/dummy_container_screen.dart';
import 'package:qvid/Screens/newuser/new_user_full_view.dart';
import 'package:qvid/Screens/post/add_post_screen.dart';
import 'package:qvid/Screens/post_full_view.dart';
import 'package:qvid/Screens/refer&earn/referearn_page.dart';

import 'package:qvid/Screens/user_profile.dart';
import 'package:qvid/Screens/userprofile/filter_page.dart';
import 'package:qvid/Screens/userprofile/user_profile.dart';
import 'package:qvid/Screens/view_all_post.dart';
import 'package:qvid/Screens/workshop/workshop_literature.dart';

class PageRoutes {
  static const String loginNavigator = 'login_navigator';
  static const String bottomNavigation = 'bottom_navigation';
  static const String followersPage = 'followers_page';
  static const String helpPage = 'help_page';
  static const String tncPage = 'tnc_page';
  static const String searchPage = 'search_page';
  static const String addVideoPage = 'add_video_page';
  static const String addVideoFilterPage = 'add_video_filter_page';
  static const String postInfoPage = 'post_info_page';
  static const String userProfilePage = 'user_profile_page';
  static const String chatPage = 'chat_page';
  static const String morePage = 'more_page';
  static const String videoOptionPage = 'video_option_page';
  static const String verifiedBadgePage = 'verified_badge_page';
  static const String languagePage = 'language_page';
  static const String mycontainer = "my_container";
  static const String allPostList = "all_post";
  static const String notification = "notification";
  static const String otp_screen = "otp";
  static const String explore = "explore";
  static const String personal_info = "personal_info";
  static const String social_media_info = "social_media";
  static const String basic_profile_info = "basic_profile";
  static const String choose_talent = "chooose_talent";
  static const String post_full_view = "post_full_view";
  static const String applied_details = "applied_details";
  static const String conversation_screen = "conversation";
  static const String chat_details = "chat";
  static const String login_screen = "login";
  static const String choose_music = "music";
  static const String add_post = "add_post";
  static const String search_user = "search_user";
  static const String avaliable_categories = "avaliable_categories";
  static const String directory_screen = "directory_screen";
  static const String setting_page = "setting_screen";
  static const String booking_history = "booking_history";
  static const String testimonial = "testimonial";
  static const String add_testimonial = "add_testimonial";
  static const String show_persional_info = "persional_info";
  static const String search_page = "search_page";
  static const String persional_details = "persional_details";
  static const String broadcastPage = "broadcastPage";
  static const String allCelebrityList = "allCelebrityList";
  static const String wishlistUsers = "wishlistUsers";
  static const String reportOnProfile = "reportOnProfile";
  static const String workshop = "workshop";
  static const String refer_earn = "refer_earn";
  static const String myProfile = "my_profile";
  static const String userProfile = "user_profile";
  static const String filterPage = "filter_page";
  static const String newUserPage = "new_user_page";
  static const String bookingList = "booking_list";
  static const String reportReels = "report_reels";

  Map<String, WidgetBuilder> routes() {
    return {
      bottomNavigation: (context) => BottomNavigation(),
      //followersPage: (context) => FollowersPage(),

      addVideoPage: (context) => AddVideo(),
      //addVideoFilterPage: (context) => AddVideoFilter(),
      //postInfoPage: (context) => PostInfo(),

      videoOptionPage: (context) => VideoOptionPage(),

      mycontainer: (context) => MyContainer(),
      allPostList: (context) => AllPostList(),
      notification: (context) => NotificationMessages(),
      otp_screen: (context) => OtpScreen(),
      explore: (context) => ExplorePage(),
      personal_info: (context) => UserPersonalInfo(),
      social_media_info: (context) => SocialMediaDetails(),
      basic_profile_info: (context) => BasicProfile(),
      choose_talent: (context) => ChoiceTalent(),
      post_full_view: (context) => PostFullViewDetails(),
      applied_details: (context) => AppliedDetails(),
      conversation_screen: (context) => ConverationChats(),
      //chat_details: (context) => ChatScreen(),
      login_screen: (context) => LoginScreen(),
      choose_music: (context) => ChooseMusic(),
      add_post: (context) => AddPost(),
      userProfilePage: (context) => UserProfilePage(),
      search_user: (context) => SearchUsers(),
      avaliable_categories: (context) => AvaliableCategoryList(),
      directory_screen: (context) => DirectoryScreen(),
      setting_page: (context) => SettingPage(),
      booking_history: (context) => BookingHistory(),

      show_persional_info: (context) => ShowPersonalInfo(data: {}),
      search_page: (context) => SearchPage(),
      persional_details: (context) => UpdatePersionalDetails(),
      broadcastPage: (context) => BroadcastPage(),
      allCelebrityList: (context) => AllCelebrityList(),
      wishlistUsers: (context) => WishlistUsers(),
      reportOnProfile: (context) => ReportOnProfile(),
      workshop: (context) => WorkshopPage(),
      refer_earn: (context) => ReferAndEarnPage(),
      myProfile: (context) => MyProfileBody(),
      userProfile: (context) => UserProfile(),
      filterPage: (context) => FilterPage(),
      newUserPage: (context) => NewUserFullView(),

      reportReels: (context) => ReportOnReel()
    };
  }
}
