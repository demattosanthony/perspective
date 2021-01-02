import 'package:image_picker/image_picker.dart';
import 'package:rx_command/rx_command.dart';

abstract class AuthManager {
  RxCommand<void, String> getImage;
}

class AuthManagerImplementation implements AuthManager {
  @override
  RxCommand<void, String> getImage;

  final picker = ImagePicker();

  PickedFile file;

  AuthManagerImplementation() {
    getImage = RxCommand.createAsyncNoParam(() async {
      PickedFile file = await picker.getImage(source: ImageSource.gallery);
      return file.path;
    });
  }
}
