class User {
  int userId;
  String name;
  String username;
  String email;
  String profileImageUrl;

  User({this.userId, this.username, this.name, this.email, this.profileImageUrl});

  User.fromJson(Map<String, dynamic> parsedJSON)
      : userId = parsedJSON['user_id'],
        username = parsedJSON['username'],
        name = parsedJSON['name'],
        email = parsedJSON['email'],
        profileImageUrl = parsedJSON['profile_img_url'];
}
