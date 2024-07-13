import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static String userIdKey = "user_key";
  static String userNameKey = "user_name_key";
  static String userEmailKey = "user_email_key";
  static String userImageKey = "user_image_key";

  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userIdKey, getUserId);
  }
  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userNameKey, getUserName);
  }
  Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userEmailKey, getUserEmail);
  }
  Future<bool> saveUserImage(String getUserImage) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userImageKey, getUserImage);
  }

  Future<String?> getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userIdKey);
  }
  Future<String?> getUserName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userNameKey);
  }
  Future<String?> getUserEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userEmailKey);
  }
  Future<String?> getUserImage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userImageKey);
  }

}