import 'package:flutter/material.dart';
import '../../utils/global_colors.dart';
import '../../utils/global_values.dart';
import '../model/center_profile_model.dart';

class AppBarLocation extends StatelessWidget {
  final ServiceCenter? center;
  const AppBarLocation({
    
    super.key, this.center,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AppSizes.kWidth10,
         Image.asset('assets/setting-transformed.png',fit: BoxFit.contain,height: 50,),
              
        AppSizes.kWidth20,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            Text(
              center?.name??" ",
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 19,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              center?.place??'',
              style:const TextStyle(
                color: AppColors.black,
                fontSize: 12,
              ),
            ),
          ],
        )
      ],
    );
  }
}
