import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  CollectionReference? _logs;

  FirestoreService() {
    try {
      _logs = FirebaseFirestore.instance.collection('classifications');
    } catch (e) {
      print(
          'Firestore not available (likely missing google-services.json): $e');
    }
  }

  Future<void> logClassification({
    required String label,
    required double confidence,
  }) async {
    if (_logs == null) return;
    try {
      await _logs!.add({
        'label': label,
        'confidence': confidence,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('Logged to Firestore: $label ($confidence)');
    } catch (e) {
      print('Error logging to Firestore: $e');
    }
  }

  // Stream for debugging / future use
  Stream<QuerySnapshot> getLogs() {
    if (_logs == null) return const Stream.empty();
    return _logs!.orderBy('timestamp', descending: true).snapshots();
  }
}
