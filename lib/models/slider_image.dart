import 'package:cloud_firestore/cloud_firestore.dart';

class SliderImage {
  String? id;
  final String imageUrl;
  final bool? active;
  final DateTime? uploadedAt;

  SliderImage({
    this.id,
    required this.imageUrl,
    this.active,
    this.uploadedAt,
  });

  factory SliderImage.fromFirestore(
      DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SliderImage(
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
