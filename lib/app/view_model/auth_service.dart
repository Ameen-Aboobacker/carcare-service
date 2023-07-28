import 'dart:developer';

import 'package:carcareservice/app/model/booking_model.dart';
import 'package:carcareservice/user_registration/model/firebase_exeptions.dart';
import 'package:carcareservice/user_registration/model/user_login_model.dart';
import 'package:carcareservice/user_registration/model/user_signup_model.dart';
import 'package:carcareservice/utils/routes/navigations.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../user_registration/model/status.dart';

import '../model/center_profile_model.dart';
import '../model/package_model.dart';
import '../model/service_model.dart';
import '../model/user_profile_data_modle.dart';
import '../model/vehicle_model.dart';




class UserProvider with ChangeNotifier {
  ServiceCenter? _serviceCenter;
  ServiceCenter? get serviceCenter => _serviceCenter;
  late FirebaseAuth _auth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  AuthStatus _status = AuthStatus.uninitialized;
  ServiceCenter? se;

  UserProvider() {
    _auth = FirebaseAuth.instance;
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  AuthStatus get status => _status;
  User? get user => _user;

  Future signUp(UserSignupModel userData) async {
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: userData.email!, password: userData.password!);

      _user = userCredential.user;
      userData.id = _user!.uid;

      await _firestore
          .collection('service center')
          .doc(_user!.uid)
          .set(userData.toJson());

      _status = AuthStatus.authenticated;
      return Success();
    } on FirebaseAuthException catch (e) {
      _status = AuthStatus.unauthenticated;
      return Failure(errorResponse: e);
    } finally {
      notifyListeners();
    }
  }

  Future login(UserLoginModel loginData) async {
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();
      final res = await _auth.signInWithEmailAndPassword(
          email: loginData.email!, password: loginData.password!);
      _status = AuthStatus.authenticated;
      return Success(response: res);
    } on FirebaseAuthException catch (e) {
      _status = AuthStatus.unauthenticated;
      return Failure(errorResponse: e);
    } finally {
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void _onAuthStateChanged(User? user) {
    _user = user;
    _status =
        user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<ServiceCenter?> getUserData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('service center').doc(_user!.uid).get();
      if (snapshot.exists) {
        _serviceCenter = ServiceCenter.fromSnapshot(snapshot);
        notifyListeners();
      }
    } catch (e) {
      log('Error fetching user data: $e');
    }

    return _serviceCenter;
  }

  addService(Services service) async {
    final servicesCollection =
        FirebaseFirestore.instance.collection('services');
    final serviceCenterCollection =
        FirebaseFirestore.instance.collection('service center');

    // Add the service to the Services collection
    try {
      final ref = await servicesCollection.add(service.toMap());
      service.id = ref.id;
      servicesCollection.doc(service.id).update(service.toMap());
      log(_user!.uid);
      log(service.id!);
      // Update the serviceIds field in the ServiceCenter collection
      serviceCenterCollection.doc(_user!.uid).update({
        'service': FieldValue.arrayUnion([service.id]),
      });
        await getServicesForServiceCenter();
      return Success();
    } catch (e) {
      log(e.toString());
      return Failure(errorResponse: e);
    } finally {
      notifyListeners();
    }
  }

  Future<List<Services>> getServicesForServiceCenter() async {
  final servicesCollection = FirebaseFirestore.instance.collection('services');
  log(serviceCenter.toString());
  se=serviceCenter;
  final serviceIds = serviceCenter!.services;
  log(serviceIds.toString());
    final querySnapshot = await servicesCollection.where('id', whereIn: serviceIds).get();

    List<Services> services = querySnapshot.docs.map((doc) {
     return  Services.fromSnapshot(doc);
    }).toList();

   
  
  log(services.toString());
  return services;
}
Future deleteService(String service)async{
   final servicesCollection =
        FirebaseFirestore.instance.collection('services');
    final serviceCenterCollection =
        FirebaseFirestore.instance.collection('service center');
final List elements=[];
    // Add the service to the Services collection
    try {
      await servicesCollection.doc(service).delete();
       elements.add(service);
      serviceCenterCollection.doc(_user!.uid).update({
        'service': FieldValue.arrayRemove(elements)
      });
        await getServicesForServiceCenter();
      return Success();
    } catch (e) {
      log(e.toString());
      return Failure(errorResponse: e);
    } finally {
      notifyListeners();
    }
}
 Future<List<Booking>> getBookings() async {
  final bookingsCollection = FirebaseFirestore.instance.collection('bookings');
  log(serviceCenter.toString());
  final bookingIds = serviceCenter!.bookings;
  log(bookingIds.toString());
    final querySnapshot = await bookingsCollection.where('id', whereIn: bookingIds).get();

    List<Booking> bookings = querySnapshot.docs.map((doc) {
     return  Booking.fromSnapshot(doc);
    }).toList();
 await fetchBookingDetails(bookings);

  return bookings;
}


  fetchBookingDetails(List<Booking> bookings) async {
    final firestore = FirebaseFirestore.instance;
    final carcollection = firestore.collection('cars');
    final packagecollection = firestore.collection('packages');
    final centercollection = firestore.collection('service center');

    for (var booking in bookings) {
      final cardoc = await carcollection.doc(booking.car).get();
      booking.car = Vehicle.fromSnapshot(cardoc);
      final packdoc = await packagecollection.doc(booking.package).get();
      booking.package = PackageModel.fromDocumentSnapshot(packdoc);
      final servicedoc = await centercollection.doc(booking.sId).get();
      booking.sId = ServiceCenter.fromSnapshot(servicedoc);
    }
  }


}
