class PatologyDetailModel {
  final int id;
  final String label;
  final int parent;
  final String description;
  final String clinicalCharacs;
  final String radiographicalCharacs;
  final String histopathological;
  final String treatment;
  final String imageName;
  final List<String>? extraImages;
  final String url;

  PatologyDetailModel(
      {required this.id,
      required this.label,
      required this.parent,
      required this.description,
      required this.clinicalCharacs,
      required this.radiographicalCharacs,
      required this.histopathological,
      required this.treatment,
      required this.imageName,
      required this.extraImages,
      required this.url});

  factory PatologyDetailModel.fromJson(Map<String, dynamic> json) {
    return PatologyDetailModel(
        id: json['id'],
        label: json['label'],
        parent: json['parent'],
        description: json['description'],
        clinicalCharacs: json['clinicalCharacs'],
        radiographicalCharacs: json['radiographicalCharacs'],
        histopathological: json['histopathological'],
        treatment: json['treatment'],
        imageName: json['imageName'],
        extraImages: json['extraImages'] != null
            ? List<String>.from(json['extraImages'])
            : [],
        url: json['url']);
  }
}
