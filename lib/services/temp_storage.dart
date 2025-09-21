class TempStorage {
  static String? _userEmail;
  static String? _userName;
  
  static void setUserEmail(String email) {
    _userEmail = email.isEmpty ? null : email;
  }
  
  static String? getUserEmail() {
    return _userEmail;
  }
  
  static void setUserName(String name) {
    _userName = name == 'User' ? null : name;
  }
  
  static String getUserName() {
    return _userName ?? 'User';
  }
  
  static void clearAll() {
    _userEmail = null;
    _userName = null;
  }
}