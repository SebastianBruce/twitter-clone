/*

ACCOUNT SETTINGS PAGE

This page contains various settings related to user account.

- delete own account

*/

import 'package:flutter/material.dart';
import 'package:twitter_clone/services/auth/auth_service.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  // ask for confirmation before deleting their account
  void confirmDeletion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account?"),
        content: const Text(
          "Are you sure you want to delete your account? This cannot be undone.",
        ),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          // delete button
          TextButton(
            onPressed: () async {
              // delete account
              await AuthService().deleteAccount();

              // then navigate to initial route (Auth gate -> login / register page)
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // SCAFFOLD
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      // App Bar
      appBar: AppBar(
        title: Text("Account Settings"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),

      // Body
      body: Column(
        children: [
          // Delete tile
          GestureDetector(
            onTap: () => confirmDeletion(context),
            child: Container(
              padding: const EdgeInsets.all(25),
              margin: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "Delete Account",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
