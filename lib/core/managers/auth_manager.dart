import 'package:image_picker/image_picker.dart';
import 'package:rx_command/rx_command.dart';

abstract class AuthManager {
  RxCommand<void, PickedFile> getImage;
}

class AuthManagerImplementation implements AuthManager {
  @override
  RxCommand<void, PickedFile> getImage;

  final picker = ImagePicker();

  PickedFile file;

  AuthManagerImplementation() {
    getImage = RxCommand.createAsyncNoParam(() {
      return picker.getImage(source: ImageSource.gallery);
    });
  }
}
