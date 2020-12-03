import 'package:point_of_view/core/enums/viewstate.dart';
import 'package:point_of_view/core/services/auth_service.dart';
import 'package:point_of_view/core/services/cloud_firestore_service.dart';
import 'package:point_of_view/core/viewmodels/base_model.dart';
import '../../locator.dart';

class ProfileModel extends BaseModel {
  final AuthService _authService = locator<AuthService>();
  //final CloudFirestoreService _cloudfirestoreService =
    //  locator<CloudFirestoreService>();
  String _profileImage;
  //DocumentSnapshot _user;

  String get profileImage => _profileImage;
  //DocumentSnapshot get user => _user;

  void getUserInfo() async {
    setState(ViewState.Busy);
    //_user = await _cloudfirestoreService.getUserInfo();
    setState(ViewState.Idle);
  }

  void getImage() async {
    setState(ViewState.Busy);

    //_profileImage = await _cloudfirestoreService.getProfileImage();

    setState(ViewState.Idle);
  }

  void signOut() async {
    setState(ViewState.Busy);
    setState(ViewState.Idle);
  }

  ProfileModel() {
    this.getImage();
    this.getUserInfo();
  }
}
