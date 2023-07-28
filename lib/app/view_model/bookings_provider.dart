import 'dart:developer';

import 'package:carcareservice/app/model/user_profile_data_modle.dart';
import 'package:carcareservice/user_registration/model/status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/booking_model.dart';
import '../model/center_profile_model.dart';
import '../model/package_model.dart';
import '../model/vehicle_model.dart';

class BookingsProvider extends ChangeNotifier {
  String _count = '0';

  List<Booking> _allBooking = [];
  List<Booking> get allBooking => _allBooking;
  List<Booking> _bookingDataList = [];
  List<Booking> get bookingDataList => _bookingDataList;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String get count => _count;
  List<Booking> _pendingList = [];
  List<Booking> get pendingList => _pendingList;
  List<Booking> _completeList = [];
  List<Booking> get completeList => _completeList;

  Future getBookings(List<String> bookingIds) async {
    final bookingsCollection =
        FirebaseFirestore.instance.collection('bookings');
    final querySnapshot = await bookingsCollection
        .where(FieldPath.documentId, whereIn: bookingIds)
        .get();

    final bookings = querySnapshot.docs.map((doc) {
      final booking = Booking.fromSnapshot(doc);
      return booking;
    }).toList();
    _count = bookings.length.toString();
    await fetchBookingDetails(bookings);
    setBookingDatas(bookings);
    notifyListeners();
  }

  fetchBookingDetails(List<Booking> bookings) async {
    final firestore = FirebaseFirestore.instance;
    final carcollection = firestore.collection('cars');
    final packagecollection = firestore.collection('packages');
    final centercollection = firestore.collection('service center');
    final usercollection = firestore.collection('user');

    for (var booking in bookings) {
      final cardoc = await carcollection.doc(booking.car).get();
      booking.car = Vehicle.fromSnapshot(cardoc);
      final packdoc = await packagecollection.doc(booking.package).get();
      booking.package = PackageModel.fromDocumentSnapshot(packdoc);
      final servicedoc = await centercollection.doc(booking.sId).get();
      booking.sId = ServiceCenter.fromSnapshot(servicedoc);
      final userdoc = await usercollection.doc(booking.userId).get();
      booking.userId = UserProfileDataModel.fromSnapshot(userdoc);
    }
  }

  setBookingLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  setBookingDatas(List<Booking> bookingData) {
    _bookingDataList = bookingData;
    setCompletedList();
    setPendingList();

    notifyListeners();
  }

  setSelectedPopUp(String value) {
    _allBooking.clear();
    if (value == "all") {
      _allBooking = _bookingDataList;
    } else if (value == "pending") {
      _allBooking = _pendingList;
    } else if (value == "completed") {
      _allBooking = _completeList;
    }
    notifyListeners();
  }

  setCompletedList() {
    _completeList.clear();
    for (var element in _bookingDataList) {
      if (element.status == 'completed') {
        _completeList.add(element);
      }
    }
    notifyListeners();
  }

  setPendingList() {
    _pendingList.clear();
    for (var element in _bookingDataList) {
      if (element.status == 'pending') {
        _pendingList.add(element);
      }
    }
    notifyListeners();
  }
  changeStatus(String id,status)async{
    FirebaseFirestore firestore=FirebaseFirestore.instance;
    final snapshot=firestore.collection('bookings').doc(id);
    try {
      if(status=='pending'){
await snapshot.update({'status':'completed'});
 return Success(response:'completed' );
      }
       if(status=='completed'){
await snapshot.update({'status':'pending'});
 return Success(response:'pending' );
      }
      
     
    } catch (e) {
      log(e.toString());
    }finally{
      notifyListeners();
    }
    
  }
}
