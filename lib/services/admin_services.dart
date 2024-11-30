import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/admin_details.dart';

class AdminsServices with ChangeNotifier {
  final _firebaseFireStore = FirebaseFirestore.instance;

  Future<void> addAdminDetails(adminDetails) async {
    try {
      AdminDetails admin = AdminDetails(
        adminId: adminDetails.adminId,
        email: adminDetails.email,
        name: adminDetails.name,
      );


      await _firebaseFireStore.collection('admin_details').add(admin.toMap());
    } catch (ex) {
      rethrow;
    }
  }


  Future<QuerySnapshot<Map<String, dynamic>>> getAdminById(String id) async {
    try {
      QuerySnapshot<Map<String, dynamic>> adminQuery = await FirebaseFirestore
          .instance
          .collection('admin_details')
          .where('admin_id', isEqualTo: id)
          .get();

      return adminQuery;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateAdminName(String adminId, int roleId, String name) async {
    try {
      var querySnapshot = await _firebaseFireStore
          .collection('admin_details')
          .where('admin_id', isEqualTo: adminId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var docId = querySnapshot.docs.first.id;
        if (querySnapshot.docs.first['name'] == null &&
            name.isNotEmpty) {
          await _firebaseFireStore
              .collection('admin_details')
              .doc(docId)
              .update({
            'name': name,
          });
        }
      }
    } catch (ex) {
      rethrow;
    }
  }

  Future<AdminDetails?> getAdminByEmail(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> adminQuery = await FirebaseFirestore
          .instance
          .collection('admin_details')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
     if (adminQuery.docs.isEmpty) {
       return null;
     }

      AdminDetails admin = adminQuery.docs.map((doc) {
        return AdminDetails.fromJson(doc.data());
      }).first;

      return admin;
    } catch (e) {
      rethrow;
    }
  }
}
