import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';
import 'package:silent_talk/service/authenticator/authenticator.dart';
import 'package:silent_talk/service/database/sqflite_imagesave.dart';

class Picker{
  static final ImagePicker picker = ImagePicker();
  String? imgPath;
  XFile? pickedImage;
  final cloudinary = CloudinaryPublic('dcmkerxac', 'silent_talk', cache: false);

  Future<XFile?> galleryPicker() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null && imgPath !=null) {
      imgPath = pickedImage.path;
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(imgPath!, resourceType: CloudinaryResourceType.Image),
      );
      print('-----------${imgPath}');// If imgPath is a class variable
      return pickedImage;

    }
    return null;
  }

  Future<XFile?> cameraPicker() async {
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      imgPath = pickedImage.path; // If imgPath is a class variable
      return pickedImage;
    }
    return null;
  }

  // Future<void> cameraPicker()async{
  //   print('this is ImagePath:$imgPath');// Save it in your Picker class if needed
  // }


//   Future<void> galleryPicker()async{
//     pickedImage = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       imgPath = pickedImage!.path;
//       await ImageSaverOffline.savePhotoOffline(Authenticator.user!.uid, imgPath!);
//       print('this is ImagePath:$imgPath');// Save it in your Picker class if needed
//
//     }
//     return null;
// }
}
