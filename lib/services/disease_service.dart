import 'package:AgriSmart/models/disease.dart';

class DiseaseService {
  static List<Disease> _diseases = [
    Disease(
      id: '1',
      name: 'Mildiou de la tomate',
      description: 'Une maladie fongique qui affecte principalement les feuilles et les fruits de tomate.',
      symptoms: [
        'Taches brunes sur les feuilles',
        'Flétrissement des feuilles',
        'Pourriture des fruits',
        'Duvet blanc sous les feuilles'
      ],
      causes: [
        'Humidité élevée',
        'Température fraîche (15-20°C)',
        'Mauvaise circulation d\'air',
        'Arrosage sur les feuilles'
      ],
      treatments: [
        'Pulvériser avec du cuivre',
        'Améliorer la ventilation',
        'Éviter l\'arrosage aérien',
        'Retirer les parties infectées',
        'Traitement préventif avec bicarbonate de soude'
      ],
      severity: 'Élevée',
      imageUrl: 'https://images.unsplash.com/photo-1592921870789-04563d9ee4d5?w=500&h=400&fit=crop',
      plantType: 'Tomate',
    ),
    Disease(
      id: '2',
      name: 'Oïdium',
      description: 'Maladie cryptogamique qui se manifeste par un duvet blanc poudreux.',
      symptoms: [
        'Poudre blanche sur les feuilles',
        'Déformation des feuilles',
        'Jaunissement progressif',
        'Chute prématurée des feuilles'
      ],
      causes: [
        'Humidité relative élevée',
        'Température entre 20-25°C',
        'Manque de lumière',
        'Plants trop serrés'
      ],
      treatments: [
        'Pulvérisation de soufre',
        'Améliorer l\'aération',
        'Traitement au bicarbonate',
        'Éviter l\'excès d\'azote',
        'Éliminer les parties atteintes'
      ],
      severity: 'Modérée',
      imageUrl: 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=500&h=400&fit=crop',
      plantType: 'Multiple',
    ),
    Disease(
      id: '3',
      name: 'Rouille du blé',
      description: 'Maladie fongique qui produit des pustules orange-rouille sur les feuilles.',
      symptoms: [
        'Pustules orange sur les feuilles',
        'Poudre rouille qui se détache',
        'Jaunissement des feuilles',
        'Affaiblissement de la plante'
      ],
      causes: [
        'Humidité et chaleur',
        'Vent qui propage les spores',
        'Variétés sensibles',
        'Rotation insuffisante'
      ],
      treatments: [
        'Fongicides spécifiques',
        'Variétés résistantes',
        'Rotation des cultures',
        'Élimination des résidus',
        'Surveillance précoce'
      ],
      severity: 'Élevée',
      imageUrl: 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=500&h=400&fit=crop',
      plantType: 'Céréales',
    ),
    Disease(
      id: '4',
      name: 'Pourriture grise',
      description: 'Causée par Botrytis cinerea, affecte fruits et légumes.',
      symptoms: [
        'Taches grises duveteuses',
        'Pourriture molle',
        'Spores grises volatiles',
        'Brunissement des tissus'
      ],
      causes: [
        'Humidité excessive',
        'Blessures sur les fruits',
        'Mauvaise ventilation',
        'Températures modérées'
      ],
      treatments: [
        'Réduction de l\'humidité',
        'Améliorer la ventilation',
        'Fongicides préventifs',
        'Récolte rapide des fruits mûrs',
        'Nettoyage des débris'
      ],
      severity: 'Modérée',
      imageUrl: 'https://images.unsplash.com/photo-1560493676-04071c5f467b?w=500&h=400&fit=crop',
      plantType: 'Fruits et légumes',
    ),
    Disease(
      id: '5',
      name: 'Fusariose',
      description: 'Maladie vasculaire qui obstrue les vaisseaux de la plante.',
      symptoms: [
        'Flétrissement unilatéral',
        'Jaunissement des feuilles basses',
        'Brunissement des vaisseaux',
        'Nanisme de la plante'
      ],
      causes: [
        'Champignon du sol',
        'Blessures aux racines',
        'Stress hydrique',
        'Sol mal drainé'
      ],
      treatments: [
        'Améliorer le drainage',
        'Rotation des cultures',
        'Désinfection du sol',
        'Variétés résistantes',
        'Éviter les blessures racinaires'
      ],
      severity: 'Élevée',
      imageUrl: 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=500&h=400&fit=crop',
      plantType: 'Multiple',
    ),
  ];

  static List<Disease> getAllDiseases() => _diseases;

  static List<Disease> getDiseasesByPlantType(String plantType) =>
      _diseases.where((disease) => 
          disease.plantType.toLowerCase().contains(plantType.toLowerCase()) ||
          disease.plantType == 'Multiple'
      ).toList();

  static Disease? getDiseaseById(String id) {
    try {
      return _diseases.firstWhere((disease) => disease.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Disease> searchDiseases(String query) =>
      _diseases.where((disease) =>
          disease.name.toLowerCase().contains(query.toLowerCase()) ||
          disease.description.toLowerCase().contains(query.toLowerCase()) ||
          disease.plantType.toLowerCase().contains(query.toLowerCase())
      ).toList();

  static Disease? analyzeImage(String imagePath) {
    // Mock AI analysis - in reality this would call an ML model
    // For demo purposes, return a random disease with confidence
    if (_diseases.isNotEmpty) {
      return _diseases[DateTime.now().millisecond % _diseases.length];
    }
    return null;
  }

  static getDiseaseByName(String label) {}
}