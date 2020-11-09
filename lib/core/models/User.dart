import 'package:point_of_view/core/models/Event.dart';

class User {
  String id;
  String firstName;
  String lastName;
  String email;
  String password;
  String profileImage;
  int followersCount;
  int followingCount;
  List<String> followers;
  List<String> following;
  List<Event> attendedEvents;
  List<Event> createdEvents;
  List<Event> planningOnAttendingEvents;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.profileImage,
      this.attendedEvents,
      this.createdEvents,
      this.followers,
      this.following,
      this.planningOnAttendingEvents,
      this.followersCount,
      this.followingCount});

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'profile_image': profileImage,
        'followers': followers,
        'following': following,
        'attended_events': attendedEvents,
        'created_events': createdEvents,
        'planning_on_attending_events': planningOnAttendingEvents,
        'followersCount' : followersCount,
        'followingCount' : followingCount
      };
}
