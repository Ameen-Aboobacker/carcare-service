
import 'package:carcareservice/app/view_model/bookings_provider.dart';
import 'package:carcareservice/app/view_model/bottom_bar_provider.dart';
import 'package:carcareservice/user_registration/view_model/forget_password_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../app/view_model/auth_service.dart';
import '../../app/view_model/services_provider.dart';
import '../../user_registration/view_model/sign_up_view_model.dart';
import '../../user_registration/view_model/user_login_view_model.dart';

class ProviderClass {
  static List<SingleChildWidget> provider = [
   ChangeNotifierProvider(
      create: (_) => UserProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => UserLoginViewModel(),
    ),
     ChangeNotifierProvider(
      create: (_) => SignUpViewModel(),
    ),
    ChangeNotifierProvider(
      create: (_) => ServicesProvider(),
    ),
   
    ChangeNotifierProvider(
      create: (_) => BottomBarProvider(),
    ),
     ChangeNotifierProvider(
      create: (_) => ForgetPassViewModel(),
    ),
    ChangeNotifierProvider(
      create: (_) => BookingsProvider(),
    ),
  ];
}
