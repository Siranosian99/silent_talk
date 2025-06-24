import 'package:image_picker/image_picker.dart';
import 'package:silent_talk/service/authenticator/authenticator.dart';
import 'package:silent_talk/service/database/sqflite_imagesave.dart';

class Picker{
  static final ImagePicker picker = ImagePicker();
  String? imgPath;
  XFile? pickedImage;

  Future<void> galleryPicker()async{
    pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      imgPath = pickedImage!.path;
      await ImageSaverOffline.savePhotoOffline(Authenticator.user!.uid, imgPath!);
      print('this is ImagePath:$imgPath');// Save it in your Picker class if needed

    }
    return null;
}
  // Future<XFile?> cameraPicker()async{
  //   pickedImage = await picker.pickImage(source: ImageSource.camera);
  //   return pickedImage;
  // }
  Future<void> cameraPicker()async{
    print('this is ImagePath:$imgPath');// Save it in your Picker class if needed
  }
}
