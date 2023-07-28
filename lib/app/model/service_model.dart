import 'package:cloud_firestore/cloud_firestore.dart';

class Services{
  String? id;
  String? name;
   String? rate;
Services({this.id,this.name,this.rate});

toMap(){
  return{
    "id":id,
    'name':name,
    'rate':rate,
  };
}
factory Services.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snap){
  final serviceData=snap.data()!;
  return Services(
    id:serviceData['id'],
    name:serviceData['name'],
    rate:serviceData['rate'],
  );
}


}