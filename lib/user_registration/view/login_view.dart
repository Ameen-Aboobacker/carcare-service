// ignore_for_file: unused_local_variable

import 'package:carcareservice/user_registration/view/forget_password_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carcareservice/user_registration/components/login_button_widget.dart';
import 'package:carcareservice/user_registration/components/registering_text_widget.dart';
import 'package:carcareservice/user_registration/components/text_form_field.dart';
import 'package:carcareservice/user_registration/view/sign_up_view.dart';
import 'package:carcareservice/user_registration/view_model/user_login_view_model.dart';
import 'package:carcareservice/utils/routes/navigations.dart';
import '../../utils/global_colors.dart';
import '../../utils/global_values.dart';
import '../../utils/textstyles.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  late final GlobalKey<FormState> loginKey;
  @override
  void initState() {
    loginKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loginModel = context.read<UserLoginViewModel>();

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: loginKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppSizes.kHeight20,
                      Text("Welcome Back", style: AppTextStyles.loginHeading),
                      const Text(
                        "Sign to continue",
                        style: TextStyle(
                          color: AppColors.grey,
                        ),
                      ),
                      AppSizes.kHeight10,
                      TextFormWidget(
                        ismail: true,
                        controller: loginModel.loginEmailCntrllr,
                        labelText: 'Email',
                        textFieldIcon: Icons.email,
                        keyType: TextInputType.emailAddress,
                      ),
                      TextFormWidget(
                        isLoginPass: true,
                        controller: loginModel.loginPasswordCntrllr,
                        labelText: 'Password',
                        textFieldIcon: Icons.lock_outline,
                        keyType: TextInputType.text,
                      ),
                      AppSizes.kHeight10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                NavigatorClass.animatedRoute(
                                  route: ForgetPasswordScreen(),
                                ),
                              );
                              context
                                  .read<UserLoginViewModel>()
                                  .clearController();
                            },
                            child: const Text(
                              "Forgot Password?",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColors.kButtonColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      AppSizes.kHeight30,
                      LoginButtonWidget(
                        isLogin: true,
                        onPressed: () async {
                          await context
                              .read<UserLoginViewModel>()
                              .login(context);
                        },
                        title: "LOGIN",
                      ),
                      AppSizes.kHeight20,
                      Row(
                        children: const [
                          Expanded(
                            child: Divider(thickness: 1.5),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Text("OR"),
                          ),
                          Expanded(
                            child: Divider(thickness: 1.5),
                          ),
                        ],
                      ),
                      AppSizes.kHeight10,
                      InkWell(
                        onTap: () async {
                          loginModel.firebaseGoogleAuth(context);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const[
                             /* Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset("assets/google-logo.png"),
                              ),*/
                              AppSizes.kWidth20,
                               Text(
                                "Continue with google",
                                style: TextStyle(
                                  color: AppColors.appColor,
                                  fontSize: 18,
                                ),
                              ),
                              AppSizes.kWidth30,
                            ],
                          ),
                        ),
                      ),
                      AppSizes.kHeight30,
                      RegisteringText(
                        onTap: () {
                          Navigator.push(
                            context,
                            NavigatorClass.animatedRoute(
                              route: const UserSignUpScreen(),
                            ),
                          );
                          context.read<UserLoginViewModel>().clearController();
                        },
                        leftText: "Don't have account? ",
                        rightText: "Register",
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
