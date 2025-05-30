import 'package:image_picker/image_picker.dart';

class Picker{
  final ImagePicker picker = ImagePicker();
  XFile? pickedImage;

  Future<XFile?> galleryPicker()async{
    pickedImage = await picker.pickImage(source: ImageSource.gallery);
    return pickedImage;
}
  Future<XFile?> cameraPicker()async{
    pickedImage = await picker.pickImage(source: ImageSource.camera);
    return pickedImage;
  }
}
