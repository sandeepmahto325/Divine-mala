import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/models.dart';

class FirestoreService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static String? get _uid => _auth.currentUser?.uid;

  static Future<void> backupStats(UserStats stats) async {
    if (_uid == null) return;
    try {
      await _db
          .collection('users')
          .doc(_uid)
          .collection('data')
          .doc('stats')
          .set(stats.toJson(), SetOptions(merge: true));
    } catch (_) {}
  }

  static Future<UserStats?> restoreStats() async {
    if (_uid == null) return null;
    try {
      final doc = await _db
          .collection('users')
          .doc(_uid)
          .collection('data')
          .doc('stats')
          .get();
      if (doc.exists) {
        return UserStats.fromJson(doc.data()!);
      }
    } catch (_) {}
    return null;
  }

  static Future<void> backupSession(JapSession session) async {
    if (_uid == null) return;
    try {
      await _db
          .collection('users')
          .doc(_uid)
          .collection('sessions')
          .doc(session.id)
          .set(session.toJson());
    } catch (_) {}
  }

  static Future<void> saveUserProfile({
    required String displayName,
    bool isPremium = false,
  }) async {
    if (_uid == null) return;
    await _db.collection('users').doc(_uid).set({
      'displayName': displayName,
      'isPremium': isPremium,
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<void> saveCustomMantra(Mantra mantra) async {
    if (_uid == null) return;
    await _db
        .collection('users')
        .doc(_uid)
        .collection('mantras')
        .doc(mantra.id)
        .set(mantra.toJson());
  }

  static Future<List<Mantra>> getCustomMantras() async {
    if (_uid == null) return [];
    final query = await _db
        .collection('users')
        .doc(_uid)
        .collection('mantras')
        .get();
    return query.docs
        .map((d) => Mantra.fromJson(d.data()))
        .toList();
  }
}
