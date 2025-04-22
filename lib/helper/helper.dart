import 'package:hive_flutter/hive_flutter.dart';
import '../models/model_author.dart';
import '../models/model_book.dart';

class AuthorHiveService {
  final Box _authorBox = Hive.box('authorBox');
  final Box _bookBox = Hive.box('bookBox');

  void addAuthor(Author author) => _authorBox.add(author.toMap());

  void updateAuthor(int key, Author author) =>
      _authorBox.put(key, author.toMap());

  void deleteAuthor(int key) {
    // Get Author name first
    final authorMap = Map<String, dynamic>.from(_authorBox.get(key));
    final author = Author.fromMap(authorMap);
    final authorName = author.name;

    // Delete all books where book.author === authorName
    final booksToDelete =
        _bookBox.keys.where((bookKey) {
          final bookMap = Map<String, dynamic>.from(_bookBox.get(bookKey));
          return bookMap['author'] == authorName;
        }).toList();

    for (var bookKey in booksToDelete) {
      _bookBox.delete(bookKey);
    }

    _authorBox.delete(key);
  }

  List<MapEntry<dynamic, Author>> getAllAuthor() {
    return _authorBox.toMap().entries.map((entry) {
      final authorMap = Map<String, dynamic>.from(entry.value);
      return MapEntry(entry.key, Author.fromMap(authorMap));
    }).toList();
  }

  bool authorExists(String username) => _authorBox.containsKey(username);
}

class BookHiveService {
  final Box _bookBox = Hive.box('bookBox');

  void addBook(Book book) => _bookBox.add(book.toMap());

  void updateBook(int key, Book book) => _bookBox.put(key, book.toMap());

  void deleteBook(int key) => _bookBox.delete(key);

  List<MapEntry<dynamic, Book>> getAllBook() {
    return _bookBox.toMap().entries.map((entry) {
      final bookMap = Map<String, dynamic>.from(entry.value);
      return MapEntry(entry.key, Book.fromMap(bookMap));
    }).toList();
  }

  List<MapEntry<dynamic, Book>> getBookByAuthor(String username) {
    return getAllBook()
        .where((entry) => entry.value.author == username)
        .toList();
  }
}
