/*

FOLLOW LIST PAGE

This page displays a tab bar for ( a given uid ) :

— a list of all followers
— a list of all following

*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/models/user.dart';
import 'package:twitter_clone/services/database/database_provider.dart';

class FollowListPage extends StatefulWidget {
  final String uid;

  const FollowListPage({super.key, required this.uid});

  @override
  State<FollowListPage> createState() => _FollowListPageState();
}

class _FollowListPageState extends State<FollowListPage> {
  // providers
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider = Provider.of<DatabaseProvider>(
    context,
    listen: false,
  );

  // on startup
  @override
  void initState() {
    super.initState();

    // load follower list
    loadFollowerList();

    // load following list
    loadFollowingList();
  }

  // load followers
  Future<void> loadFollowerList() async {
    await databaseProvider.loadUserFollowerProfile(widget.uid);
  }

  // load following
  Future<void> loadFollowingList() async {
    await databaseProvider.loadUserFollowingProfile(widget.uid);
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // listen to followers & following
    final followers = listeningProvider.getListOfFollowersProfile(widget.uid);
    final following = listeningProvider.getListOfFollowingProfile(widget.uid);

    // TAB CONTROLLER
    return DefaultTabController(
      length: 2,

      // SCAFFOLD
      child: Scaffold(
        // App Bar
        appBar: AppBar(
          // Tab Bar
          bottom: TabBar(
            // Tabs
            tabs: [Text("Followers"), Text("Following")],
          ),
        ),

        // Body
        body: TabBarView(
          children: [
            _buildUserList(followers, "No followers."),
            _buildUserList(following, "No following."),
          ],
        ),
      ),
    );
  }

  // build user list, given a list of profiles
  Widget _buildUserList(List<UserProfile> userList, String emptyMessage) {
    return userList.isEmpty
        ?
          // empty message if there are no users
          Center(child: Text(emptyMessage))
        :
          // user list
          ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              // get each user
              final user = userList[index];

              // return as a user list tile
              return ListTile(title: Text(user.name));
            },
          );
  }
}
