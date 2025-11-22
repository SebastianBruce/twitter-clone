/*

DATABASE SERVICE

This class handles all the data from and to firebase.

----------------------------------------------------------------------------

— User profile
- Post message
- Likes
- Comments
- Account stuff ( report / block / delete account )
- Follow / unfollow
- Search users

*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_clone/models/user.dart';
import 'package:twitter_clone/services/auth/auth_service.dart';

class DatabaseService {
  // get instance of firebase db & auth
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /*

  USER PROFILE

  When a new user registers, we create an account for them and store their 
  details in the database to display in the app

  */

  // save user info
  Future<void> saveUserInfoInFirebase({
    required String name,
    required String email,
  }) async {
    // get current uid
    String uid = _auth.currentUser!.uid;

    // extract username from email
    String username = email.split('@')[0];

    // create a user profile
    UserProfile user = UserProfile(
      uid: uid,
      name: name,
      email: email,
      username: username,
      bio: '',
    );

    // convert user into a map so that we can store in firebase
    final userMap = user.toMap();

    // save user info in firebase
    await _db.collection("Users").doc(uid).set(userMap);
  }

  // get user info
  Future<UserProfile?> getUserFromFirebase(String uid) async {
    try {
      // retrieve user doc from firebase
      DocumentSnapshot userDoc = await _db.collection("Users").doc(uid).get();

      // convert doc to user profile
      return UserProfile.fromDocument(userDoc);
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Update user bio
  Future<void> updateUserBioInFirebase(String bio) async {
    // get current uid
    String uid = AuthService().getCurrentUid();

    // attempt to update in firebase
    try {
      await _db.collection("Users").doc(uid).update({'bio': bio});
    } catch (e) {
      print(e);
    }
  }

  /*

  POST MESSAGE

  */

  /*

  LIKES

  */

  /*

  COMMENTS

  */

  /*

  ACCOUNT STUFF

  */

  /*

  FOLLOW

  */

  /*

  SEARCH

  */
}
