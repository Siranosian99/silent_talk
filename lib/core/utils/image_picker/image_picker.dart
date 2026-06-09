import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:silent_talk/features/auth/services/authenticator.dart';

class Picker with ChangeNotifier{
  static final ImagePicker picker = ImagePicker();
  String? imgPath;
  XFile? pickedImage;
  bool isImage=false;
  bool isPressed=false;
  final cloudinary = CloudinaryPublic('dcmkerxac', 'silent_talk', cache: false);

  Future<String?> galleryPicker() async {
    try {
      pickedImage = await picker.pickImage(source: ImageSource.gallery);

      // if (pickedImage != null && isPressed) {
      //   imgUploaderToServer(pickedImage!.path);
      //   print("Uploaded to Server ${pickedImage?.path}");
      // imgPath = pickedImage?.path;
      // CloudinaryResponse response = await cloudinary.uploadFile(
      //   CloudinaryFile.fromFile(
      //     imgPath ?? '',
      //     resourceType: CloudinaryResourceType.Image,
      //   ),
      // );
      // print('Uploaded image URL: ${response.secureUrl}');
      // imgPath = response.secureUrl;
      imgPath = pickedImage?.path;
      imgPath!.isNotEmpty ? isImage = true : isImage = false;
      notifyListeners();
      print(isImage);

      print("------------------------IMAGE PATH:$imgPath");
      return imgPath; // Return the Cloudinary link

    } catch (e) {
      print('Error uploading image: $e');
    }
    return null; // No image picked or upload failed
  }
  Future<String?> imgUploaderToServer(String imgPath)async{
    final compressedImage =
    await FlutterImageCompress.compressAndGetFile(
      imgPath,
      '${imgPath}_compressed.jpg',
      quality: 90,
      minWidth: 2000,
      minHeight: 2000,
    );

    if (compressedImage == null) {
      return null;
    }
    CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          compressedImage.path,
          resourceType: CloudinaryResourceType.Image,
        )
    );
    imgPath=response.secureUrl;
    return imgPath;
    print('================Succses');
    print('Uploaded image URL: ${response.secureUrl}');
    print('================Succses');

  }
  void clearImage() {
    imgPath = '';
    pickedImage = null;
    isImage = false;
    notifyListeners();

  }


  Future<String?> cameraPicker() async {
    try {
      pickedImage = await picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        final localPath = pickedImage?.path;
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(
            localPath ?? '',
            resourceType: CloudinaryResourceType.Image,
          ),
        );
        imgPath=response.secureUrl;
        imgPath!.isNotEmpty ?isImage=true: isImage=false;
        print(isImage);
        print('Uploaded image URL: ${response.secureUrl}');
        notifyListeners();
        return imgPath; // Return the Cloudinary link

      }
    } catch (e) {
      print('Error uploading image: $e');
    }
    return null; // No image picked or upload failed
  }
  // bool isImageChanger(bool isImage){
  //   isImage= !isImage;
  //   print(isImage);
  //   return isImage;
  // }
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
