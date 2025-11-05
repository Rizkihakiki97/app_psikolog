// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class ImagePickerPage extends StatefulWidget {
//   const ImagePickerPage({super.key});

//   @override
//   State<ImagePickerPage> createState() => _ImagePickerPageState();
// }

// class _ImagePickerPageState extends State<ImagePickerPage> {
//   File? _image;
//   final ImagePicker _picker = ImagePicker(); // instance image_picker

//   Future<void> pickImage() async {
//     // gunakan instance _picker dan tipe XFile
//     final XFile? pickedFile = await _picker.pickImage(
//       source: ImageSource.gallery,
//     );

//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Test Image Picker")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _image == null
//                 ? const Text("Belum ada gambar")
//                 : Image.file(_image!, height: 200),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: pickImage,
//               child: const Text("Pilih Gambar"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
