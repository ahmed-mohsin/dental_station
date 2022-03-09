// Copyright (c) 2021 Aniket Malik [aniketmalikwork@gmail.com]
// All Rights Reserved.
//
// NOTICE: All information contained herein is, and remains the
// property of Aniket Malik. The intellectual and technical concepts
// contained herein are proprietary to Aniket Malik and are protected
// by trade secret or copyright law.
//
// Dissemination of this information or reproduction of this material
// is strictly forbidden unless prior written permission is obtained from
// Aniket Malik.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

abstract class FirestoreService {
  /// Saves the apple login details for the application
  static Future<void> saveAppleLoginDetails({
    @required String userId,
    @required String email,
    @required String fullName,
  }) async {
    final data = {
      'userId': userId,
      'email': email,
      'fullName': fullName,
    };
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      await _firestore.collection('users').doc(userId).set(data);
    } catch (_) {}
  }

  /// Saves the apple login details for the application
  static Future<Map<String, String>> getAppleLoginDetails({
    @required String userId,
  }) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final DocumentSnapshot result =
          await _firestore.collection('users').doc(userId).get();
      if (result.exists) {
        return result.data();
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }
}
