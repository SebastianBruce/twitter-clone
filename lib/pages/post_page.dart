/*

POST PAGE

This page displays:

- individual post
— comments on this post

*/

import 'package:flutter/material.dart';
import 'package:twitter_clone/components/my_post_tile.dart';
import 'package:twitter_clone/helper/navigate_pages.dart';
import 'package:twitter_clone/models/post.dart';

class PostPage extends StatefulWidget {
  final Post post;

  const PostPage({super.key, required this.post});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // SCAFFOLD
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      // App Bar
      appBar: AppBar(foregroundColor: Theme.of(context).colorScheme.primary),

      // Body
      body: ListView(
        children: [
          // Post
          MyPostTile(
            post: widget.post,
            onUserTap: () => goUserPage(context, widget.post.uid),
            onPostTap: () {},
          ),

          // Comments on this post
        ],
      ),
    );
  }
}
