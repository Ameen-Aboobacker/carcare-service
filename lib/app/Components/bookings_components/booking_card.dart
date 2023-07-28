import 'package:carcareservice/app/view_model/bookings_provider.dart';
import 'package:carcareservice/user_registration/components/snackbar.dart';
import 'package:carcareservice/user_registration/model/status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carcareservice/utils/global_values.dart';
import 'package:provider/provider.dart';
import '../../../utils/global_colors.dart';
import '../../../utils/textstyles.dart';
import '../../model/booking_model.dart';

class BookingCard extends StatelessWidget {
 final Booking bookingData;
  const BookingCard({
    super.key,
    required this.bookingData,
  });

  @override
  Widget build(BuildContext context) {
        return Card(
        
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              height: 170,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
                     _cardTopSide( context: context,booking:bookingData),
                     _cardBottomSide(bookingData,context),
                ],
              )
              
            ),
          ),
        );
  }

  Expanded _cardBottomSide(Booking booking,context) {
    return Expanded(
      flex: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  const Icon(
                    CupertinoIcons.car_detailed,
                    color: AppColors.appColor,
                    size: 20,
                  ),
                  AppSizes.kWidth10,
                  Text(
                    '${booking.car.model} - ${booking.car.number}',
                    style: AppTextStyles.textH4,
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.add_moderator,
                    color:AppColors.appColor,
                    size: 18,
                  ),
                  AppSizes.kWidth5,
                  Text(
                    booking.package.name,
                    style: AppTextStyles.textH5,
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: (){
                  showDialog(context: context, builder: (context) => AlertDialog(
                    content: const Text('the work completed?'),
                    actions: [
                      OutlinedButton(onPressed: (){
                        final res=context.read<BookingsProvider>().changeStatus(booking.id!,booking.status);
                        if(res is Success){
                          SnackBarWidget.snackBar(context, 'status changed to ${res.response}');
                          Navigator.pop(context);
                        }
                      }, child:const Text('Yes')),
                      OutlinedButton(onPressed: (){
                        Navigator.pop(context);
                      }, child:const  Text('No'))
                    ],
                  ) ,);
                },
                child: Text(booking.status??'',
                style: AppTextStyles.textH4grey,),
              ),
               Text(
                booking.package.price,
                style:const TextStyle(
                  color: AppColors.appColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Expanded _cardTopSide({
    required BuildContext context,
    required Booking booking,
  }) {
   // final bookingViewModel = context.read<BookingViewModel>();
    return Expanded(
      flex: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
             
              Text(
                booking.userId.name??"",
                style: AppTextStyles.textH4,
              ),
              AppSizes.kHeight10,
               Text(
                booking.userId.email??"",
                style: AppTextStyles.textH4,
              ),
              AppSizes.kHeight10,
               Text(
                booking.userId.mobile??"",
                style: AppTextStyles.textH4,
              ),
            ],
          ),
          Text(
            booking.date??"",
            style: AppTextStyles.textH5,
          ),
        ],
      ),
    );
  }
}