/*

COMMENT TILE

This is the comment tile widget which belongs below a post. It's similar to the
post tile widget.

-------------------------------------------------------------------------------------------

To use this widget, you need:

— the comment
— a function (for when the user taps and wants to go to the user profile of this comment)

*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/models/comment.dart';
import 'package:twitter_clone/services/auth/auth_service.dart';
import 'package:twitter_clone/services/database/database_provider.dart';

class MyCommentTile extends StatelessWidget {
  final Comment comment;
  final void Function()? onUserTap;

  const MyCommentTile({
    super.key,
    required this.comment,
    required this.onUserTap,
  });

  // show options
  void _showOptions(BuildContext context) {
    // check if this post is owned by the user or not
    String currentUid = AuthService().getCurrentUid();
    final bool isOwnComment = comment.uid == currentUid;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              // this comment belongs to current user
              if (isOwnComment)
                // delete comment button
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text("Delete"),
                  onTap: () async {
                    // pop option box
                    Navigator.pop(context);

                    // handle delete action
                    await Provider.of<DatabaseProvider>(
                      context,
                      listen: false,
                    ).deleteComment(comment.id, comment.postId);
                  },
                )
              // this comment does NOT belong to current user
              else ...[
                // report comment button
                ListTile(
                  leading: const Icon(Icons.flag),
                  title: const Text("Report"),
                  onTap: () {
                    // pop option box
                    Navigator.pop(context);

                    // handle report action
                  },
                ),

                // block user button
                ListTile(
                  leading: const Icon(Icons.block),
                  title: const Text("Block User"),
                  onTap: () {
                    // pop option box
                    Navigator.pop(context);

                    // handle block action
                  },
                ),
              ],

              // cancel button
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text("Cancel"),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Padding outside
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),

      // Padding inside
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        // Color of post tile
        color: Theme.of(context).colorScheme.tertiary,

        // Curve corners
        borderRadius: BorderRadius.circular(8),
      ),
      // Column
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top section: profile pic / name / username
          GestureDetector(
            onTap: onUserTap,

            child: Row(
              children: [
                // profile pic
                Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                ),

                const SizedBox(width: 10),

                // name
                Text(
                  comment.name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(width: 5),

                // username handle
                Text(
                  '@${comment.username}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                const Spacer(),

                // buttons -> more options: delete
                GestureDetector(
                  onTap: () => _showOptions(context),
                  child: Icon(
                    Icons.more_horiz,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // message
          Text(
            comment.message,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ],
      ),
    );
  }
}
