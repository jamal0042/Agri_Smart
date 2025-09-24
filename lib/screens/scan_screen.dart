import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:AgriSmart/services/storage_service.dart';
import 'package:AgriSmart/models/disease.dart';
import 'package:AgriSmart/models/scan_result.dart';
import 'package:AgriSmart/screens/disease_detail_screen.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:AgriSmart/services/firestore_service.dart';

class ScanScreen extends StatefulWidget {
  // Le userId est maintenant un paramètre requis
  final String userId;

  const ScanScreen({super.key, required this.userId});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  File? _selectedImage;
  Disease? _detectedDisease;
  bool _isAnalyzing = false;
  double _confidence = 0.0;

  final ImagePicker _picker = ImagePicker();
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _detectedDisease = null;
        });
        await _analyzeImage(image.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la sélection de l\'image: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<String> _copyModelToDevice(String assetPath) async {
    final appSupportDir = await getApplicationSupportDirectory();
    final modelFilePath =
        path.join(appSupportDir.path, path.basename(assetPath));
    final modelFile = File(modelFilePath);

    if (!await modelFile.exists()) {
      final byteData = await rootBundle.load(assetPath);
      await modelFile.create(recursive: true);
      await modelFile.writeAsBytes(byteData.buffer.asUint8List());
    }
    return modelFilePath;
  }

  Future<void> _analyzeImage(String imagePath) async {
    setState(() => _isAnalyzing = true);

    try {
      final modelPath = await _copyModelToDevice(
          'assets/models/votre_modele_normalise.tflite');

      final labeler = ImageLabeler(
        options: LocalLabelerOptions(
          confidenceThreshold: 0.5,
          modelPath: modelPath,
        ),
      );

      final inputImage = InputImage.fromFilePath(imagePath);
      final List<ImageLabel> labels = await labeler.processImage(inputImage);
      labeler.close();

      if (labels.isNotEmpty) {
        final topLabel = labels.reduce(
            (curr, next) => curr.confidence > next.confidence ? curr : next);

        final detectedDisease =
            await _firestoreService.getDiseaseByLabel(topLabel.label);

        if (detectedDisease != null) {
          final scanResult = ScanResult(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            diseaseId: detectedDisease.id,
            diseaseName: detectedDisease.name,
            confidence: topLabel.confidence,
            timestamp: DateTime.now(),
            imagePath: imagePath,
            plantType: detectedDisease.plantType,
            severity: detectedDisease.severity,
          );

          // Sauvegarde le résultat avec le userId
          await _firestoreService.saveScanResultToCloud(
              scanResult, widget.userId);

          setState(() {
            _detectedDisease = detectedDisease;
            _confidence = topLabel.confidence;
            _isAnalyzing = false;
          });
          if (mounted) {
            // Affiche un SnackBar en cas de succès
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Analyse et sauvegarde réussies !'),
                backgroundColor: Colors.green,
              ),
            );
          }
          return;
        }
      }
      setState(() => _isAnalyzing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Aucune maladie correspondante trouvée.')),
        );
      }
    } catch (e) {
      setState(() => _isAnalyzing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'analyse: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Scanner une plante'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImageSection(theme),
            const SizedBox(height: 24),
            _buildActionButtons(theme),
            const SizedBox(height: 24),
            if (_isAnalyzing) _buildAnalyzingSection(theme),
            if (_detectedDisease != null) _buildResultSection(theme),
            const SizedBox(height: 24),
            _buildInstructions(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(ThemeData theme) => Container(
        height: 300,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: _selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_rounded,
                    size: 64,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sélectionnez une image',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Photographiez une feuille ou partie de plante malade',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
      );

  Widget _buildActionButtons(ThemeData theme) => Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(Icons.camera_alt_rounded),
              label: const Text('Appareil photo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo_library_rounded),
              label: const Text('Galerie'),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      );

  Widget _buildAnalyzingSection(ThemeData theme) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Analyse en cours...',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Intelligence artificielle en action',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
              ),
            ),
          ],
        ),
      );

  Widget _buildResultSection(ThemeData theme) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Maladie détectée',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _detectedDisease!.name,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Confiance: ${(_confidence * 100).toStringAsFixed(0)}%',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getSeverityColor(theme, _detectedDisease!.severity),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _detectedDisease!.severity,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _detectedDisease!.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSecondaryContainer.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DiseaseDetailScreen(disease: _detectedDisease!),
                  ),
                ),
                icon: const Icon(Icons.visibility_rounded),
                label: const Text('Voir les détails et traitements'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildInstructions(ThemeData theme) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_rounded,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Conseils pour de meilleurs résultats',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...[
              'Photographiez sous une bonne luminosité',
              'Centrez la partie malade de la plante',
              'Évitez les photos floues ou trop sombres',
              'Gardez une distance appropriée',
            ].map(
              (tip) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  tip,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Color _getSeverityColor(ThemeData theme, String severity) {
    switch (severity.toLowerCase()) {
      case 'élevée':
      case 'elevée':
      case 'high':
        return theme.colorScheme.error;
      case 'modérée':
      case 'moderée':
      case 'moderate':
        return Colors.orange;
      case 'faible':
      case 'low':
        return theme.colorScheme.primary;
      default:
        return theme.colorScheme.secondary;
    }
  }
}
