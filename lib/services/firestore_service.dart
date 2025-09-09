import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AgriSmart/models/disease.dart';
import 'package:AgriSmart/models/scan_result.dart';

class FirestoreService {
  final CollectionReference _diseasesCollection = 
      FirebaseFirestore.instance.collection('maladies');
  
  final CollectionReference _scanResultsCollection =
      FirebaseFirestore.instance.collection('scan_results'); // Nouvelle collection pour l'historique

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

  Future<void> saveScanResultToCloud(ScanResult result) async {
    try {
      await _scanResultsCollection.doc(result.id).set(result.toJson());
      print('Scan result saved to Firestore!');
    } catch (e) {
      print('Error saving scan result to Firestore: $e');
    }
  }
}