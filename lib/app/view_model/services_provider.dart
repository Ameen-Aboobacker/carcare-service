import 'dart:developer';

import 'package:carcareservice/app/view_model/auth_service.dart';
import 'package:flutter/material.dart';
import '../model/service_model.dart';

class ServicesProvider with ChangeNotifier {
  TextEditingController nameCtrl = TextEditingController();
   TextEditingController rateCtrl = TextEditingController();
  UserProvider userp = UserProvider();
  List<Services> _services = [];

  List<Services> get services => _services;


  setService() {
    return Services(
      name: nameCtrl.text.trim(),
      rate:rateCtrl.text.trim(),
    );
  }

  Future<void> addService(UserProvider p,BuildContext context) async {
    final navigator=Navigator.of(context);
    final service = setService();
    await userp.addService(service);
    p.getUserData();
    navigator.pop();
    notifyListeners();
  }

  Future<List<Services>> getServicesForServiceCenter() async {
    _services = await userp.getServicesForServiceCenter();
    log(_services.toString());
    notifyListeners();
    return _services;
  }
}
