

import 'package:carcareservice/app/model/center_profile_model.dart';
import 'package:carcareservice/app/view_model/bottom_bar_provider.dart';

import 'package:carcareservice/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';


import '../../utils/routes/navigations.dart';


class CenterProfileProvider with ChangeNotifier {

CenterProfileProvider(){
getCenterProfileData();
}
 TextEditingController nameCtrl = TextEditingController();
  TextEditingController mailCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();

  FirebaseFirestore db=FirebaseFirestore.instance; 



  /*updateData(BuildContext context)async {
    final navigator=Navigator.of(context);
    final id=await AccessToken.getAccessToken();
    final profileData=setData();
    profileData.id=id;
    await db.collection('user').doc(id).set(profileData.toJson()).then((value){
     SnackBarWidget.snackBar(context, 'User Details Updated');
     navigator.pop();
     notifyListeners();
    });
    notifyListeners();
  }*/
  final auth = FirebaseAuth.instance;
  ServiceCenter? _userProfileData;

  bool _isLoading = false;

  ServiceCenter? get userProfileData => _userProfileData;
  bool get isLoading => _isLoading;

  getCenterProfileData() async {
   
    setLoading(true);
     final id = await AccessToken.getAccessToken();
  
      final snapshot =
          await db.collection('service center').where('sid', isEqualTo: id).get();
      final userData =
          snapshot.docs.map((e) => ServiceCenter.fromSnapshot(e)).single;
      _userProfileData = userData;
      setLoading(false);
      notifyListeners();
    
  }

  setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void signOut(BuildContext context) {
   
      FirebaseAuth.instance.signOut().then((value) {
      
      AccessToken.clearAccessToken();
      GoogleSignIn().disconnect();
      Navigator.of(context).popAndPushNamed(NavigatorClass.loginScreen);
      Provider.of<BottomBarProvider>(context, listen: false)
          .changeBottomNavindex(0);
      notifyListeners();
    });
    notifyListeners();
  }


}
