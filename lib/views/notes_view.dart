import 'package:flutter/material.dart';
import 'package:notetaker/enums/menu_actions.dart';
import 'package:notetaker/services/auth/auth_service.dart';
import 'dart:developer' as devtools show log;

import '../constants/routes.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}



class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main UI"),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogoutDialog(context);
                  devtools.log(shouldLogout.toString());

                  if (shouldLogout) {
                  await  AuthService.firebase().logOut();

                    if (mounted) {
                      await Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute, (route) => false);
                    }
                  } else {
                    devtools.log("user cancelled logout option");
                  }

                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("Logout"),
                ),
              ];
            },
          )
        ],
      ),
      body: const Text("Hellow World"),
    );
  }

  Future<bool> showLogoutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext dialogueContext) {
        return AlertDialog(
          title: const Text("Sign Out"),
          content: const Text("Are you sure you want to logout"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(dialogueContext).pop(false);
                },
                child: const Text("cancel")),
            TextButton(
              onPressed: () {
                Navigator.of(dialogueContext).pop(true);
              },
              child: const Text("Logout"),
            )
          ],
        );
      },
    ).then((value) => value ?? false);
  }
}
