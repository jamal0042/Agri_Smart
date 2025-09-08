class ScanResult {
  final String id;
  final String diseaseId;
  final String diseaseName;
  final double confidence;
  final DateTime timestamp;
  final String imagePath;
  final String plantType;
  final String severity;

  const ScanResult({
    required this.id,
    required this.diseaseId,
    required this.diseaseName,
    required this.confidence,
    required this.timestamp,
    required this.imagePath,
    required this.plantType,
    required this.severity,
  });

  factory ScanResult.fromJson(Map<String, dynamic> json) => ScanResult(
    id: json['id'],
    diseaseId: json['diseaseId'],
    diseaseName: json['diseaseName'],
    confidence: json['confidence'].toDouble(),
    timestamp: DateTime.parse(json['timestamp']),
    imagePath: json['imagePath'],
    plantType: json['plantType'],
    severity: json['severity'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'diseaseId': diseaseId,
    'diseaseName': diseaseName,
    'confidence': confidence,
    'timestamp': timestamp.toIso8601String(),
    'imagePath': imagePath,
    'plantType': plantType,
    'severity': severity,
  };
}