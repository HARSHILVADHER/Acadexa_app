class TempStorage {
  static String? _userEmail;
  static String? _userName;
  
  static void setUserEmail(String email) {
    _userEmail = email;
  }
  
  static String? getUserEmail() {
    return _userEmail;
  }
  
  static void setUserName(String name) {
    _userName = name;
  }
  
  static String getUserName() {
    return _userName ?? 'User';
  }
}