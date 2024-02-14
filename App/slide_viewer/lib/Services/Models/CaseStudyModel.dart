class CaseStudyModel {
  final int id;
  final String label;
  final List<String>? images;
  final String description;

  CaseStudyModel(
      {required this.id,
      required this.label,
      required this.images,
      required this.description});

  factory CaseStudyModel.fromJson(Map<String, dynamic> json) {
    return CaseStudyModel(
      id: json['id'],
      label: json['label'],
      description: json['description'],
      images: json['images'] != null ? List<String>.from(json['images']) : [],
    );
  }
}
