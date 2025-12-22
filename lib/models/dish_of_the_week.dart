import 'package:cloud_firestore/cloud_firestore.dart';

class DishOfTheWeek {
  String? id;
  final String imageUrl;
  final bool? active;
  final DateTime? uploadedAt;

  DishOfTheWeek({
    this.id,
    required this.imageUrl,
    this.active,
    this.uploadedAt,
  });

  factory DishOfTheWeek.fromFirestore(
      DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DishOfTheWeek(
      id: doc.id,
      imageUrl: data['imageUrl'],
      active: data['active'],
      uploadedAt:
      (data['uploadedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'imageUrl': imageUrl,
      'active': true,
      'uploadedAt': FieldValue.serverTimestamp(),
    };
  }
}
