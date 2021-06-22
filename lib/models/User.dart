
class UserAccount {
  String userId;
  String name;
  String username;
  String email;
  String profileImageUrl;

  UserAccount(
      {required this.userId,
      required this.username,
      required this.name,
      required this.email,
      required this.profileImageUrl});

  // User.fromJson(Map<String, dynamic> parsedJSON)
  //     : userId = parsedJSON['user_id'],
  //       username = parsedJSON['username'],
  //       name = parsedJSON['name'],
  //       email = parsedJSON['email'],
  //       profileImageUrl = parsedJSON['profile_img_url'];

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
        userId: json['user_id'],
        name: json['name'],
        username: json['username'],
        email: json['email'],
        profileImageUrl: json['profile_img_url']);
  }

}
