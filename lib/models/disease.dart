class Disease {
  final String id;
  final String name;
  final String description;
  final List<String> symptoms;
  final List<String> causes;
  final List<String> treatments;
  final String severity;
  final String imageUrl;
  final String plantType;

  const Disease({
    required this.id,
    required this.name,
    required this.description,
    required this.symptoms,
    required this.causes,
    required this.treatments,
    required this.severity,
    required this.imageUrl,
    required this.plantType,
  });

  factory Disease.fromJson(Map<String, dynamic> json) => Disease(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    symptoms: List<String>.from(json['symptoms']),
    causes: List<String>.from(json['causes']),
    treatments: List<String>.from(json['treatments']),
    severity: json['severity'],
    imageUrl: json['imageUrl'],
    plantType: json['plantType'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'symptoms': symptoms,
    'causes': causes,
    'treatments': treatments,
    'severity': severity,
    'imageUrl': imageUrl,
    'plantType': plantType,
  };
}