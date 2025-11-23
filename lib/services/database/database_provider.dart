/*

DATABASE PROVIDER

This provider is to separate the firestore data handling and the UI of our app.

------------------------------------------------------------------------------------------------

— The database service class handles data to and from firebase
— The database provider class processes the data to display in our app

This is to make our code much more modular, cleaner, and easier to read and test.
Particularly as the number of pages grow, we need this provider to properly manage
the different states of the app.

- Also, if one day, we decide to change our backend (from firebase to something use)
then it's much easier to manage and switch out different databases.

*/

import 'package:flutter/material.dart';
import 'package:twitter_clone/models/post.dart';
import 'package:twitter_clone/models/user.dart';
import 'package:twitter_clone/services/auth/auth_service.dart';
import 'package:twitter_clone/services/database/database_service.dart';

class DatabaseProvider extends ChangeNotifier {
  /*

  SERVICES

  */

  // get db & auth service
  final _db = DatabaseService();
  final _auth = AuthService();

  /*

  USER PROFILE

  */

  // get user profile given uid
  Future<UserProfile?> userProfile(String uid) => _db.getUserFromFirebase(uid);

  // update user bio
  Future<void> updateBio(String bio) => _db.updateUserBioInFirebase(bio);

  /*

  POSTS

  */

  // local list of posts
  List<Post> _allPosts = [];

  // get posts
  List<Post> get allPosts => _allPosts;

  // post message
  Future<void> postMessage(String message) async {
    // post message in firebase
    await _db.postMessageInFirebase(message);

    // reload data from firebase
    await loadAllPosts();
  }

  // fetch all posts
  Future<void> loadAllPosts() async {
    // get all posts from firebase
    final allPosts = await _db.getAllPostsFromFirebase();

    // update local data
    _allPosts = allPosts;

    // initialize local like data
    initializeLikeMap();

    // update UI
    notifyListeners();
  }

  // filter and return posts given uid
  List<Post> filterUserPosts(String uid) {
    return _allPosts.where((post) => post.uid == uid).toList();
  }

  // delete post
  Future<void> deletePost(String postId) async {
    // delete from firebase
    await _db.deletePostFromFirebase(postId);

    // reload data from firebase
    await loadAllPosts();
  }

  /*

  LIKES

  */

  // Local map to track like counts for each post
  Map<String, int> _likeCounts = {
    // for each post id: like count
  };

  // Local list to track posts liked by current user
  List<String> _likedPosts = [];

  // has the current user liked this post
  bool isPostLikedByCurrentUser(String postId) => _likedPosts.contains(postId);

  // get like count of a post
  int getLikeCount(String postId) => _likeCounts[postId] ?? 0;

  // initialize like map locally
  void initializeLikeMap() {
    // get current uid
    final currentUserId = _auth.getCurrentUid();

    // clear liked posts
    _likedPosts.clear();

    // for each post get like data
    for (var post in _allPosts) {
      // update like count map
      _likeCounts[post.id] = post.likeCount;

      // if the current user already liked this post
      if (post.likedBy.contains(currentUserId)) {
        // add this post id to local list of liked posts
        _likedPosts.add(post.id);
      }
    }
  }

  // toggle like
  Future<void> toggleLike(String postId) async {
    /*

    This first part will update the local values first so that the UI feels
    immediate and responsive. We will update the UI optimistically, and revert
    back if anything goes wrong while writing to the database

    */

    // store original values in case it fails
    final likedPostsOriginal = _likedPosts;
    final likeCountsOriginal = _likeCounts;

    // perform like / unlike
    if (_likedPosts.contains(postId)) {
      _likedPosts.remove(postId);
      _likeCounts[postId] = (_likeCounts[postId] ?? 0) - 1;
    } else {
      _likedPosts.add(postId);
      _likeCounts[postId] = (_likeCounts[postId] ?? 0) + 1;
    }

    // update UI locally
    notifyListeners();

    /*

    Now update in database

    */

    // attempt like in database
    try {
      await _db.toggleLikeInFirebase(postId);
    }
    // revert back to initial state if update fails
    catch (e) {
      _likedPosts = likedPostsOriginal;
      _likeCounts = likeCountsOriginal;

      // update UI again
      notifyListeners();
    }
  }
}
