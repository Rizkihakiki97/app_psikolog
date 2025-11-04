// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class FeaturedPsychologistsPage extends StatefulWidget {
//   const FeaturedPsychologistsPage({super.key});

//   @override
//   State<FeaturedPsychologistsPage> createState() =>
//       _FeaturedPsychologistsPageState();
// }

// class _FeaturedPsychologistsPageState extends State<FeaturedPsychologistsPage> {
//   final List<Map<String, dynamic>> _psychologists = [];

//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _specialistController = TextEditingController();
//   final TextEditingController _experienceController = TextEditingController();
//   final TextEditingController _ratingController = TextEditingController();
//   File? _selectedImage;
//   bool _isActive = true;
//   int? _editIndex;

//   Future<void> _pickImage() async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       setState(() {
//         _selectedImage = File(picked.path);
//       });
//     }
//   }

//   void _addOrEditPsychologist() {
//     if (_formKey.currentState!.validate()) {
//       final newData = {
//         'name': _nameController.text,
//         'specialist': _specialistController.text,
//         'experience': _experienceController.text,
//         'rating': _ratingController.text,
//         'isActive': _isActive,
//         'image': _selectedImage,
//       };

//       setState(() {
//         if (_editIndex == null) {
//           _psychologists.add(newData);
//         } else {
//           _psychologists[_editIndex!] = newData;
//           _editIndex = null;
//         }
//         _resetForm();
//       });
//       Navigator.pop(context);
//     }
//   }

//   void _resetForm() {
//     _nameController.clear();
//     _specialistController.clear();
//     _experienceController.clear();
//     _ratingController.clear();
//     _selectedImage = null;
//     _isActive = true;
//   }

//   void _showForm({int? index}) {
//     if (index != null) {
//       final data = _psychologists[index];
//       _nameController.text = data['name'];
//       _specialistController.text = data['specialist'];
//       _experienceController.text = data['experience'];
//       _ratingController.text = data['rating'];
//       _selectedImage = data['image'];
//       _isActive = data['isActive'];
//       _editIndex = index;
//     }

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//           left: 20,
//           right: 20,
//           top: 20,
//         ),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   _editIndex == null ? "Add Psychologist" : "Edit Psychologist",
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 GestureDetector(
//                   onTap: _pickImage,
//                   child: CircleAvatar(
//                     radius: 40,
//                     backgroundColor: Colors.grey.shade300,
//                     backgroundImage: _selectedImage != null
//                         ? FileImage(_selectedImage!)
//                         : null,
//                     child: _selectedImage == null
//                         ? const Icon(Icons.add_a_photo, color: Colors.white)
//                         : null,
//                   ),
//                 ),
//                 const SizedBox(height: 15),

//                 TextFormField(
//                   controller: _nameController,
//                   decoration: const InputDecoration(labelText: "Doctor Name"),
//                   validator: (value) =>
//                       value!.isEmpty ? 'Enter doctor name' : null,
//                 ),
//                 TextFormField(
//                   controller: _specialistController,
//                   decoration: const InputDecoration(labelText: "Specialist"),
//                   validator: (value) =>
//                       value!.isEmpty ? 'Enter specialist' : null,
//                 ),
//                 TextFormField(
//                   controller: _experienceController,
//                   decoration: const InputDecoration(
//                     labelText: "Experience (years)",
//                   ),
//                   validator: (value) =>
//                       value!.isEmpty ? 'Enter experience' : null,
//                 ),
//                 TextFormField(
//                   controller: _ratingController,
//                   decoration: const InputDecoration(
//                     labelText: "Rating (e.g. 4.9)",
//                   ),
//                   validator: (value) => value!.isEmpty ? 'Enter rating' : null,
//                 ),

//                 SwitchListTile(
//                   title: const Text("Active Status"),
//                   value: _isActive,
//                   onChanged: (val) => setState(() => _isActive = val),
//                   activeColor: Colors.green,
//                 ),

//                 const SizedBox(height: 15),
//                 ElevatedButton(
//                   onPressed: _addOrEditPsychologist,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blueAccent,
//                     minimumSize: const Size(double.infinity, 45),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: Text(_editIndex == null ? "Add" : "Save Changes"),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _deletePsychologist(int index) {
//     setState(() {
//       _psychologists.removeAt(index);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Featured Psychologists"),
//         backgroundColor: const Color(0xFF3D8BFF),
//         centerTitle: true,
//       ),
//       body: _psychologists.isEmpty
//           ? const Center(child: Text("No psychologists added yet."))
//           : ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: _psychologists.length,
//               itemBuilder: (context, index) {
//                 final p = _psychologists[index];
//                 return Container(
//                   margin: const EdgeInsets.only(bottom: 15),
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 6,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       CircleAvatar(
//                         radius: 28,
//                         backgroundImage: p['image'] != null
//                             ? FileImage(p['image'])
//                             : const AssetImage('assets/default_avatar.png')
//                                   as ImageProvider,
//                       ),
//                       const SizedBox(width: 15),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               p['name'],
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             Text(
//                               p['specialist'],
//                               style: const TextStyle(color: Colors.grey),
//                             ),
//                             const SizedBox(height: 4),
//                             Row(
//                               children: [
//                                 const Icon(
//                                   Icons.star,
//                                   color: Colors.amber,
//                                   size: 18,
//                                 ),
//                                 Text(
//                                   " ${p['rating']}  •  ${p['experience']} years",
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       Icon(
//                         Icons.circle,
//                         color: p['isActive'] ? Colors.green : Colors.grey,
//                         size: 14,
//                       ),
//                       PopupMenuButton<String>(
//                         onSelected: (value) {
//                           if (value == 'edit') {
//                             _showForm(index: index);
//                           } else if (value == 'delete') {
//                             _deletePsychologist(index);
//                           }
//                         },
//                         itemBuilder: (context) => [
//                           const PopupMenuItem(
//                             value: 'edit',
//                             child: Text('Edit'),
//                           ),
//                           const PopupMenuItem(
//                             value: 'delete',
//                             child: Text('Delete'),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showForm(),
//         backgroundColor: const Color(0xFF3D8BFF),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
