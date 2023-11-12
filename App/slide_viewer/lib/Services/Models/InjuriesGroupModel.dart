class InjuriesGroupModel {
  final int id;
  final String label;

  InjuriesGroupModel({required this.id, required this.label});

  factory InjuriesGroupModel.fromJson(Map<String, dynamic> json) {
    return InjuriesGroupModel(
      id: json['id'],
      label: json['label'],
    );
  }
}
