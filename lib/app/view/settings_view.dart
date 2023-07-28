import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../utils/constants.dart';
import '../../utils/routes/navigations.dart';
import '../view_model/bottom_bar_provider.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            
            children: [
              ElevatedButton.icon(
                onPressed: () {
                   signOut(context);
                },
                icon: const Icon(Icons.logout),
                label: const Text('LogOut'),
              )
            ],
          ),
        ),
      ),
    );
  }
   void signOut(BuildContext context) {

    FirebaseAuth.instance.signOut().then((value) {
      AccessToken.clearAccessToken();
      GoogleSignIn().disconnect();
      Navigator.of(context).popAndPushNamed(
          NavigatorClass.loginScreen);
      Provider.of<BottomBarProvider>(context, listen: false)
          .changeBottomNavindex(0);
    });
  }
}

