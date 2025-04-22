import 'package:flutter/material.dart';
import '../models/model_book.dart';
import '../models/model_author.dart';
import 'card_book.dart';
import 'detail_story.dart';

class BookList extends StatelessWidget {
  final List<MapEntry<dynamic, Book>> books;
  final List<MapEntry<dynamic, Author>> authors;
  final Function(int bookKey, Book book) onEditBook;
  final Function(int bookKey) onDeleteBook;

  const BookList({
    super.key,
    required this.books,
    required this.authors,
    required this.onEditBook,
    required this.onDeleteBook,
  });

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return const Expanded(child: Center(child: Text('No Books available.')));
    }

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Text(
                'Books Available',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: books.length,
              itemBuilder: (context, index) {
                final bookEntry = books[index];
                final book = bookEntry.value;
                final bookKey = bookEntry.key;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailStory(book: book),
                      ),
                    );
                  },
                  child: CardBook(
                    book: book,
                    bookKey: bookKey,
                    onEdit: () => onEditBook(bookKey, book),
                    onDelete: () => onDeleteBook(bookKey),
                  ),
                );

                // return Dismissible(
                //   key: Key('book_${bookKey.toString()}'),
                //   background: Container(
                //     color: Colors.red,
                //     alignment: Alignment.centerRight,
                //     padding: const EdgeInsets.only(right: 20),
                //     child: const Icon(Icons.delete, color: Colors.white),
                //   ),
                //   direction: DismissDirection.endToStart,
                //   onDismissed: (direction) {
                //     onDeleteBook(bookKey);
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       SnackBar(content: Text('${book.title} deleted')),
                //     );
                //   },
                //   child: CardBook(
                //     book: book,
                //     bookKey: bookKey,
                //     onEdit: () => onEditBook(bookKey, book),
                //     onDelete: () => onDeleteBook(bookKey),
                //   ),
                // );
              },
            ),
          ],
        ),
      ),
    );
  }
}
