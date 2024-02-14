class PatologiesGroupModel {
  final int id;
  final String label;

  PatologiesGroupModel({required this.id, required this.label});

  factory PatologiesGroupModel.fromJson(Map<String, dynamic> json) {
    return PatologiesGroupModel(
      id: json['id'],
      label: json['label'],
    );
  }
}
