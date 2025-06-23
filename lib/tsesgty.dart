// // Imports
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
//
// class ImageTaskManager {
//   late Database _db;
//
//   Future<void> init() async {
//     final dbPath = await getDatabasesPath();
//     _db = await openDatabase(
//       join(dbPath, 'images.db'),
//       version: 1,
//       onCreate: (db, version) {
//         return db.execute(
//           'CREATE TABLE images(id TEXT PRIMARY KEY, file_path TEXT)',
//         );
//       },
//     );
//   }
//
//   Future<String?> pickAndSaveImage() async {
//     final picker = ImagePicker();
//     final picked = await picker.pickImage(source: ImageSource.gallery);
//     if (picked == null) return null;
//
//     final appDir = await getApplicationDocumentsDirectory();
//     final fileName = 'img_${DateTime.now().millisecondsSinceEpoch}.jpg';
//     final savedImage = await File(picked.path).copy('${appDir.path}/$fileName');
//
//     final imageId = fileName.split('.').first;
//     await _db.insert('images', {
//       'id': imageId,
//       'file_path': savedImage.path,
//     });
//
//     return imageId;
//   }
//
//   Future<void> saveTaskToFirestore(String task, String? imageId) async {
//     await FirebaseFirestore.instance.collection('tasks').add({
//       'task': task,
//       'date': Timestamp.now(),
//       'image_id': imageId,
//     });
//   }
//
//   Future<File?> getImageFileById(String imageId) async {
//     final result = await _db.query('images', where: 'id = ?', whereArgs: [imageId]);
//     if (result.isNotEmpty) {
//       final path = result.first['file_path'] as String;
//       return File(path);
//     }
//     return null;
//   }
// }
//
// // Example UI usage
// class TaskUploader extends StatefulWidget {
//   @override
//   _TaskUploaderState createState() => _TaskUploaderState();
// }
//
// class _TaskUploaderState extends State<TaskUploader> {
//   final controller = TextEditingController();
//   final manager = ImageTaskManager();
//   String? imageId;
//
//   @override
//   void initState() {
//     super.initState();
//     manager.init();
//   }
//
//   void handlePickImage() async {
//     final id = await manager.pickAndSaveImage();
//     setState(() => imageId = id);
//   }
//
//   void handleSave() async {
//     if (controller.text.isNotEmpty) {
//       await manager.saveTaskToFirestore(controller.text, imageId);
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved!')));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         TextField(controller: controller, decoration: InputDecoration(labelText: 'Task')),
//         ElevatedButton(onPressed: handlePickImage, child: Text('Pick Image')),
//         ElevatedButton(onPressed: handleSave, child: Text('Save Task')),
//       ],
//     );
//   }
// }
