import 'package:cloud_firestore/cloud_firestore.dart';

class Coupon {
  String id;
  double percent;

  Coupon.fromDocument(DocumentSnapshot snapshot){
    if (snapshot != null) {
      id = snapshot.documentID;
      percent = ((snapshot.data['percent'] ?? 0) as num).toDouble();
    }
  }

  Map<String, dynamic> toResumeMap() {
    return {
      'percent': percent, 
    };
  }
}