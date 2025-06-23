import 'package:image_picker/image_picker.dart';

class Picker{
  static final ImagePicker picker = ImagePicker();
  String? imgPath;
  XFile? pickedImage;

  Future<void> galleryPicker()async{
    pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      imgPath = pickedImage!.path;
      print('this is ImagePath:$imgPath');// Save it in your Picker class if needed

    }
    return null;
}
  Future<XFile?> cameraPicker()async{
    pickedImage = await picker.pickImage(source: ImageSource.camera);
    return pickedImage;
  }
}
