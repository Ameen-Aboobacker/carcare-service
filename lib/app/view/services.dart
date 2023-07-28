import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/global_colors.dart';
import '../Components/service_input.dart';
import '../model/service_model.dart';
import '../view_model/auth_service.dart';

class ServiceDetails extends StatelessWidget {
  const ServiceDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: const Text(
          'Your services',
          style: TextStyle(color: Colors.purple),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<UserProvider>(
          builder: (context, userProvider, _) {
            final serviceCenter = userProvider.serviceCenter;

            if (serviceCenter == null) {
              return const Center(child: Text('No data'));
            }

            return FutureBuilder<List<Services>>(
              future: userProvider.getServicesForServiceCenter(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  log(snapshot.error.toString());
                  return  Center(child: Text('Error occurred:${snapshot.error.toString()}'));
                }

                final serviceList = snapshot.data;

                if (serviceList == null || serviceList.isEmpty) {
                  return const Center(child: Text('No services available'));
                }

                return ListView.separated(
                  itemBuilder: (context, index) {
                    final service = serviceList[index];
                    return ListTile(
                    
                      title: Text(service.name ?? 'NO'),
                      subtitle:  Text(service.rate??'no'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              showDialog(
                                 context: context,
                               builder: (cntxt) => ServiceInput(service: service,provider:userProvider),
                               );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                               userProvider.deleteService(service.id!);
                              // serviceScreenModel.getServiceData(context);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemCount: serviceList.length,
                );
              },
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.appColor,
        onPressed: () {
          showDialog(
            context: context,
            builder: (cntxt) => const ServiceInput(),
          );
        },
        label: const Text('Add services'),
        icon: const Icon(Icons.add_box_outlined),
      ),
    );
  }
}
