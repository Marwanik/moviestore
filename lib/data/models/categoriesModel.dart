class categoryModel {
  final int id;
  final String title;

  categoryModel({
    required this.id,
    required this.title,
  });

  factory categoryModel.fromJson(Map<String, dynamic> json) {
    return categoryModel(
      id: json['id'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}
