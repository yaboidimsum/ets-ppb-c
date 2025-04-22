import 'dart:io';

class Book {
  final String author;
  final String title;
  final String genre;
  final String description;
  final DateTime releaseDate;
  final File image;
  // final String image_link;

  Book({
    required this.author,
    required this.title,
    required this.genre,
    required this.releaseDate,
    required this.description,
    required this.image,
    // required this.image_link,
  });

  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'title': title,
      'genre': genre,
      'description': description,
      'releaseDate': releaseDate.toIso8601String(),
      'image': image.path,
      // 'image_link': image_link,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      author: map['author'],
      title: map['title'],
      genre: map['genre'],
      description: map['description'],
      releaseDate: DateTime.parse(map['releaseDate']),
      image: File(map['image']),
      // image_link: map['image_link'],
    );
  }
}
