import 'dart:io';

class Author {
  final String name;
  final int age;
  final DateTime birthdate;
  final File image;

  Author({
    required this.name,
    required this.age,
    required this.birthdate,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'birthdate': birthdate.toIso8601String(),
      'image': image.path,
    };
  }

  factory Author.fromMap(Map<String, dynamic> map) {
    return Author(
      name: map['name'],
      age: map['age'],
      birthdate: DateTime.parse(map['birthdate']),
      image: File(map['image']),
    );
  }
}
