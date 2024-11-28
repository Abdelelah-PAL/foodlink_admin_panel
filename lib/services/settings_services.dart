import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user_settings.dart';

class SettingsServices with ChangeNotifier {
  final _firebaseFireStore = FirebaseFirestore.instance;

  Future<void> addSettings(userId) async {
    try {
      UserSettings settings = UserSettings(userId: userId, activeNotifications: true, activeUpdates: true);

      await _firebaseFireStore
          .collection('user_settings')
          .add(settings.toMap());
    } catch (ex) {
      rethrow;
    }
  }

  Future<UserSettings> getSettingsByUserId(String id) async {
    try {
      QuerySnapshot<Map<String, dynamic>> settingsQuery =
          await _firebaseFireStore
              .collection('user_settings')
              .where('user_id', isEqualTo: id)
              .limit(1)
              .get();

      UserSettings userSettings = settingsQuery.docs.map((doc) {
        return UserSettings.fromJson(doc.data(), doc.id);
      }).first;
      return userSettings;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changeLanguage(String userId, String language) async {
    try {
      var querySnapshot = await _firebaseFireStore
          .collection('user_settings')
          .where('user_id', isEqualTo: userId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var docId = querySnapshot.docs.first.id;
        _firebaseFireStore.collection('user_settings').doc(docId).update({
          'language': language,
        });
      }
    } catch (ex) {
      rethrow;
    }
  }

  Future<void> toggleNotifications(String userId, bool notifications) async {
    try {
      var querySnapshot = await _firebaseFireStore
          .collection('user_settings')
          .where('user_id', isEqualTo: userId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var docId = querySnapshot.docs.first.id;
        await _firebaseFireStore.collection('user_settings').doc(docId).update({
          'notifications': notifications,
        });
      }
    } catch (ex) {
      rethrow;
    }
  }

  Future<void> toggleUpdates(String userId, bool updates) async {
    try {
      var querySnapshot = await _firebaseFireStore
          .collection('user_settings')
          .where('user_id', isEqualTo: userId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var docId = querySnapshot.docs.first.id;
        await _firebaseFireStore.collection('user_settings').doc(docId).update({
          'updates': updates,
        });
      }
    } catch (ex) {
      rethrow;
    }
  }

}
