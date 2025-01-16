import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tp3/AuthViewModel.dart';
import 'package:flutter_tp3/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  // final TextEditingController _specialityController = TextEditingController();
  File? _imageFile;  // To store the selected image file

final picker = ImagePicker();

// Function to pick image from gallery or camera
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Function to upload the selected image to Firebase Storage
  Future<String> _uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef.child('profile_pictures/${FirebaseAuth.instance.currentUser!.uid}.jpg');
      await imageRef.putFile(image);
      String downloadURL = await imageRef.getDownloadURL();
      return downloadURL; // Return the download URL of the uploaded image
    } catch (e) {
      print("Error uploading image: $e");
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<Authviewmodel>(context, listen: false);

// Get the current logged-in user's UID
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }

// Fetch user data from Firestore
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

return FutureBuilder<DocumentSnapshot>(
      future: userRef.get(),  // Fetch the user document
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
              centerTitle: true,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }

    if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
              centerTitle: true,
            ),
            body: Center(child: Text("Error loading profile")),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
              centerTitle: true,
            ),
            body: Center(child: Text("User data not found")),
          );
        }

// Extract user data from Firestore snapshot
        final userData = snapshot.data!;
        final username = userData['username'] ?? 'No name provided';
        final email = userData['email'] ?? 'No email provided';
        final photoUrl = userData['photoUrl'] ?? 'https://www.pngmart.com/files/23/Profile-PNG-Photo.png';
        final birthdate = userData['birthdate'] ?? '';
        final phone = userData['phone'] ?? '';
        final genre = userData['genre'] ?? '';
        // final speciality = userData['speciality'] ?? '';

// Set initial values for text fields
        _birthdateController.text = birthdate;
        _phoneController.text = phone;
        _genreController.text = genre;
        // _specialityController.text = speciality;

return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     'Profile',
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   centerTitle: true,
      //   backgroundColor: Colors.purple,
      // ),
      body: SingleChildScrollView(
            child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                
                GestureDetector(
                  onTap: _pickImage, // Allow tapping to pick an image
                  child: CircleAvatar(
                    radius: 80, // Increased size
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!) // Display the selected image
                        : NetworkImage(photoUrl) as ImageProvider,
                  backgroundColor: Colors.grey[300],
                ),
                ),
                const SizedBox(height: 16),

                // Username (centered)
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 28, // Larger font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Email (centered)
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),

                // Birthdate
                TextField(
                  controller: _birthdateController,
                  decoration: InputDecoration(
                    labelText: 'Birthdate',
                    hintText: 'Enter your birthdate',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(height: 16),

                // Phone
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    hintText: 'Enter your phone number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 16),

                // Genre
                TextField(
                  controller: _genreController,
                  decoration: InputDecoration(
                    labelText: 'Genre',
                    hintText: 'Enter your genre',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                ),
                const SizedBox(height: 16),

                // Speciality
                // TextField(
                //   controller: _specialityController,
                //   decoration: InputDecoration(
                //     labelText: 'Speciality',
                //     hintText: 'Enter your speciality',
                //     border: OutlineInputBorder(),
                //     prefixIcon: Icon(Icons.stars),
                //   ),
                // ),
                // const SizedBox(height: 32),

                // Save Button
                ElevatedButton(
                  onPressed: () async {

                    // Update Firestore document with new data
                    String newPhotoUrl = photoUrl;
                    if (_imageFile != null) {
                      // Upload the new image and get the URL
                      newPhotoUrl = await _uploadImage(_imageFile!);
                    }

                    // Update Firestore document with new data
                    await userRef.update({
                      'birthdate': _birthdateController.text,
                      'phone': _phoneController.text,
                      'genre': _genreController.text,
                      // 'speciality': _specialityController.text,
                      'photoUrl': newPhotoUrl, // Update photoUrl
                    });

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Profile updated successfully")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),

                const SizedBox(height: 16),

                // Logout Button (centered)
                ElevatedButton(
                  onPressed: () async {
                    await authViewModel.logout(context);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
      ),
    );
     },
    );
  }
}