import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_task/sign_in_screen.dart';
import 'package:mobile_task/profile_screen.dart';

class AuthenticationScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<User?>(
          stream: _auth.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasData && snapshot.data != null) {
              return ProfileScreen(user: snapshot.data!);
            } else if (snapshot.hasError) {
              return Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              );
            } else {
              return _buildSignInButton(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Welcome to My App',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignInScreen()),
          ),
          child: Text('Sign In'),
        ),
        SizedBox(height: 10),
        TextButton(
          onPressed: () {

          },
          child: Text('Create an Account'),
        ),
      ],
    );
  }
}
