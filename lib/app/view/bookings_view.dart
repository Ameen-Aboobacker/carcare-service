import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../utils/global_colors.dart';
import '../../utils/global_values.dart';
import '../Components/bookings_components/booking_card.dart';
import '../Components/bookings_components/bookings_pop_up_button.dart';
import '../view_model/auth_service.dart';
import '../view_model/bookings_provider.dart';

class BookingsView extends StatelessWidget {
  const BookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = context.read<UserProvider>();
    final bookings = userData.serviceCenter?.bookings;
    final bookingDataList = context.watch<BookingsProvider>();
    bookingDataList.getBookings(bookings!);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appColor,
        title: const Text(
          "Bookings",
          style: TextStyle(
            color: AppColors.white,
          ),
        ),
        elevation: 0,
        actions: const [
          BookingsPopUpButton(),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.appColor,
              Color.fromARGB(201, 108, 103, 211),
              Color.fromARGB(255, 171, 168, 214),
              Color.fromARGB(255, 255, 255, 255),
            ],
          ),
        ),
        child: SafeArea(
            child: bookingDataList.allBooking.isEmpty
                ? const Center(child: Text('no Bookings'))
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ListView.separated(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: bookingDataList.allBooking.length,
                        separatorBuilder: (context, index) =>
                            AppSizes.kHeight10,
                        itemBuilder: (context, index) {
                          final booking = bookingDataList.allBooking[index];

                          return BookingCard(
                            bookingData: booking,
                          );
                        }),
                  )),
      ),
    );
  }
}
