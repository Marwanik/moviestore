import 'package:moviestore/domain/entities/actor.dart';

class actorModel {
  final int id;
  final String name;

  actorModel({
    required this.id,
    required this.name,
  });

  factory actorModel.fromJson(Map<String, dynamic> json) {
    return actorModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  Actor toEntity() {
    return Actor(
      id: id,
      name: name,
    );
  }
}
