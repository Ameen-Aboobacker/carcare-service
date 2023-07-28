import 'dart:io';
import 'package:carcareservice/user_registration/model/firebase_exeptions.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/view_model/auth_service.dart';
import '../../utils/keys.dart';
import '../../utils/routes/navigations.dart';
import '../components/snackbar.dart';
import '../model/status.dart';
import '../model/user_signup_model.dart';

class SignUpViewModel with ChangeNotifier {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirfPassController = TextEditingController();

  bool _isShowPassword = true;
  bool _isShowConfPassword = true;
  bool _isLoading = false;
  UserSignupModel? _userData;
  File? _image;

  UserProvider userp=UserProvider();

  bool get isShowPassword => _isShowPassword;
  bool get isShowConfPassword => _isShowConfPassword;
  bool get isLoading => _isLoading;
  UserSignupModel get userData => _userData!;
  File? get image => _image;

  setshowPassword() {
    _isShowPassword = !_isShowPassword;
    notifyListeners();
  }

  setshowConfPassword() {
    _isShowConfPassword = !_isShowConfPassword;
    notifyListeners();
  }

  checkTextFieldisEmpty() {
    notifyListeners();
  }

  clearTextField() {
    userNameController.clear();
    phoneController.clear();
    passController.clear();
    confirfPassController.clear();
  }

  setLoading(bool loading) async {
    _isLoading = loading;
    notifyListeners();
  }

  signUp(BuildContext context) async {
    final navigator = Navigator.of(context);
    final exception = FirebaseExceptions(context);
    setLoading(true);
    final userData = userSignupData();
    final response = await userp.signUp(userData);
    setLoading(false);
    if (response is Success) {
      navigator.pushNamedAndRemoveUntil(
          NavigatorClass.homeScreen, (route) => false);
    }
    if (response is Failure) {
      exception.cases(response.errorResponse!);
    }

    notifyListeners();
  }

  setSignupStatus(String accessToken) async {
    final status = await SharedPreferences.getInstance();
    await status.setBool(GlobalKeys.userSignedUp, true);
    await status.setString(GlobalKeys.accesToken, accessToken);
  }

  clearPassword() {
    passController.clear();
    confirfPassController.clear();
  }

  UserSignupModel userSignupData() {
    final body = UserSignupModel(
      name: userNameController.text,
      email: emailController.text,
      mobile: phoneController.text,
      password: passController.text,
    );
    return body;
  }

  imagePicker(context) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        return;
      }

      final pickedImage = File(image.path);

      setImage(pickedImage);
      notifyListeners();
    } on PlatformException {
      return SnackBarWidget.snackBar(context, "Something went wrong");
    }
  }

  setImage(File? selectedimage) {
    _image = selectedimage;
    notifyListeners();
  }
}
