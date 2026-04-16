class AppConstants{
  AppConstants._();
  static const String cacheAccessToken = "cacheAccessToken";
  static const String cacheRefreshToken = "cacheRefreshToken";
  static const String cacheUserRole = "cacheUserRole";
  static const String cacheUser = "cacheUser";






















  static RegExp emailValidate = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  static bool validatePassword(String value) {
    RegExp regex = RegExp(r'^(?=.*[0-9])(?=.*[a-zA-Z]).{6,}$');
    return regex.hasMatch(value);
  }



}