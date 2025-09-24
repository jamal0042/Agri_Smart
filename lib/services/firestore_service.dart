import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AgriSmart/models/disease.dart';
import 'package:AgriSmart/models/scan_result.dart';

class FirestoreService {
  final CollectionReference _diseasesCollection =
      FirebaseFirestore.instance.collection('maladies');

  // Nouvelle collection pour l'historique
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Disease?> getDiseaseByLabel(String label) async {
    final querySnapshot = await _diseasesCollection
        .where('label_ml', isEqualTo: label)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final data = querySnapshot.docs.first.data() as Map<String, dynamic>;
      // Nous supposons que votre modèle Disease a un constructeur d'usine 'fromJson'
      return Disease.fromJson(data);
    }
    return null;
  }

  // La méthode prend maintenant le userId en paramètre
  Future<void> saveScanResultToCloud(ScanResult result, String userId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('scan_results')
          .doc(result.id)
          .set(result.toJson());
      print('Scan result saved to Firestore!');
    } catch (e) {
      print('Error saving scan result to Firestore: $e');
    }
  }
}
