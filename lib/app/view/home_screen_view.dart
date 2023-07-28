import 'package:carcareservice/app/model/center_profile_model.dart';
import 'package:carcareservice/app/view_model/bookings_provider.dart';
import 'package:carcareservice/utils/global_values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/routes/navigations.dart';
import '../Components/appbar_location.dart';
import '../view_model/auth_service.dart';

class HomeScreenView extends StatelessWidget {
  const HomeScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.read<UserProvider>();
    return Scaffold(
      body: const SafeArea(
        child:Futurebuilds()
        
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text("SIGN OUT"),
                    content: const Text('Are You Sure to Sign Out?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          provider.signOut();
                          Navigator.of(context)
                              .popAndPushNamed(NavigatorClass.loginScreen);
                        },
                        child: const Text('Yes'),
                      ),
                      TextButton(
                        onPressed: () {
                         Navigator.pop(context);
                        },
                        child: const Text('No'),
                      )
                    ],
                  ));
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}

class Futurebuilds extends StatelessWidget {
  const Futurebuilds({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ServiceCenter?>(
      future: context.read<UserProvider>().getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error fetching user data'),
          );
        
        }
          else if(snapshot.data==null){
          return const  Center(child: Text('null'));
          }
         else {
          final userData = snapshot.data;

          return Center(
            child: Column(
              children: [
                 AppBarLocation(center:userData),
                 AppSizes.kHeight50,
                 CardGrid(bookings:userData?.bookings),
              ],
            ),
          );
        }
      },
    );
  }
}

class CardGrid extends StatelessWidget {
  const CardGrid({Key? key, this.bookings}) : super(key: key);
final List<String>?bookings;
  @override
  Widget build(BuildContext context) {
    final bookingView=context.watch<BookingsProvider>();
    bookingView.getBookings(bookings!);
    String totalcount=bookingView.count;
    String pendingcount=bookingView.pendingList.length.toString();
    String completed=(int.parse(totalcount)-int.parse(pendingcount)).toString();
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 50,
      children:  [
        CardItem(
          title: 'Total Bookings',
          value: totalcount,
        ),
       const CardItem(
          title: 'Total Earned',
          value: '\$1000',
        ),
        CardItem(
          title: 'Pending Works',
          value: pendingcount,
        ),
         CardItem(
          title: 'Completed Works',
          value:completed ,
        ),
      ],
    );
  }
}

class CardItem extends StatelessWidget {
  const CardItem({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amber,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
