import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  final User user;

  ProfileScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: getUserProfile(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        final userProfile = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Center(
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.blue,
                    backgroundImage: userProfile != null && userProfile['profilePicture'] != null
                        ? NetworkImage(userProfile['profilePicture'])
                        : null,
                    child: userProfile == null || userProfile['profilePicture'] == null
                        ? Icon(Icons.person, size: 80, color: Colors.white)
                        : null,
                  ),
                ),
                SizedBox(height: 20),
                ListTile(
                  title: Text(
                    'Name:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    userProfile?['name'] ?? 'N/A',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Email:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    userProfile?['email'] ?? 'N/A',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfileScreen(user: user)),
                      );
                    },
                    child: Text('Edit Profile'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userProfile = prefs.getString(userId);
    if (userProfile != null && userProfile.isNotEmpty) {
      return Map<String, dynamic>.from(jsonDecode(userProfile));
    }
    return null;
  }
}
